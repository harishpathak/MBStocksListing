//
//  Storyboards.swift
//  MBStockTracker
//
//  Created by Harish on 15/04/2026.
//

import UIKit

enum Storyboards: String {
    case main = "Main"
}

extension Storyboards: Instantiable {
    var storyboardIdentifier: String {
        rawValue
    }
}
