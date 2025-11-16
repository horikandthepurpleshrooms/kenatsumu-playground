//
//  ContentView.swift
//  KenatsumuPlayground
//
//  Created by Horik on 16.11.2025.
//

import SwiftUI

struct ContentView: View {
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
        }
    }
}

#Preview {
    ContentView()
}
