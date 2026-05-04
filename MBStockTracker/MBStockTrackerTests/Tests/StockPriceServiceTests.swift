//
//  StockPriceServiceTests.swift
//  MBStockTracker
//
//  Created by Harish on 17/04/2026.
//

import XCTest
@testable import MBStockTracker
import Combine

final class StockPriceServiceTests: XCTestCase {
    private var sut: StockPriceService!
    private var mockSocketService: MockWebSocketService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockSocketService = MockWebSocketService()
        sut = StockPriceService(webSocketService: mockSocketService)
    }
    
    override func tearDown() {
        mockSocketService = nil
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_initialStocksWithCatalog() {
        let exp = expectation(description: "All stocks seeded")
        var received: [Stock] = []
        
        sut.allStocks
            .first()
            .sink {
                received = $0
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(received.count, StockCatalog.all.count,
                       "allStocks should start with the full catalog")
    }
    
    func test_stockForSymbol() {
        let result = sut.stock(for: "AAPL")
        XCTAssertEqual(result?.symbol, "AAPL", "Same stock should be fetched from registry")
    }
    
    func test_stockForSymbolNotMatching() {
        XCTAssertNil(sut.stock(for: "FAKE"), "Unknown symbol should return nil")
    }
    
    func test_activeFeed() {
        let expectation = expectation(description: "Feed is inactive")
        var isActiveFeed = true // to avoid false positive
        sut.isFeedActive
            .first()
            .sink {
                isActiveFeed = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertFalse(isActiveFeed, "Feed should not be active by default")
    }
    
    func test_toggleFeed() {
        let expectation = expectation(description: "Feed is inactive")
        var isActiveFeed = false // to avoid false positive
        sut.isFeedActive
            .dropFirst()
            .first()
            .sink {
                isActiveFeed = $0
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.toggleFeed() // true
        sut.toggleFeed() // false
        sut.toggleFeed() // true
        
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(isActiveFeed, "Feed should be active when toggled")
    }
    
    func test_echoedPriceUpdate() {
        let exp = expectation(description: "Stock update published")
        var received: Stock?
        
        sut.stockUpdates
            .first()
            .sink {
                received = $0
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        let update = PriceUpdate(symbol: "AAPL", price: 250.0)
        let json = try! JSONEncoder().encode(update)
        mockSocketService.simulateMessage(String(data: json, encoding: .utf8)!)
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(received?.symbol, "AAPL")
        XCTAssertEqual(received?.currentPrice, 250.0, "Updated price should reflect in in emited stock")
    }
    
    func test_connectionStatus() {
        let exp = expectation(description: "Connected status forwarded")
        var received: ConnectionStatus?
        
        sut.connectionStatus
            .dropFirst()
            .first()
            .sink {
                received = $0
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        mockSocketService.connectionStatusSubject.send(.connected)
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(received, .connected, "Should receive connected from websocket")
    }
    
    
}
