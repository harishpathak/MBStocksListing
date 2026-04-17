//
//  ConnectionStatus.swift
//  MBStockTracker
//
//  Created by Harish on 16/04/2026.
//

enum ConnectionStatus {
    case connected
    case connecting
    case disconnected
    
    var isConnected: Bool {
        self == .connected
    }

    var title: String {
        switch self {
        case .connected:
            LocalisedConstants.live.localizedText
        case .connecting:
            LocalisedConstants.live.localizedText
        default:
            LocalisedConstants.offline.localizedText
        }
    }
}
