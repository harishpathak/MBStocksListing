//
//  LocalisedConstants.swift
//  MBStockTracker
//
//  Created by Harish on 16/04/2026.
//

enum LocalisedConstants: String {
    case stockListTitle = "StockListTitle"
    case stockDetailsTitle = "StockDetailsTitle"
    case live = "Live"
    case offline = "Offline"
    case loading = "Loading"
    case start = "Start"
    case stop = "Stop"
}

extension LocalisedConstants: Localizable {
    var localizeFileName: String {
        "Stocks-Localizable"
    }

    var localizeKeyName: String {
        rawValue
    }
}
