//
//  StockListViewModel.swift
//  MBStockTracker
//
//  Created by Harish on 15/04/2026.
//

import Combine
import Foundation

protocol StockListViewModelAdaptable: AnyObject {    
    var displayedStocks:  AnyPublisher<[StockDisplayModel], Never> { get }
    var connectionStatus: AnyPublisher<ConnectionStatus, Never> { get }
    var isFeedActive: AnyPublisher<Bool, Never> { get }
    
    // Inputs
    var sortOption: StockListSortOption { get set }
    func toggleFeed()
    func selectStock(_ stock: StockDisplayModel)
}

final class StockListViewModel: StockListViewModelAdaptable {
    var displayedStocks: AnyPublisher<[StockDisplayModel], Never> {
        displayedStocksSubject
            .map({ stocks in
                stocks.map { StockDisplayModel(stock: $0) }
            })
            .eraseToAnyPublisher()
    }
    
    var connectionStatus: AnyPublisher<ConnectionStatus, Never> {
        stockPriceService.connectionStatus
    }
    
    var isFeedActive: AnyPublisher<Bool, Never> {
        stockPriceService.isFeedActive
    }
    
    var sortOption: StockListSortOption = .byPrice {
        didSet { applySort() }
    }
    
    // MARK: - Private -
    private weak var coordinator: StockListCoordinated?
    private let stockPriceService: StockPriceServiceProtocol
    private let displayedStocksSubject = CurrentValueSubject<[Stock], Never>([])
    private var latestStocks: [Stock]  = []
    private var cancellables = Set<AnyCancellable>()
    
    
    init(coordinator: StockListCoordinated, stockService: StockPriceServiceProtocol) {
        self.coordinator = coordinator
        self.stockPriceService = stockService
        bindService()
    }
    
    func toggleFeed() {
        stockPriceService.toggleFeed()
    }
    
    func selectStock(_ stock: StockDisplayModel) {
        guard let current = stockPriceService.stock(for: stock.symbol) else { return }
        coordinator?.moveToStockDetails(stock: current, stockPriceService: stockPriceService)
    }
}

private extension StockListViewModel {
    private func bindService() {
        stockPriceService.allStocks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stocks in
                guard let self else { return }
                self.latestStocks = stocks
                self.applySort()
            }
            .store(in: &cancellables)
    }
    
    private func applySort() {
        let sorted: [Stock]
        switch sortOption {
        case .byPrice:
            sorted = latestStocks.sorted { $0.currentPrice > $1.currentPrice }
        case .byChange:
            sorted = latestStocks.sorted { $0.priceChangePercent > $1.priceChangePercent }
        }
        displayedStocksSubject.send(sorted)
    }
}
