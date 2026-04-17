//
//  StockDetailViewModelTests.swift
//  MBStockTracker
//
//  Created by Harish on 17/04/2026.
//

import XCTest
@testable import MBStockTracker
import Combine

final class StockDetailViewModelTests: XCTestCase {
    private var sut: StockDetailViewModel!
    private var mockService: MockStockPriceService!
    private var coordinator: MockStockDetailCoordinator!
    private var cancellables: Set<AnyCancellable>!
    private var stock: Stock!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockService = MockStockPriceService()
        coordinator = MockStockDetailCoordinator()
        stock = StockCatalog.all.first { $0.symbol == "AAPL" }
        sut = StockDetailViewModel(coordinator: coordinator,
                                   stock: stock,
                                   stockPriceService: mockService)
    }
    
    override func tearDown() {
        coordinator = nil
        mockService = nil
        stock = nil
        cancellables = nil
        sut = nil
        super.tearDown()
    }

    func test_initialStock() {
        // Arrange
        let expectation = expectation(description: "Should receive initial Stock")
        var receivedStock: Stock?
        // Act
        sut.stock
            .first()
            .sink {
                receivedStock = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        // Asert
        XCTAssertEqual(receivedStock?.symbol, stock.symbol, "Wrong initial stock emitted")
        XCTAssertEqual(receivedStock?.currentPrice, stock.currentPrice, "Price should match with displayed stock")
    }

    func test_priceUpdate() {
        let exp = expectation(description: "Updated AAPL stock received")
        var received: Stock?
        
        sut.stock
            .dropFirst()
            .first()
            .sink {
                received = $0
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        var updated = stock
        updated?.currentPrice  = 999.99
        updated?.previousPrice = stock.currentPrice
        mockService.emit(stock: updated!)
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(received?.currentPrice, 999.99)
    }
    
       func test_priceUpdateNotMatchingSymbol() {
           let exp = expectation(description: "No update received")
           exp.isInverted = true // expectation must NOT be fulfilled — verified by isInverted
    
           sut.stock
               .dropFirst()
               .sink { _ in exp.fulfill() }
               .store(in: &cancellables)
    
           var otherStock = StockCatalog.all.first { $0.symbol == "MSFT" }!
           otherStock.currentPrice = 9999
           mockService.emit(stock: otherStock)
    
           wait(for: [exp], timeout: 0.3)
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
}
