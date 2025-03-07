import SwiftData
import SwiftUI

struct WorkoutHistoryView: View {
    @Query(sort: \WorkoutData.date, order: .reverse) private var workouts: [WorkoutData]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ScrollView {
            HStack {
                Text("Last activities")
                    .font(.headline)
                    .padding(.leading, 10)
                Spacer()
            }

            LazyVStack(spacing: 10) {
                ForEach(workouts) { workout in
                    SwipeAction(cornerRadius: 15, direction: .trailing) {
                        WorkoutRowView(workout: workout)
                    } actions: {
                        Action(tint: .red, icon: "trash.fill", iconfont: .callout) {
                            modelContext.delete(workout)
                            try? modelContext.save()
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

struct SwipeAction<Content: View>: View {
    var cornerRadius: CGFloat = 0
    var direction: SwipeDirection = .trailing
    
    @ViewBuilder var content: Content
    @ActionBuilder var actions: [Action]
    
    let viewID = UUID()
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    content
                        .containerRelativeFrame(.horizontal)
                        .background {
                            if let firstAction = actions.first {
                                Rectangle()
                                    .fill(firstAction.tint)
                            }
                        }
                        .id(viewID)
                    
                    ActionButtons {
                        withAnimation(.snappy) {
                            scrollProxy.scrollTo(viewID, anchor: direction == .trailing ? .topLeading : .topTrailing)
                        }
                    }
                }
                .scrollTargetLayout()
                .visualEffect { content, geometryProxy in
                    content
                        .offset(x: scrollOffset(geometryProxy))
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .background {
                if let lastAction = actions.last {
                    Rectangle()
                        .fill(lastAction.tint)
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
        }
    }
    
    @ViewBuilder
    func ActionButtons(resetPosition: @escaping () -> ()) -> some View {
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(actions.count * 50))
            .overlay(alignment: direction.alignment) {
                HStack(spacing: 0) {
                    ForEach(actions) { button in
                        Button {
                            Task {
                                resetPosition()
                                try? await Task.sleep(for: .seconds(0.25))
                                button.action()
                            }
                        } label: {
                            Image(systemName: button.icon)
                                .font(button.iconfont)
                                .foregroundStyle(button.iconTint)
                                .frame(width: 50)
                                .frame(maxHeight: .infinity)
                                .contentShape(.rect)
                        }
                        .buttonStyle(.plain)
                        .background(button.tint)
                    }
                }
            }
    }
    
    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        
        return direction == .trailing ? (minX > 0 ? -minX : 0) : (minX < 0 ? -minX : 0)
    }
}

enum SwipeDirection {
    case leading
    case trailing
    
    var alignment: Alignment {
        switch self {
        case .leading:
                .leading
        case .trailing:
                .trailing
        }
    }
}

struct Action: Identifiable {
    private(set) var id: UUID = UUID()
    var tint: Color
    var icon: String
    var iconfont: Font = .title
    var iconTint: Color = .white
    var isEnabled: Bool = true
    var action: () -> ()
}

@resultBuilder
struct ActionBuilder {
    static func buildBlock(_ components: Action...) -> [Action] {
        return components
    }
}
