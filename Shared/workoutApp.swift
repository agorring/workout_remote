//
//  workoutApp.swift
//  Shared
//
//  Created by Adam Gorring on 20/3/2022.
//

import SwiftUI

@main
struct workoutApp: App {
    
    @StateObject private var data = DataManager()
    
    var body: some Scene {
        WindowGroup {
            WorkoutView().environmentObject(data)
                
        }
    }
}
