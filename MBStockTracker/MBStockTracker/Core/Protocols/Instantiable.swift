//
//  Instantiable.swift
//  MBStockTracker
//
//  Created by Harish on 15/04/2026.
//

import UIKit

protocol Instantiable {
    var storyboardIdentifier: String { get }
    
    func viewController(with identifier: String) -> UIViewController?
}

extension Instantiable {
    func viewController(with identifier: String) -> UIViewController? {
        return UIStoryboard.viewController(identifier: identifier, fromStoryboard: storyboardIdentifier)
    }
}
