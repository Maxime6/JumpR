//
//  JumpRApp.swift
//  JumpR
//
//  Created by Maxime Tanter on 09/01/2025.
//

import SwiftUI

@main
struct JumpRApp: App {
    @State var showLaunchscreen: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showLaunchscreen {
                    LaunchScreen()
                        .ignoresSafeArea()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                self.showLaunchscreen = false
                            }
                        }
                } else {
                    ContentView()
                }
                
            }
            
        }
    }
}
