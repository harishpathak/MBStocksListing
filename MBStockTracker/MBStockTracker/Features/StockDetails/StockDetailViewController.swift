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
    @IBOutlet weak var feedButtonContainer: UIView!
    
    private var cancellables = Set<AnyCancellable>()
    private let feedButtonConfig = FeedButtonConfigModel()
    var viewModel: StockDetailViewModelAdaptable?
    var onDeinit: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        setupNavigationBar()
        setupFeedButton()
    }

    private func setupNavigationBar() {
        title = LocalisedConstants.stockDetailsTitle.localizedText
    }

    private func setupFeedButton() {
        let swiftUIButton = FeedButton(config: feedButtonConfig) {
            self.viewModel?.toggleFeed()
        }
        feedButtonContainer.addSwiftUIView(swiftUIButton, parent: self)
    }

    private func updateUI(stock: Stock) {
        stockSymbolLabel.text = stock.symbol
        stockPriceLabel.text = stock.displayPrice
        descriptionLabel.text = stock.description
    }

    private func updateFeedButtonUI(isActive: Bool) {
        feedButtonConfig.state = isActive ? .stop : .start
    }
    
    private func setupBindings() {
        viewModel?.stock
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stock in
                guard let self else { return }
                self.updateUI(stock: stock)
            }.store(in: &cancellables)
    
        viewModel?.connectionStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connectionStatus in
                self?.feedButtonConfig.disabled = connectionStatus == .connecting
            }
            .store(in: &cancellables)
        
        viewModel?.isFeedActive
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isActive in
                self?.updateFeedButtonUI(isActive: isActive)
            }
            .store(in: &cancellables)
    }
    
    deinit {
        onDeinit?()
    }
}
