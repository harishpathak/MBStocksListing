//
//  WebSocketService.swift
//  MBStockTracker
//
//  Created by Harish on 16/04/2026.
//

import Combine
import Foundation

protocol WebSocketServiceProtocol: AnyObject {
    var connectionStatus: AnyPublisher<ConnectionStatus, Never> { get }
    var receivedMessage: AnyPublisher<String, Never> { get }
 
    func connect()
    func disconnect()
    func send(message: String)
}
 
// MARK: - WebSocketService -
final class WebSocketService: NSObject, WebSocketServiceProtocol {
 
    // MARK: - Publishers -
 
    var connectionStatus: AnyPublisher<ConnectionStatus, Never> {
        connectionStatusSubject.eraseToAnyPublisher()
    }
 
    var receivedMessage: AnyPublisher<String, Never> {
        receivedMessageSubject.eraseToAnyPublisher()
    }
 
    // MARK: - Private Properties -
 
    private let connectionStatusSubject = CurrentValueSubject<ConnectionStatus, Never>(.disconnected)
    private let receivedMessageSubject = PassthroughSubject<String, Never>()
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    private var pingTimer: Timer? // Keep the connection alive on inactivity
 
    private let queue = DispatchQueue(label: "com.stocktracker.websocket", qos: .userInitiated)
 
    // MARK: - Public Interface -
 
    func connect() {
        queue.async { [weak self] in
            guard let self else { return }
            self.establishConnection()
        }
    }
 
    func disconnect() {
        queue.async { [weak self] in
            guard let self else { return }
            self.closeConnection()
        }
    }
 
    func send(message: String) {
        guard connectionStatusSubject.value.isConnected else { return }
        let wsMessage = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(wsMessage) { [weak self] error in
            if let error {
                self?.handleError(error)
            }
        }
    }
 
    // MARK: - Private — Connection Lifecycle -
 
    private func establishConnection() {
        let config = URLSessionConfiguration.default
        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        publish(status: .connecting)
        webSocketTask = urlSession?.webSocketTask(with: Constants.WebSocketConstants.url)
        webSocketTask?.resume()

        startReceiving()
    }
 
    private func closeConnection() {
        stopPingTimer()
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        urlSession?.invalidateAndCancel()
        urlSession = nil
        publish(status: .disconnected)
    }
 
    // MARK: — Receive Loop -
 
    private func startReceiving() {
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let message):
                self.handleMessage(message)
                self.startReceiving() // chain next receive
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
 
    private func handleMessage(_ message: URLSessionWebSocketTask.Message) {
        switch message {
        case .string(let text):
            DispatchQueue.main.async { [weak self] in
                self?.receivedMessageSubject.send(text)
            }
        case .data(let data):
            if let text = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async { [weak self] in
                    self?.receivedMessageSubject.send(text)
                }
            }
        @unknown default:
            break
        }
    }
 
    private func handleError(_ error: Error) {
        publish(status: .disconnected)
    }
 
    // MARK: — Pinging -
 
    private func startPingTimer() {
        stopPingTimer()
        pingTimer = Timer.scheduledTimer(withTimeInterval: Constants.WebSocketConstants.pingInterval, repeats: true) { [weak self] _ in
            self?.sendPing()
        }
        RunLoop.main.add(pingTimer!, forMode: .common) // common is important
    }
 
    private func stopPingTimer() {
        pingTimer?.invalidate()
        pingTimer = nil
    }
 
    private func sendPing() {
        webSocketTask?.sendPing { [weak self] error in
            if let error {
                self?.handleError(error)
            }
        }
    }
 
    // MARK: - Connection Status -
    private func publish(status: ConnectionStatus) {
        DispatchQueue.main.async { [weak self] in
            self?.connectionStatusSubject.send(status)
        }
    }
}
 
// MARK: - URLSessionWebSocketDelegate -
 
extension WebSocketService: URLSessionWebSocketDelegate {
 
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?) {
        queue.async { [weak self] in
            guard let self else { return }
            self.publish(status: .connected)
            DispatchQueue.main.async { self.startPingTimer() }
        }
    }
 
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        queue.async { [weak self] in
            guard let self else { return }
            self.stopPingTimer()
            self.publish(status: .disconnected)
        }
    }
}
