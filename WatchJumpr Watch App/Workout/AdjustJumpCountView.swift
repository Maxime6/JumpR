//
//  AdjustJumpCountView.swift
//  JumpR
//
//  Created by Maxime Tanter on 05/03/2025.
//

import SwiftUI

struct AdjustJumpCountView: View {
    @State private var adjustedCount: Int
    @Binding var isPresented: Bool
    let onSave: (Int) -> Void

    init(jumpCount: Int, isPresented: Binding<Bool>, onSave: @escaping (Int) -> Void) {
        _adjustedCount = State(initialValue: jumpCount)
        _isPresented = isPresented
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Adjust Jump Count")
                    .font(.headline)

                HStack {
                    Button(action: { adjustedCount = max(0, adjustedCount - 1) }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                    }
                    .buttonStyle(.plain)

                    Text("\(adjustedCount)")
                        .font(.system(size: 40, weight: .bold))
                        .frame(minWidth: 80)

                    Button(action: { adjustedCount += 1 }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                    .buttonStyle(.plain)
                }
                .padding()

                HStack(spacing: 20) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.red)

                    Button("Save") {
                        onSave(adjustedCount)
                        isPresented = false
                    }
                    .foregroundColor(.green)
                }
            }
            .padding()
        }
    }
}

#Preview {
    AdjustJumpCountView(jumpCount: 100, isPresented: .constant(true), onSave: {_ in })
}
