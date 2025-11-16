//
//  ContentView.swift
//  KenatsumuPlayground
//
//  Created by Horik on 16.11.2025.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct ContentView: View {
    @State private var displayPaywall = false

    func checkEntitlement() async {
        do {
            let customerInfo = try await Purchases.shared.customerInfo()
            print("customerInfo", customerInfo)
            for e in customerInfo.nonSubscriptions {
                print("Non-Subscriptions found:", e)
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Demos") {
                    NavigationLink("CMY Cube") {
                        CMYCubeView()
                            .navigationTitle("CMY Cube")
                    }
                    
                    Button("Present Paywall") {
                        displayPaywall.toggle()
                    }
                    
                    Button("Check Entitlement") {
                        Task {
                            await checkEntitlement()
                        }
                    }
                }
            }
            .navigationTitle("Playground")
            .sheet(isPresented: $displayPaywall) {
                PaywallView()
            }
        }
    }
}

#Preview {
    ContentView()
}
