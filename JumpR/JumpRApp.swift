//
//  JumpRApp.swift
//  JumpR
//
//  Created by Maxime Tanter on 09/01/2025.
//

import SwiftData
import SwiftUI

@main
struct JumpRApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: WorkoutData.self)
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
