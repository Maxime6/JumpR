//
//  UserStats.swift
//  JumpR
//
//  Created by Maxime Tanter on 09/01/2025.
//

import Foundation

struct UserStats: Codable {
    var totalJumps: Int
    var totalWorkouts: Int
    var totalTime: Int
    var totalCaloriesBurned: Int
    var workouts: [Workout]
}
