//
//  PreviewContainer.swift
//  WatchJumpr Watch App
//
//  Created by Maxime Tanter on 05/03/2025.
//

import Foundation
import SwiftData

struct PreviewContainer {
    let modelContainer: ModelContainer
    
    init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            modelContainer = try ModelContainer(for: WorkoutData.self, configurations: config)
        } catch {
            fatalError("Could not initialized ModelContainer")
        }
    }
    
    func addSampleWorkouts(_ samples: [WorkoutData]) {
        Task { @MainActor in
            samples.forEach { sample in
                modelContainer.mainContext.insert(sample)
            }
        }
    }
}
