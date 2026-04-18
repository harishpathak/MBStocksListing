//
//  Localizable.swift
//  MBStockTracker
//
//  Created by Harish on 16/04/2026.
//

import Foundation

protocol Localizable {
    var localizeFileName: String { get }
    var localizeKeyName: String { get }
}

extension Localizable {
    var localizedText: String {
        return NSLocalizedString(localizeKeyName, tableName: localizeFileName, bundle: Bundle.main, comment: localizeKeyName)
    }
}
