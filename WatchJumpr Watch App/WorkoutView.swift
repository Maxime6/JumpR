//
//  WorkoutView.swift
//  JumpR
//
//  Created by Maxime Tanter on 05/03/2025.
//

import SwiftUI

struct WorkoutView: View {
    @ObservedObject var workoutManager: WorkoutManager
    @State private var showingAdjustment = false

    var body: some View {
        VStack(spacing: 15) {
            Text("\(workoutManager.jumpCount)")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.green)

            Text("Jumps")
                .font(.headline)

            Text(timeString(from: workoutManager.elapsedTime))
                .font(.system(.title3, design: .monospaced))

            Button(action: {
                showingAdjustment = true
            }) {
                Text("End Workout")
                    .foregroundColor(.red)
            }
        }
        .sheet(isPresented: $showingAdjustment) {
            AdjustJumpCountView(
                jumpCount: workoutManager.jumpCount,
                isPresented: $showingAdjustment,
                onSave: { adjustedCount in
                    workoutManager.jumpCount = adjustedCount
                    workoutManager.stopWorkout()
                }
            )
        }
    }

    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
