//
//  FeedButton.swift
//  MBStockTracker
//
//  Created by Harish on 18/04/2026.
//

import SwiftUI

struct FeedButton: View {
    @ObservedObject var config: FeedButtonConfigModel
    let action: VoidClosure
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Text(config.state.title)
                    .font(.headline)
                Image(systemName: config.state.symbol)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(.white)
            .background(RoundedRectangle(cornerRadius: 12.0).fill(config.state == .start ? .theme : .stop))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FeedButton(config: FeedButtonConfigModel(), action:{})
}
