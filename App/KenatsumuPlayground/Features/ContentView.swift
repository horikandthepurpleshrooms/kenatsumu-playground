//
//  ContentView.swift
//  KenatsumuPlayground
//
//  Created by Horik on 16.11.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject
    private var entitlementManager: EntitlementManager
    
    @EnvironmentObject
    private var purchaseManager: PurchaseManager
    
    @State private var displayPaywall = false
    
    
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
                }
            }
            .navigationTitle("Playground")
            .sheet(isPresented: $displayPaywall) {
                PremiumInfoSheet(isPresented: $displayPaywall)
            }
        }
    }
}

#Preview {
    ContentView()
}
