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