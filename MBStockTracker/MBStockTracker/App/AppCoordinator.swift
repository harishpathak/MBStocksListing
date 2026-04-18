//
//  AppCoordinator.swift
//  MBStockTracker
//
//  Created by Harish on 15/04/2026.
//

import UIKit

class AppCoordinator: ParentCoordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    weak var parentCoordinator: Coordinator?
    
    func start() {
        let stockListCoordinator = StockListCoordinator(navigationController: navigationController)
        stockListCoordinator.parentCoordinator = self
        childCoordinators.append(stockListCoordinator)
        stockListCoordinator.start()
    }
}
