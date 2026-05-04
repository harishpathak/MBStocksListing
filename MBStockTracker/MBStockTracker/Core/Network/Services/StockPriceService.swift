//
//  StocksService.swift
//  MBStockTracker
//
//  Created by Harish on 16/04/2026.
//

import Combine
import Foundation

protocol StockPriceServiceProtocol: AnyObject {
    var stockUpdates: AnyPublisher<Stock, Never> { get }
    var allStocks: AnyPublisher<[Stock], Never> { get }
    var connectionStatus: AnyPublisher<ConnectionStatus, Never> { get }
    var isFeedActive: AnyPublisher<Bool, Never> { get }
 
    func toggleFeed()
    func stock(for symbol: String) -> Stock?
}
 
// MARK: - StockPriceService -
 
/// Owns the symbol registry, drives randomised price ticks via the WebSocket
/// echo mechanism, and distributes `Stock` updates through Combine.
///
/// Flow:
///   1. `startFeed()` → connects WebSocket, fires a tick timer.
///   2. Every tick: pick a random symbol, build a `PriceUpdate` JSON payload,
///      send it over the WebSocket.
///   3. Echo server reflects the message back.
///   4. Service parses the echo, applies the new price to the local `Stock`,
///      and publishes the updated `Stock`.
final class StockPriceService: StockPriceServiceProtocol {
 
    // MARK: - Publishers -
 
    var stockUpdates: AnyPublisher<Stock, Never> {
        stockUpdatesSubject.eraseToAnyPublisher()
    }
 
    var allStocks: AnyPublisher<[Stock], Never> {
        allStocksSubject.eraseToAnyPublisher()
    }
 
    var connectionStatus: AnyPublisher<ConnectionStatus, Never> {
        webSocketService.connectionStatus
    }

    var isFeedActive: AnyPublisher<Bool, Never> {
        activeFeedSubject.eraseToAnyPublisher()
    }
 
    // MARK: - Private Properties -
 
    private let webSocketService: WebSocketServiceProtocol
    private let stockUpdatesSubject = PassthroughSubject<Stock, Never>()
    private let allStocksSubject = CurrentValueSubject<[Stock], Never>([])
    private let activeFeedSubject = CurrentValueSubject<Bool, Never>(false)
 
    /// Thread-safe stock registry, keyed by symbol.
    private var registry: [String: Stock] = [:]
    private let registryQueue = DispatchQueue(label: "com.stocktracker.registry", attributes: .concurrent)
 
    private var tickTimer: DispatchSourceTimer?
    private var cancellables = Set<AnyCancellable>()
    private let encoder = JSONEncoder()
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        return d
    }()
 
    // MARK: - Init -
 
    init(webSocketService: WebSocketServiceProtocol) {
        self.webSocketService = webSocketService
        seedRegistry()
        bindWebSocket()
    }
 
    // MARK: - Public Interface -
    
    func toggleFeed() {
        if activeFeedSubject.value {
            stopFeed()
        } else {
            startFeed()
        }
    }
 
    func stock(for symbol: String) -> Stock? {
        registryQueue.sync { registry[symbol] }
    }
 
    // MARK: - Private — Setup -
    
    private func startFeed() {
        webSocketService.connect()
        startTickTimer()
        activeFeedSubject.send(true)
    }
 
    private func stopFeed() {
        stopTickTimer()
        webSocketService.disconnect()
        activeFeedSubject.send(false)
    }
 
    private func seedRegistry() {
        var dict: [String: Stock] = [:]
        StockCatalog.all.forEach { dict[$0.symbol] = $0 }
        registry = dict
        allStocksSubject.send(StockCatalog.all)
    }
 
    private func bindWebSocket() {
        webSocketService.receivedMessage
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .sink { [weak self] message in
                self?.handleEchoedMessage(message)
            }
            .store(in: &cancellables)
    }
 
    // MARK: — Tick Timer -
 
    private func startTickTimer() {
        stopTickTimer()
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .userInitiated))
        timer.schedule(deadline: .now() + Constants.StockPriceServiceConstants.tickInterval,
                       repeating: Constants.StockPriceServiceConstants.tickInterval,
                       leeway: .milliseconds(50))
        timer.setEventHandler { [weak self] in
            self?.sendRandomPriceTick()
        }
        timer.resume()
        tickTimer = timer
    }
 
    private func stopTickTimer() {
        tickTimer?.cancel()
        tickTimer = nil
    }
 
    // MARK: — Price Simulation -
 
    private func sendRandomPriceTick() {
        let symbols = registryQueue.sync { Array(registry.keys) }
        guard !symbols.isEmpty else { return }
        let symbol = symbols.randomElement()!
 
        let currentPrice = registryQueue.sync { registry[symbol]?.currentPrice ?? 100 }
        let delta = currentPrice * Decimal(Double.random(in: -Constants.StockPriceServiceConstants.maxDeltaPercent...Constants.StockPriceServiceConstants.maxDeltaPercent))
        let newPrice = max(0.01, currentPrice + delta)
 
        let update = PriceUpdate(symbol: symbol, price: newPrice)
 
        guard let data = try? encoder.encode(update),
              let json = String(data: data, encoding: .utf8) else { return }
 
        webSocketService.send(message: json)
    }
 
    private func handleEchoedMessage(_ message: String) {
        guard let data   = message.data(using: .utf8),
              let update = try? decoder.decode(PriceUpdate.self, from: data) else { return }
 
        applyUpdate(update)
    }
 
    private func applyUpdate(_ update: PriceUpdate) {
        registryQueue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            guard var stock = self.registry[update.symbol] else { return }
 
            stock.previousPrice = stock.currentPrice
            stock.currentPrice = update.price
 
            self.registry[update.symbol] = stock
 
            let snapshot = Array(self.registry.values)
 
            DispatchQueue.main.async {
                self.stockUpdatesSubject.send(stock)
                self.allStocksSubject.send(snapshot)
            }
        }
    }
}
