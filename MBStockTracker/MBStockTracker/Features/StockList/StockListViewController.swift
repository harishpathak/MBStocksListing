//
//  StockListViewController.swift
//  MBStockTracker
//
//  Created by Harish on 15/04/2026.
//

import UIKit
import Combine

class StockListViewController: UIViewController {
    @IBOutlet weak var sortOptionsSegmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var connectionStatusLabel: UILabel!
    @IBOutlet weak var toggleFeedButton: UIButton!
    
    var viewModel: StockListViewModelAdaptable?
    private var diffableDataSource: UITableViewDiffableDataSource<StockListSection, StockDisplayModel>?
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        title = LocalisedConstants.stockListTitle.localizedText
    }
    
    private func setupBindings() {
        viewModel?.displayedStocks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stocks in
                guard let self else { return }
                applySnapshot(with: stocks)
            }
            .store(in: &cancellables)
        
        viewModel?.connectionStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.updateConnectionStatus(status: status)
            }
            .store(in: &cancellables)
        
        viewModel?.isFeedActive
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isActive in
                self?.updateFeedButton(isActive: isActive)
            }
            .store(in: &cancellables)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(UINib(nibName: StockListTableViewCell.identifier, bundle: .main), forCellReuseIdentifier: StockListTableViewCell.identifier)
        
        diffableDataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, stock in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StockListTableViewCell.identifier, for: indexPath) as? StockListTableViewCell else { return UITableViewCell() }
            cell.configureUI(with: stock)
            return cell
        })
        
        applySnapshot(with: [])
    }

    private func applySnapshot(with stocks: [StockDisplayModel]) {
        var snapshot: NSDiffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<StockListSection, StockDisplayModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(stocks)
        diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }

    private func updateConnectionStatus(status: ConnectionStatus) {
        connectionStatusLabel.text = status.title
    }

    private func updateFeedButton(isActive: Bool) {
        let title = isActive ? LocalisedConstants.stop.localizedText : LocalisedConstants.start.localizedText
        toggleFeedButton.setTitle(title, for: .normal)
    }

    // MARK: - User Actions -
    
    @IBAction func sortingChanged(_ segmentControl: UISegmentedControl) {
        viewModel?.sortOption = StockListSortOption(rawValue: segmentControl.selectedSegmentIndex) ?? .byPrice
    }

    @IBAction func feedButtonAction(_ sender: UIButton) {
        viewModel?.toggleFeed()
    }
}

extension StockListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedStock = diffableDataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        viewModel?.selectStock(selectedStock)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.stockCellHeight
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.stockCellHeight
    }
}
