//
//  MockStockPriceService.swift
//  MBStockTracker
//
//  Created by Harish on 17/04/2026.
//

@testable import MBStockTracker
import Combine

final class MockStockPriceService: StockPriceServiceProtocol {
  
    // MARK: - Publishers -
 
    var stockUpdates: AnyPublisher<Stock, Never> {
        stockUpdatesSubject.eraseToAnyPublisher()
    }
 
    var allStocks: AnyPublisher<[Stock], Never> {
        allStocksSubject.eraseToAnyPublisher()
    }
 
    var connectionStatus: AnyPublisher<ConnectionStatus, Never> {
        connectionStatusSubject.eraseToAnyPublisher()
    }
    
    var isFeedActive: AnyPublisher<Bool, Never> {
        activeFeedSubject.eraseToAnyPublisher()
    }
 
    let stockUpdatesSubject = PassthroughSubject<Stock, Never>()
    let allStocksSubject = CurrentValueSubject<[Stock], Never>(StockCatalog.all)
    let connectionStatusSubject = CurrentValueSubject<ConnectionStatus, Never>(.disconnected)
    let activeFeedSubject = CurrentValueSubject<Bool, Never>(false)
 
    // MARK: - Conformance -
 
    func toggleFeed() {
        let feedActive = activeFeedSubject.value
        activeFeedSubject.send(!feedActive)
    }
 
    func stock(for symbol: String) -> Stock? {
        return StockCatalog.all.first { $0.symbol == symbol }
    }
    
    // MARK: - Helpers
    
    func emit(stock: Stock) {
        stockUpdatesSubject.send(stock)
        var stocks = allStocksSubject.value
        if let idx = stocks.firstIndex(where: { $0.symbol == stock.symbol }) {
            stocks[idx] = stock
        }
        allStocksSubject.send(stocks)
    }
    
    func simulateConnect() {
        connectionStatusSubject.send(.connecting)
        connectionStatusSubject.send(.connected)
    }
    
    func simulateDisconnect() {
        connectionStatusSubject.send(.disconnected)
    }
}
