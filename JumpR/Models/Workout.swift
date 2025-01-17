//
//  Workout.swift
//  JumpR
//
//  Created by Maxime Tanter on 09/01/2025.
//

import Foundation
import FirebaseFirestore

enum WorkoutType: String, Codable {
    case free
    case timed
}

struct Workout: Codable, Identifiable {
    @DocumentID var id: String?
    
//    var id = UUID()
    var userId: String
    var type: WorkoutType
    var date: Date
    var jumpCount: Int
    var duration: Int
    var targetDuration: Int?
    var caloriesBurned: Int
}
