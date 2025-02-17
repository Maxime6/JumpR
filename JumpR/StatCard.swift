//
//  StatCard.swift
//  JumpR
//
//  Created by Maxime Tanter on 08/02/2025.
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        GlassCard {
            VStack(alignment: .center, spacing: 12) {
                HStack() {
                    Spacer()
                    Image(systemName: icon)
                        .foregroundStyle(color)
                    Text(title)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(color)
            }
            .frame(height: 100)
        }
    }
}

#Preview {
    StatCard(title: "Jumps", value: "137", icon: "figure.jumprope", color: .black)
}
