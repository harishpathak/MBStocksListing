//
//  NSObject+Identifier.swift
//  MBStockTracker
//
//  Created by Harish on 15/04/2026.
//

import UIKit

extension NSObject {
    static var identifier: String {
        String(describing: self)
    }
}
