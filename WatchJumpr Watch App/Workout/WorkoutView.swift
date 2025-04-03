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
        TabView {
            ZStack {
                Button(action: {
                    showingAdjustment = true
                }) {
                    Text("End Workout")
                        .foregroundColor(.red)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            
            VStack {
                HStack {
                    Image(systemName: "figure.jumprope.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 44, height: 44)
                        .padding(.top, -5)
                        .padding(.leading, 8)
                    
                    Spacer()
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(timeString(from: workoutManager.elapsedTime))
                            .font(.title.bold())
                        
                        HStack {
                            Text("\(workoutManager.jumpCount)")
                                .font(.title2)
                                .foregroundColor(.green)
                            
                            Text("Jumps")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            // TODO: Connect calories manager
                            Text("100")
                                .font(.title2)
                            
                            Text("KCAL")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            // TODO: Connect heart rate manager
                            Text("130")
                                .font(.title2)
                            
                            Image(systemName: "heart.fill")
                                .foregroundStyle(.red)
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
            }
        }
    }

    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    let preview = PreviewContainer()
    WorkoutView(workoutManager: WorkoutManager(modelContext: preview.modelContainer.mainContext))
}
