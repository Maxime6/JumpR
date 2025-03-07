//
//  WorkoutRowView.swift
//  JumpR
//
//  Created by Maxime Tanter on 05/03/2025.
//

import SwiftUI

struct WorkoutRowView: View {
    let workout: WorkoutData

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(workout.jumpCount) jumps")
                        .font(.headline)

                    Text(formatDuration(workout.duration))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("35 kal")
                        .font(.headline)
                    Text(formatDate(workout.date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(.orange.gradient.opacity(1), in: .rect(cornerRadius: 15))
//        .cornerRadius(10)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    WorkoutRowView(workout: WorkoutData.sampleWorkouts[0])
}
