//
//  Stock.swift
//  MBStockTracker
//
//  Created by Harish on 15/04/2026.
//

import Foundation

nonisolated struct Stock: Identifiable {
    let id: String
    let symbol: String
    let companyName: String
    let sector: String
    var description: String
    var currentPrice: Decimal
    var previousPrice: Decimal
    
    var displayPrice: String {
        currentPrice.toCurrency()
    }
    
    var stockGoingUp: Bool {
        currentPrice > previousPrice
    }
    
    var priceChange: Decimal {
        currentPrice - previousPrice
    }
    
    var priceChangePercent: Decimal {
        guard previousPrice != 0 else { return 0 }
        return (priceChange / previousPrice) * 100
    }
}
