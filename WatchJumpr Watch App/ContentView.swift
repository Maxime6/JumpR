//
//  ContentView.swift
//  WatchJumpr Watch App
//
//  Created by Maxime Tanter on 31/01/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var workoutManager = WorkoutManager()

    var body: some View {
        if workoutManager.isWorkoutInProgress {
            WorkoutView(workoutManager: workoutManager)
        } else {
            StartWorkoutView(workoutManager: workoutManager)
        }
    }
}

struct StartWorkoutView: View {
    @ObservedObject var workoutManager: WorkoutManager

    var body: some View {
        Button(action: {
            workoutManager.startWorkout()
        }) {
            Text("Start")
                .font(.title2)
                .foregroundColor(.blue)
                .padding()
        }
    }
}

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

                    Text("\(adjustedCount)")
                        .font(.system(size: 40, weight: .bold))
                        .frame(minWidth: 80)

                    Button(action: { adjustedCount += 1 }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
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
    ContentView()
}
