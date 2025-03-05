//
//  ContentView.swift
//  WatchJumpr Watch App
//
//  Created by Maxime Tanter on 31/01/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var workoutManager: WorkoutManager
    @Query(sort: \WorkoutData.date, order: .reverse) private var workouts: [WorkoutData]

    init(modelContext: ModelContext) {
        _workoutManager = StateObject(wrappedValue: WorkoutManager(modelContext: modelContext))
    }

    var body: some View {
        if workoutManager.isWorkoutInProgress {
            WorkoutView(workoutManager: workoutManager)
        } else {
            TabView {
                StartWorkoutView(workoutManager: workoutManager)
                    .tag(0)
                    .tabItem {
                        Label("Workout", systemImage: "figure.run")
                    }

                WorkoutHistoryView()
                    .tag(1)
                    .tabItem {
                        Label("History", systemImage: "clock")
                    }
                
                ScrollView {
                    if !workouts.isEmpty {
                        WorkoutStatsView(workouts: workouts)
                            .padding(.horizontal)
                            .padding(.top)
                    } else {
                        Text("No workouts yet")
                            .foregroundColor(.gray)
                            .padding(.top)
                    }
                }
                .tag(0)
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
            }
            .tabViewStyle(.verticalPage)
        }
    }
}

#Preview {
    let preview = PreviewContainer()
    preview.addSampleWorkouts(WorkoutData.sampleWorkouts)
    
    return ContentView(modelContext: preview.modelContainer.mainContext)
        .modelContainer(preview.modelContainer)
}
