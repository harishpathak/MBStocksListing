//
//  StockListViewModelTests.swift
//  MBStockTracker
//
//  Created by Harish on 17/04/2026.
//

import XCTest
@testable import MBStockTracker
import Combine

final class StockListViewModelTests: XCTestCase {
    private var sut: StockListViewModel!
    private var mockService: MockStockPriceService!
    private var coordinator: MockStockListCoordinator!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockService = MockStockPriceService()
        coordinator = MockStockListCoordinator()
        sut = StockListViewModel(coordinator: coordinator, stockService: mockService)
    }
    
    override func tearDown() {
        coordinator = nil
        mockService = nil
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_initialStocks() {
        // Arrange
        let expectation = expectation(description: "Should receive initial list of stocks")
        var receivedStocks: [StockDisplayModel] = []
        // Act
        sut.displayedStocks
            .dropFirst() // first would return []
            .first()
            .sink {
                receivedStocks = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        // Asert
        XCTAssertFalse(receivedStocks.isEmpty, "Non-nil Stocks list should be received")
        XCTAssertTrue(receivedStocks.count == StockCatalog.all.count, "All stocks from catalog should return")
    }
    
    func test_sortedDefaultStocks() {
        // Arrange
        let expectation = expectation(description: "Should receive sorted list of stocks")
        var receivedStocks: [StockDisplayModel] = []
        // Act
        sut.displayedStocks
            .dropFirst() // first would return [], second would return default sorting list
            .first()
            .sink {
                receivedStocks = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        // Asert
        XCTAssertFalse(receivedStocks.isEmpty, "Non-nil Stocks list should be received")
        XCTAssertTrue(receivedStocks.first?.symbol == "AVGO", "All stocks from catalog should return sorted by price")
    }
    
    func test_sortedByChangeStocks() {
        // Arrange
        let expectation = expectation(description: "Should receive sorted list of stocks")
        var receivedStocks: [StockDisplayModel] = []
        // Act
        sut.displayedStocks
            .dropFirst(2) // first would return [], second would return default sorting list
            .first()
            .sink {
                receivedStocks = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.sortOption = .byChange
        
        wait(for: [expectation], timeout: 1)
        // Asert
        XCTAssertFalse(receivedStocks.isEmpty, "Non-nil Stocks list should be received")
        XCTAssertTrue(receivedStocks.first?.symbol == "AAPL", "All stocks from catalog should return sorted by change")
    }
    
    func test_feedActiveDefault() {
        // Arrange
        let expectation = expectation(description: "Feed should not be active by default")
        var isActiveFeed = true // to avoid false positive
        // Act
        sut.isFeedActive
            .first()
            .sink {
                isActiveFeed = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        // Asert
        XCTAssertFalse(isActiveFeed, "Feed should not be active by default")
    }
    
    func test_toggleFeed() {
        // Arrange
        let expectation = expectation(description: "Feed should be toggled On")
        var isActiveFeed = false // to avoid false positive
        // Act
        sut.isFeedActive
            .dropFirst() // default feed
            .first()
            .sink {
                isActiveFeed = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.toggleFeed()
        
        wait(for: [expectation], timeout: 1)
        // Asert
        XCTAssertTrue(isActiveFeed, "Feed shoud become active")
    }
    
    func test_didSelectStockNavigation() {
        sut.selectStock(StockDisplayModel(stock: StockCatalog.all.first!))
        XCTAssertTrue(coordinator.movedToStockDetails, "Should call coordinator method for navigation")
    }
    
    func test_priceUpdate() {
        let exp = expectation(description: "Updated stock appears in list")
        var received: [StockDisplayModel] = []
        
        sut.displayedStocks
            .dropFirst(2)
            .first()
            .sink {
                received = $0
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        var updatedStock = StockCatalog.all.first!
        updatedStock.currentPrice  = updatedStock.currentPrice + 50
        updatedStock.previousPrice = updatedStock.currentPrice - 50
        mockService.emit(stock: updatedStock)
        
        wait(for: [exp], timeout: 1)
        
        let stock = received.first { $0.symbol == updatedStock.symbol }
        XCTAssertNotNil(stock, "Updated stock should appear in displayed list")
        XCTAssertEqual(stock?.formattedPrice, updatedStock.displayPrice, "Updated price is not matched with current price")
    }
    
    func test_defaultConnectionStatus() {
        // Arrange
        let expectation = expectation(description: "Feed should be toggled On")
        var connectionStatus: ConnectionStatus = .connected // to avoid false positive
        // Act
        sut.connectionStatus
            .first()
            .sink {
                connectionStatus = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        // Asert
        XCTAssertFalse(connectionStatus.isConnected, "Connection should be disconnected by default")
    }
}
