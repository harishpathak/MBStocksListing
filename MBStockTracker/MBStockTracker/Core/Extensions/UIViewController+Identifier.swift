//
//  UIViewController+Identifier.swift
//  MBStockTracker
//
//  Created by Harish on 15/04/2026.
//

import UIKit

extension UIViewController {
    static var identifier: String {
        String(describing: self)
    }
}

extension UITableViewCell {
    static var identifier: String {
        String(describing: self)
    }
}
