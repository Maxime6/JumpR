//
//  HomeView.swift
//  JumpR
//
//  Created by Maxime Tanter on 08/02/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var userName = "Maxime" // Later connect to UserDefaults or your data source
    
    // Sample data - connect to your actual data source
    let totalJumps = 1234
    let totalCalories = 567
    let totalMinutes = 45
    let weeklyProgress = 0.75
    
    var body: some View {
        ZStack {
            // Content
            ScrollView {
                VStack(spacing: 24) {
                    // Welcome Header
                    welcomeSection
                    
                    VStack {
                        HStack {
                            StatCard(
                                title: "Total Jumps",
                                value: "\(totalJumps)",
                                icon: "figure.jumprope",
                                color: .blue
                            )
                            
                            StatCard(
                                title: "Calories",
                                value: "\(totalCalories)",
                                icon: "flame.fill",
                                color: .orange
                            )
                        }
                        
                        HStack {
                            StatCard(
                                title: "Active Minutes",
                                value: "\(totalMinutes)min",
                                icon: "clock.fill",
                                color: .green
                            )
                            
                            StatCard(
                                title: "Weekly Goal",
                                value: "\(Int(weeklyProgress * 100))%",
                                icon: "chart.bar.fill",
                                color: .purple
                            )
                        }
                    }
                    
                    // Stats Grid
//                    LazyVGrid(columns: [
//                        GridItem(.flexible()),
//                        GridItem(.flexible())
//                    ], spacing: 16) {
//                        
//                        
//                        
//                    }
                    
                    // Weekly Progress
                    GlassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Weekly Progress")
                                .font(.headline)
                            
                            ProgressView(value: weeklyProgress)
                                .tint(.purple)
                            
                            HStack {
                                Text("Goal: 5000 jumps")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(Int(weeklyProgress * 5000)) jumps")
                                    .foregroundStyle(.purple)
                            }
                            .font(.subheadline)
                        }
                    }
                    
                    // Recent Activities
                    GlassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recent Activities")
                                .font(.headline)
                            
                            ForEach(1...3, id: \.self) { _ in
                                HStack {
                                    Image(systemName: "figure.jumprope")
                                        .foregroundStyle(.blue)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Jump Rope Session")
                                            .font(.subheadline)
                                        Text("200 jumps • 15 min")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("2h ago")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome back,")
                .font(.title2)
                .foregroundStyle(.secondary)
            Text(userName)
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HomeView()
}
