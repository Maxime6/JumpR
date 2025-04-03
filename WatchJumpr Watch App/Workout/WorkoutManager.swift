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
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var averageHeartRate: Double = 0

    private var workoutSession: HKWorkoutSession?
    private var workoutBuilder: HKLiveWorkoutBuilder?
    private var motionManager: CMMotionManager?
    private var timer: Timer?
    private var lastJumpTime: Date?
    private let modelContext: ModelContext
    private let healthStore = HKHealthStore()

    // Threshold for jump detection - lowered for better sensitivity
    private let jumpThreshold: Double = 1.2
    // Adding minimum threshold to filter out small movements
    private let minimumThreshold: Double = 0.5

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        super.init()
        motionManager = CMMotionManager()
        requestAuthorization()
    }

    private func requestAuthorization() {
        let typesToShare: Set = [
            HKQuantityType.workoutType(),
        ]

        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        ]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { _, error in
            if let error = error {
                print("HealthKit authorization error: \(error.localizedDescription)")
            }
        }
    }

    func startWorkout() {
        guard let motionManager = motionManager, motionManager.isAccelerometerAvailable else {
            print("Accelerometer not available")
            return
        }

        // Configure workout session
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .jumpRope
        configuration.locationType = .indoor

        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            workoutBuilder = workoutSession?.associatedWorkoutBuilder()

            workoutBuilder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)

            workoutSession?.delegate = self
            workoutBuilder?.delegate = self

            // Start workout session
            workoutSession?.startActivity(with: Date())
            workoutBuilder?.beginCollection(withStart: Date()) { _, error in
                if let error = error {
                    print("Error starting workout builder: \(error.localizedDescription)")
                }
            }

        } catch {
            print("Error creating workout session: \(error.localizedDescription)")
            return
        }

        // Increase sampling rate for better detection
        motionManager.accelerometerUpdateInterval = 0.05
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let data = data else { return }
            self?.detectJump(acceleration: data.acceleration)
        }

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

        workoutBuilder?.endCollection(withEnd: Date()) { _, error in
            if let error = error {
                print("Error ending workout builder: \(error.localizedDescription)")
            }
        }

        workoutSession?.end()
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

                    // Add jump count to workout builder
//                    let jumpCountQuantity = HKQuantity(unit: HKUnit.count(), doubleValue: Double(jumpCount))
//                    workoutBuilder?.add([HKQuantitySample(
//                        type: HKQuantityType.quantityType(forIdentifier: .jumpCount)!,
//                        quantity: jumpCountQuantity,
//                        start: currentTime,
//                        end: currentTime
//                    )])
                }
            } else {
                jumpCount += 1
                lastJumpTime = currentTime

                // Add jump count to workout builder
//                let jumpCountQuantity = HKQuantity(unit: HKUnit.count(), doubleValue: Double(jumpCount))
//                workoutBuilder?.add([HKQuantitySample(
//                    type: HKQuantityType.quantityType(forIdentifier: .jumpCount)!,
//                    quantity: jumpCountQuantity,
//                    start: currentTime,
//                    end: currentTime
//                )])
            }
        }
    }
}

// MARK: - HKWorkoutSessionDelegate

extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_: HKWorkoutSession, didChangeTo _: HKWorkoutSessionState, from _: HKWorkoutSessionState, date _: Date) {
        // Handle workout session state changes
    }

    func workoutSession(_: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session failed: \(error.localizedDescription)")
    }
}

// MARK: - HKLiveWorkoutBuilderDelegate

extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { continue }

            let statistics = workoutBuilder.statistics(for: quantityType)

            switch quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
                heartRate = statistics?.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                averageHeartRate = statistics?.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0

            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                activeEnergy = statistics?.sumQuantity()?.doubleValue(for: energyUnit) ?? 0

            default:
                break
            }
        }
    }

    func workoutBuilderDidCollectEvent(_: HKLiveWorkoutBuilder) {
        // Handle workout events
    }
}
