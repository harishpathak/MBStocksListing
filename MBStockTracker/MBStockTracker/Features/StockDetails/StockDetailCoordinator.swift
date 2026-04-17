//
//  StockDetailCoordinator.swift
//  MBStockTracker
//
//  Created by Harish on 16/04/2026.
//

import UIKit

protocol StockDetailCoordinated: AnyObject {
}

class StockDetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    var stock: Stock
    var stockPriceService: StockPriceServiceProtocol
    
    init(navigationController: UINavigationController,
         stock: Stock,
         stockPriceService: StockPriceServiceProtocol) {
        self.navigationController = navigationController
        self.stock = stock
        self.stockPriceService = stockPriceService
    }
    
    func start() {
        guard let vc = Storyboards.main.viewController(with: StockDetailViewController.identifier) as? StockDetailViewController else { return }
        vc.onDeinit = handleDeinit
        let viewModel = StockDetailViewModel(coordinator: self,
                                             stock: stock,
                                             stockPriceService: stockPriceService)
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
}

extension StockDetailCoordinator: StockDetailCoordinated {
}

extension StockDetailCoordinator {
    func handleDeinit() {
       (parentCoordinator as? ParentCoordinator)?.childDidFinish(self)
    }
}
