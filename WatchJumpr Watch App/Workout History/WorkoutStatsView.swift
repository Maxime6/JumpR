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