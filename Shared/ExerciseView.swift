//
//  ExerciseView.swift
//  workout
//
//  Created by Adam Gorring on 26/3/2022.
//

import SwiftUI

struct ExerciseView: View {
    var exercise: Exercise
    @EnvironmentObject var data : DataManager
    
    var body: some View {
        VStack {
        Text("Hello, World!")
        }.navigationTitle(exercise.exerciseName)
    }
}

//struct ExerciseView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseView()
//    }
//}
