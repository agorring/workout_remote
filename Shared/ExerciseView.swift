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
    
    var resultList : [Result]
    {
        return data.results
            .filter({$0.exerciseID == exercise.exerciseID})
                //The array is filtered by finding all exercises which have the ID of the selectedWorkoutID.
    }
    
    
    
    var body: some View {
        
        let sortedResults = resultList.sorted
        {
            $0.date > $1.date
        }
        
        VStack {
            List
            {
                
                NavigationLink(destination: NewResult(exercise: exercise))
                {
                    Image(systemName: "plus.app.fill").font(.title).foregroundColor(.blue)
                }
                
                
                //For each exercise in exerciseList, the title of the exercise is displayed, and pressing on it will travel to the exercise view
                ForEach(sortedResults)
                {
                    result in
                    
                    HStack
                    {
                        Text(String(result.weight) + "kg")
                        Image(systemName: "multiply").foregroundColor(.blue)
                        Text(String(result.reps))
                        Text(result.date)
                    }
                    
                }
            }
        }.navigationTitle(exercise.exerciseName)
    }
}

//struct ExerciseView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseView()
//    }
//}
