//
//  Constants.swift
//  MBStockTracker
//
//  Created by Harish on 16/04/2026.
//

import Foundation

enum Constants {
    enum WebSocketConstants {
        static let url = URL(string: "wss://ws.postman-echo.com/raw")!
        static let pingInterval: TimeInterval = 20.0
    }
    enum StockPriceServiceConstants {
        static let tickInterval: TimeInterval = 1.2
        static let maxDeltaPercent: Double = 0.015
    }
    
    static let stockCellHeight: CGFloat = 80.0
    static let mediumCornerRadius: CGFloat = 12.0
    static let defaultBorderWidth: CGFloat = 1.0
}
