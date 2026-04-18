//
//  MockWebSocketService.swift
//  MBStockTracker
//
//  Created by Harish on 17/04/2026.
//

@testable import MBStockTracker
import Combine

final class MockWebSocketService: WebSocketServiceProtocol {
 
    var connectionStatus: AnyPublisher<ConnectionStatus, Never> {
        connectionStatusSubject.eraseToAnyPublisher()
    }
 
    var receivedMessage: AnyPublisher<String, Never> {
        receivedMessageSubject.eraseToAnyPublisher()
    }
 
    let connectionStatusSubject = CurrentValueSubject<ConnectionStatus, Never>(.disconnected)
    let receivedMessageSubject = PassthroughSubject<String, Never>()
 
    // MARK: - Conformance -
 
    func connect() {
        connectionStatusSubject.send(.connecting)
        connectionStatusSubject.send(.connected)
    }
 
    func disconnect() {
        connectionStatusSubject.send(.disconnected)
    }
 
    func send(message: String) {
        receivedMessageSubject.send(message)
    }
    
    // MARK: - Helpers
    
    func simulateMessage(_ message: String) {
        receivedMessageSubject.send(message)
    }
}
 
