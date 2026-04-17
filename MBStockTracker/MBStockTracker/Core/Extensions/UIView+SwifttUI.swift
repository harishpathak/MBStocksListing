//
//  UIView+SwifttUI.swift
//  MBStockTracker
//
//  Created by Harish on 18/04/2026.
//

import UIKit
import SwiftUI

extension UIView {
    func addSwiftUIView<Content: View>(_ swiftUIView: Content, parent: UIViewController) {
        // 1. Wrap the SwiftUI view in a Hosting Controller
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // 2. Add as a child to the parent view controller
        parent.addChild(hostingController)
        
        // 3. Prepare the hosting view
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear // Keeps your UIView background
        
        self.addSubview(hostingController.view)
        
        // 4. Setup Auto Layout constraints
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: self.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        // 5. Notify the hosting controller it has moved to its new parent
        hostingController.didMove(toParent: parent)
    }
}
