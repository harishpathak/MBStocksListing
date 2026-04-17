//
//  StockDetailViewController.swift
//  MBStockTracker
//
//  Created by Harish on 16/04/2026.
//

import UIKit
import Combine

class StockDetailViewController: UIViewController {
    @IBOutlet weak var stockSymbolLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var stockPriceLabel: UILabel!
    @IBOutlet weak var toggleFeedButton: UIButton!
    
    private var cancellables = Set<AnyCancellable>()
    var viewModel: StockDetailViewModelAdaptable?
    var onDeinit: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        title = LocalisedConstants.stockDetailsTitle.localizedText
    }

    private func updateUI(stock: Stock) {
        stockSymbolLabel.text = stock.symbol
        stockPriceLabel.text = stock.displayPrice
        descriptionLabel.text = stock.description
    }

    private func updateFeedButtonUI(isActive: Bool) {
        let title = isActive ? LocalisedConstants.stop.localizedText : LocalisedConstants.start.localizedText
        toggleFeedButton.setTitle(title, for: .normal)
    }
    
    private func setupBindings() {
        viewModel?.stock
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stock in
                guard let self else { return }
                self.updateUI(stock: stock)
            }.store(in: &cancellables)
    
        viewModel?.isFeedActive
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isActive in
                self?.updateFeedButtonUI(isActive: isActive)
            }
            .store(in: &cancellables)
    }
    
    @IBAction func toggleFeedAction(_ sender: UIButton) {
        viewModel?.toggleFeed()
    }
    
    deinit {
        onDeinit?()
    }
}
