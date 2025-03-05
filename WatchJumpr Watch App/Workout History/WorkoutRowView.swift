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