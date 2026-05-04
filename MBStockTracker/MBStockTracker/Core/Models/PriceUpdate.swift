//
//  PriceUpdate.swift
//  MBStockTracker
//
//  Created by Harish on 16/04/2026.
//

import Foundation

struct PriceUpdate: Codable, Equatable {
    var symbol: String
    var price: Decimal
}
