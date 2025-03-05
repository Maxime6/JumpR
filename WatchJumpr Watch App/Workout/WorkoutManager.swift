//
//  WorkoutManager.swift
//  WatchJumpr Watch App
//
//  Created by Maxime Tanter on 31/01/2025.
//

import CoreMotion
import Foundation
import HealthKit
import SwiftData

@MainActor
class WorkoutManager: NSObject, ObservableObject {
    @Published var isWorkoutInProgress = false
    @Published var jumpCount = 0
    @Published var elapsedTime: TimeInterval = 0

    private var workoutSession: HKWorkoutSession?
    private var motionManager: CMMotionManager?
    private var timer: Timer?
    private var lastJumpTime: Date?
    private let modelContext: ModelContext

    // Threshold for jump detection - lowered for better sensitivity
    private let jumpThreshold: Double = 1.2
    // Adding minimum threshold to filter out small movements
    private let minimumThreshold: Double = 0.5

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        super.init()
        motionManager = CMMotionManager()
    }

    func startWorkout() {
        guard let motionManager = motionManager, motionManager.isAccelerometerAvailable else {
            print("Accelerometer not available")
            return
        }

        // Increase sampling rate for better detection
        motionManager.accelerometerUpdateInterval = 0.05
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let data = data else { return }
            self?.detectJump(acceleration: data.acceleration)
        }

        // Start workout session
        isWorkoutInProgress = true
        jumpCount = 0
        elapsedTime = 0

        // Start timer for elapsed time
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.elapsedTime += 1
        }
    }

    func stopWorkout() {
        motionManager?.stopAccelerometerUpdates()
        timer?.invalidate()
        timer = nil
        isWorkoutInProgress = false

        // Save workout data
        let workout = WorkoutData(jumpCount: jumpCount, duration: elapsedTime)
        modelContext.insert(workout)

        do {
            try modelContext.save()
        } catch {
            print("Error saving workout: \(error)")
        }
    }

    private func detectJump(acceleration: CMAcceleration) {
        // Calculate vertical acceleration (y-axis) and total acceleration
        let verticalAcceleration = abs(acceleration.y)
        let totalAcceleration = sqrt(
            pow(acceleration.x, 2) +
                pow(acceleration.y, 2) +
                pow(acceleration.z, 2)
        ) - 1.0 // Subtract gravity

        let currentTime = Date()

        // Check both vertical and total acceleration for better jump detection
        if (verticalAcceleration > jumpThreshold || totalAcceleration > jumpThreshold)
            && totalAcceleration > minimumThreshold
        {
            if let lastJump = lastJumpTime {
                // Reduced minimum time between jumps
                if currentTime.timeIntervalSince(lastJump) > 0.2 {
                    jumpCount += 1
                    lastJumpTime = currentTime
                }
            } else {
                jumpCount += 1
                lastJumpTime = currentTime
            }
        }
    }
}
