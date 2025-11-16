//
//  EntitlementManager.swift
//  PaperPipe
//
//  Created by Horik on 18.08.2025.
//

import SwiftUI
import Combine

class EntitlementManager: ObservableObject {
    static let userDefaults = UserDefaults(suiteName: "group.KenatsumuPlayground")!

    @Published var hasCMYCubePurchased: Bool {
        didSet {
            Self.userDefaults.set(hasCMYCubePurchased, forKey: "hasCMYCubePurchased")
        }
    }

    init() {
        self.hasCMYCubePurchased = Self.userDefaults.bool(forKey: "hasCMYCubePurchased")
    }
}
