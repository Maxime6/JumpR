//
//  MotionDataCollector.swift
//  WatchJumpr Watch App
//
//  Created by Maxime Tanter on 08/02/2025.
//

import SwiftUI
import CoreMotion
import Foundation

class MotionDataCollector: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var isRecording: Bool = false
    @Published var jumpCount: String = "" // Manual input
    private var motionData: [[String: Double]] = []
    
    func startRecording() {
        guard motionManager.isDeviceMotionAvailable else { return }
        isRecording = true
        motionData.removeAll()
        
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let self = self, let motion = motion else { return }
            
            let entry: [String: Double] = [
                "timestamp": Date().timeIntervalSince1970,
                "accelX": motion.userAcceleration.x,
                "accelY": motion.userAcceleration.y,
                "accelZ": motion.userAcceleration.z,
                "gyroX": motion.rotationRate.x,
                "gyroY": motion.rotationRate.y,
                "gyroZ": motion.rotationRate.z
            ]
            self.motionData.append(entry)
        }
    }
    
    func stopRecording() {
        isRecording = false
        motionManager.stopDeviceMotionUpdates()
    }
    
    func saveDataToCSV() -> URL? {
        let fileName = "JumpData.csv"
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let documentDirectory = urls.first else { return nil }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
    
        var csvText = "Timestamp,AccelX,AccelY,AccelZ,GyroX,GyroY,GyroZ,JumpCount\n"
    
        for entry in motionData {
            if let timestamp = entry["timestamp"],
               let accelX = entry["accelX"],
               let accelY = entry["accelY"],
               let accelZ = entry["accelZ"],
               let gyroX = entry["gyroX"],
               let gyroY = entry["gyroY"],
               let gyroZ = entry["gyroZ"] {
                
                let row = "\(timestamp),\(accelX),\(accelY),\(accelZ),\(gyroX),\(gyroY),\(gyroZ),\(jumpCount)\n"
                csvText.append(row)
            }
        }
    
        do {
            try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
            print("File saved at: \(fileURL)")
            return fileURL
        } catch {
            print("Failed to save CSV: \(error)")
            return nil
        }
    }
    
    func listSavedFiles() {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let documentDirectory = urls.first else { return }
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            for file in fileURLs {
                print("Saved file: \(file.lastPathComponent)")
            }
        } catch {
            print("Error while listing files: \(error)")
        }
    }
}
