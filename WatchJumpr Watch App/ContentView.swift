//
//  ContentView.swift
//  WatchJumpr Watch App
//
//  Created by Maxime Tanter on 31/01/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var workoutManager = WorkoutManager()
    
    @StateObject private var motionCollector = MotionDataCollector()
    @State private var showingShareSheet = false
    @State private var exportURL: URL?
    
    var body: some View {
        VStack {
            //            if workoutManager.isWorkoutInProgress {
            //                WorkoutView(workoutManager: workoutManager)
            //            } else {
            //                StartWorkoutView(workoutManager: workoutManager)
            //            }
            
            Text("Jump Rope Tracker")
                .font(.headline)
            
            Text("Recording: \(motionCollector.isRecording ? "ON" : "OFF")")
                .foregroundColor(motionCollector.isRecording ? .green : .red)
            
            Button(motionCollector.isRecording ? "Stop Recording" : "Start Recording") {
                if motionCollector.isRecording {
                    motionCollector.stopRecording()
                } else {
                    motionCollector.startRecording()
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            TextField("Enter Actual Jump Count", text: $motionCollector.jumpCount)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .frame(width: 150)
            
            Button("Save Data") {
                _ = motionCollector.saveDataToCSV()
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(motionCollector.isRecording)
            
            Button("List Saved Files") {
                motionCollector.listSavedFiles()
            }
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

struct StartWorkoutView: View {
    @ObservedObject var workoutManager: WorkoutManager
    
    var body: some View {
        Button(action: {
            workoutManager.startWorkout()
        }) {
            Text("Start Jump Rope")
                .font(.title2)
                .foregroundColor(.green)
        }
    }
}

struct WorkoutView: View {
    @ObservedObject var workoutManager: WorkoutManager
    
    var body: some View {
        VStack(spacing: 15) {
            Text("\(workoutManager.jumpCount)")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.green)
            
            Text("Jumps")
                .font(.headline)
            
            Text(timeString(from: workoutManager.elapsedTime))
                .font(.system(.title3, design: .monospaced))
            
            Button(action: {
                workoutManager.stopWorkout()
            }) {
                Text("End Workout")
                    .foregroundColor(.red)
            }
        }
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}
