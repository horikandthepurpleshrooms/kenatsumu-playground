//
//  SunriseGradient.swift
//  PaperPipe
//
//  Created by Horik on 19.08.2025.
//

import SwiftUI

struct SunriseGradient: View {
    var body: some View {
        LinearGradient(
            colors: [.softPeach, .softOrange, .warmLightCoral],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    SunriseGradient()
        .frame(height: 200)
        .cornerRadius(12)
}
