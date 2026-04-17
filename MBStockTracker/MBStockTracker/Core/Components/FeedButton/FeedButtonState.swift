//
//  FeedButtonState.swift
//  MBStockTracker
//
//  Created by Harish on 18/04/2026.
//

enum FeedButtonState {
    case start
    case stop
}

extension FeedButtonState {
    var title: String {
        switch self {
        case .start:
            LocalisedConstants.start.localizedText
        case .stop:
            LocalisedConstants.stop.localizedText
        }
    }
    
    var symbol: String {
        switch self {
        case .start:
            "play.fill"
        case .stop:
            "stop.fill"
        }
    }
}
