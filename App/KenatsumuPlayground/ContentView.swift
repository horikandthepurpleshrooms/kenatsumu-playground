//
//  ContentView.swift
//  KenatsumuPlayground
//
//  Created by Horik on 16.11.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Demos") {
                    NavigationLink("CMY Cube") {
                        CMYCubeView()
                            .navigationTitle("CMY Cube")
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
