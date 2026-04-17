//
//  MockStockListCoordinator.swift
//  MBStockTracker
//
//  Created by Harish on 17/04/2026.
//

@testable import MBStockTracker
import UIKit

final class MockStockListCoordinator: StockListCoordinated {
    var movedToStockDetails = false
    func moveToStockDetails(stock: MBStockTracker.Stock,
                            stockPriceService: any MBStockTracker.StockPriceServiceProtocol) {
        movedToStockDetails = true
    }
}
