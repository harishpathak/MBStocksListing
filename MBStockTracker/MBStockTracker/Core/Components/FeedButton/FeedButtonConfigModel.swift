//
//  FeedButtonConfigModel.swift
//  MBStockTracker
//
//  Created by Harish on 18/04/2026.
//

import Combine

class FeedButtonConfigModel: ObservableObject {
    @Published var state: FeedButtonState = .start
}
