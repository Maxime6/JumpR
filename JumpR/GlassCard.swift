//
//  GlassCard.swift
//  JumpR
//
//  Created by Maxime Tanter on 08/02/2025.
//

import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content
    
    var linearGradient: LinearGradient {
        LinearGradient(colors: [.primary.opacity(0.3), .clear, .primary.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            content
                .padding()
                .background(.regularMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(linearGradient)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}
