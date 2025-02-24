import SwiftData
import SwiftUI

struct WorkoutHistoryView: View {
    @Query(sort: \WorkoutData.date, order: .reverse) private var workouts: [WorkoutData]

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Recent Activities")
                    .font(.headline)

                if workouts.isEmpty {
                    Text("No workouts yet")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(workouts.prefix(5)) { workout in
                        WorkoutRow(workout: workout)
                    }
                }
            }
        }
    }
}

struct WorkoutRow: View {
    let workout: WorkoutData

    var body: some View {
        HStack {
            Image(systemName: "figure.jumprope")
                .foregroundStyle(.blue)

            VStack(alignment: .leading) {
                Text("Jump Rope Session")
                    .font(.subheadline)
                Text("\(workout.jumpCount) jumps • \(formatDuration(workout.duration))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(formatRelativeDate(workout.date))
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        if minutes == 0 {
            return "\(Int(duration))s"
        }
        let seconds = Int(duration) % 60
        return "\(minutes)m \(seconds)s"
    }

    private func formatRelativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
