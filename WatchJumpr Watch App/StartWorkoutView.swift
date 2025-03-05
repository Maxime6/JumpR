//
//  StartWorkoutView.swift
//  JumpR
//
//  Created by Maxime Tanter on 05/03/2025.
//

import SwiftUI

struct StartWorkoutView: View {
    @ObservedObject var workoutManager: WorkoutManager

    var body: some View {
        VStack(spacing: 20) {
            Text("Ready to Jump?")
                .font(.title3)
                .padding(.top)

            Button(action: {
                workoutManager.startWorkout()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "figure.jumprope")
                        .font(.system(size: 30))
                    Text("Start")
                        .font(.headline)
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
