//
//  UIStoryboard+ViewController.swift
//  MBStockTracker
//
//  Created by Harish on 15/04/2026.
//

import UIKit

extension UIStoryboard {
    static func viewController(identifier: String, fromStoryboard: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: fromStoryboard, bundle: Bundle.main)
        let returnController = storyboard.instantiateViewController(withIdentifier: identifier)
        return returnController
    }
}
