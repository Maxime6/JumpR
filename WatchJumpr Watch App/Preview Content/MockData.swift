//
//  MockData.swift
//  WatchJumpr Watch App
//
//  Created by Maxime Tanter on 05/03/2025.
//

import Foundation

extension WorkoutData {
    static var sampleWorkouts: [WorkoutData] {
        [
            WorkoutData(jumpCount: 100, duration: 120, date: Date()),
            WorkoutData(jumpCount: 100, duration: 120, date: Date()),
            WorkoutData(jumpCount: 100, duration: 120, date: Date()),
            WorkoutData(jumpCount: 100, duration: 120, date: Date())
        ]
    }
}
