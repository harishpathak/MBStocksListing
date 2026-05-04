//
//  StockDetailViewModel.swift
//  MBStockTracker
//
//  Created by Harish on 16/04/2026.
//

import Foundation
import Combine
 
protocol StockDetailViewModelAdaptable: AnyObject {
    var stock: AnyPublisher<Stock, Never> { get }
    var isFeedActive: AnyPublisher<Bool, Never> { get }
    var connectionStatus: AnyPublisher<ConnectionStatus, Never> { get }
    
    func toggleFeed()
}
 
final class StockDetailViewModel: StockDetailViewModelAdaptable {
    var stock: AnyPublisher<Stock, Never> {
        stockSubject.eraseToAnyPublisher()
    }
    
    var isFeedActive: AnyPublisher<Bool, Never> {
        stockPriceService.isFeedActive
    }
    
    var connectionStatus: AnyPublisher<ConnectionStatus, Never> {
        stockPriceService.connectionStatus
    }
  
    private let stockSubject: CurrentValueSubject<Stock, Never>
    private let stockPriceService: StockPriceServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private weak var coordinator: StockDetailCoordinated?
 
    init(coordinator: StockDetailCoordinated,
         stock: Stock,
         stockPriceService: StockPriceServiceProtocol) {
        self.stockPriceService = stockPriceService
        self.stockSubject = CurrentValueSubject(stock)
        self.coordinator = coordinator
        bindUpdates(for: stock.symbol)
    }
    
    func toggleFeed() {
        stockPriceService.toggleFeed()
    }
 
    private func bindUpdates(for symbol: String) {
        stockPriceService.stockUpdates
            .filter { $0.symbol == symbol }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedStock in
                self?.stockSubject.send(updatedStock)
            }
            .store(in: &cancellables)
    }
}
