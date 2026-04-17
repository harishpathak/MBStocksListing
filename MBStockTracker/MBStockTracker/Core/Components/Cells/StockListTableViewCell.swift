//
//  StockListTableViewCell.swift
//  MBStockTracker
//
//  Created by Harish on 15/04/2026.
//

import UIKit

class StockListTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeIndicator: UIView!
    @IBOutlet weak var backgroundContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialUI()
    }

    private func setupInitialUI() {
        backgroundContainerView.layer.cornerRadius = Constants.mediumCornerRadius
        backgroundContainerView.layer.borderWidth = Constants.defaultBorderWidth
        backgroundContainerView.layer.borderColor = UIColor.themeColor.cgColor
    }
    
    func configureUI(with stock: StockDisplayModel) {
        titleLabel.text = stock.symbol
        priceLabel.text = stock.formattedPrice
        let color: UIColor = stock.priceMovingUp ? .themeColor : .stopColor
        changeIndicator.backgroundColor = color
        priceLabel.textColor = color
    }
}
