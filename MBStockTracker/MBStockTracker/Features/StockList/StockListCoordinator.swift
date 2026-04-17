//
//  StockListCoordinator.swift
//  MBStockTracker
//
//  Created by Harish on 15/04/2026.
//

import UIKit

protocol StockListCoordinated: AnyObject {
    func moveToStockDetails(stock: Stock, stockPriceService: StockPriceServiceProtocol)
}

class StockListCoordinator: ParentCoordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let stockListVC = Storyboards.main.viewController(with: StockListViewController.identifier) as? StockListViewController else { return }
        let websocketService = WebSocketService()
        let viewModel = StockListViewModel(coordinator: self, stockService: StockPriceService(webSocketService: websocketService))
        stockListVC.viewModel = viewModel
        navigationController.pushViewController(stockListVC, animated: true)
    }
}

extension StockListCoordinator: StockListCoordinated {
    func moveToStockDetails(stock: Stock, stockPriceService: StockPriceServiceProtocol) {
        let stockDetailCoordinator = StockDetailCoordinator(navigationController: navigationController, stock: stock, stockPriceService: stockPriceService)
        stockDetailCoordinator.parentCoordinator = self
        childCoordinators.append(stockDetailCoordinator)
        stockDetailCoordinator.start()
    }
}

