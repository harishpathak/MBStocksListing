//
//  StockDisplayModel.swift
//  MBStockTracker
//
//  Created by Harish on 16/04/2026.
//

import UIKit

nonisolated struct StockDisplayModel: Hashable, Sendable {
    let symbol: String
    let formattedPrice: String
    let priceMovingUp: Bool
    
    init(stock: Stock) {
        self.symbol = stock.symbol
        self.formattedPrice = stock.displayPrice
        self.priceMovingUp = stock.stockGoingUp
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(symbol)
    }
    
    static func == (lhs: StockDisplayModel, rhs: StockDisplayModel) -> Bool {
        return lhs.symbol == rhs.symbol &&
                   lhs.formattedPrice == rhs.formattedPrice
    }
}
