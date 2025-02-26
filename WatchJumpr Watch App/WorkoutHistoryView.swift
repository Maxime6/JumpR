import SwiftData
import SwiftUI

struct WorkoutHistoryView: View {
    @Query(sort: \WorkoutData.date, order: .reverse) private var workouts: [WorkoutData]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(workouts) { workout in
                    WorkoutRowView(workout: workout)
                        .padding(.horizontal)
                        .swipeActions {
                            Button(role: .destructive) {
                                modelContext.delete(workout)
                                try? modelContext.save()
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .padding(.vertical)
        }
        .tag(1)
        .tabItem {
            Label("List", systemImage: "list.bullet")
        }
    }
}

struct WorkoutStatsView: View {
    let workouts: [WorkoutData]

    private var totalJumps: Int {
        workouts.reduce(0) { $0 + $1.jumpCount }
    }

    private var averageJumps: Int {
        workouts.isEmpty ? 0 : totalJumps / workouts.count
    }

    private var totalDuration: TimeInterval {
        workouts.reduce(0) { $0 + $1.duration }
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("Statistics")
                .font(.headline)

            HStack {
                StatView(title: "Total", value: "\(totalJumps)", subtitle: "jumps")
                Divider()
                StatView(title: "Average", value: "\(averageJumps)", subtitle: "per session")
            }

            StatView(title: "Total Time", value: formatTotalDuration(totalDuration), subtitle: "")
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(10)
    }

    private func formatTotalDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

struct StatView: View {
    let title: String
    let value: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.title3)
                .bold()
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

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
                        .foregroundColor(.gray)
                }

                Spacer()

                Text(formatDate(workout.date))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(10)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
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
    WorkoutHistoryView()
        .modelContainer(for: WorkoutData.self, inMemory: true)
}
