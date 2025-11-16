//
//  KenatsumuPlaygroundApp.swift
//  KenatsumuPlayground
//
//  Created by Horik on 16.11.2025.
//

import SwiftUI
import RevenueCat

@main
struct KenatsumuPlaygroundApp: App {
    init() {
        Purchases.configure(withAPIKey: "test_RPNaPMqrzNMJoCirhdQpvTgeJwd")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
