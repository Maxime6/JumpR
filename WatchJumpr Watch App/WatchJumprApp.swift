//
//  WatchJumprApp.swift
//  WatchJumpr Watch App
//
//  Created by Maxime Tanter on 31/01/2025.
//

import SwiftData
import SwiftUI

@main
struct WatchJumpr_Watch_AppApp: App {
    let container: ModelContainer

    init() {
        do {
            let schema = Schema([
                WorkoutData.self,
            ])
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false, cloudKitDatabase: .automatic
            )
            container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
        }
        .modelContainer(container)
    }
}
