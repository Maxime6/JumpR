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

#Preview {
    let preview = PreviewContainer()
    preview.addSampleWorkouts(WorkoutData.sampleWorkouts)
    
    return WorkoutHistoryView()
        .modelContainer(preview.modelContainer)
}
