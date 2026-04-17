//
//  Extensions.swift
//  MBStockTracker
//
//  Created by Harish on 16/04/2026.
//

import Foundation

extension Decimal {
    nonisolated func toCurrency() -> String {
        return String(format: "$%.2f", NSDecimalNumber(decimal: self).doubleValue)
    }
}
