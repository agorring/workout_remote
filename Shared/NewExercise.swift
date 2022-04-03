//
//  NewExercise.swift
//  workout
//
//  Created by Adam Gorring on 30/3/2022.
//

import SwiftUI

struct NewExercise: View {
    
    @EnvironmentObject var data : DataManager
    
    var newExercise : Exercise = Exercise(exerciseID: -1, exerciseName: "", workoutID: -1, weight: -1, reps: -1)
    
    @State private var showingAlert = false
    
    @State var weight = 0
    @State var reps = 0
    @State var name = ""
    
    @State var selectedWorkoutID : Int = 1
    
    var body: some View {
        List
        {
            
            TextField("Name", text: $name)
            
            HStack
            {
                Picker(selection: $selectedWorkoutID, label: Text("Workout"))
                {
                    ForEach(data.workouts, id: \.workoutID)
                    {
                        workout in
                        
                        Text(workout.workoutName)
                            .tag(workout.workoutID)
                    }
                }
                Spacer()
            }
            
            
            Picker("Weight", selection: $weight) {
                ForEach(1 ..< 100) {
                    Text("\($0) kg")
                }
            }
            
            Picker("Reps", selection: $reps) {
                ForEach(1 ..< 50) {
                    Text("\($0) reps")
                }
            }
            
            
            Button(action:
                    {

                
                //Set the fields of the new record
//                newResult.date = dateFormatter.string(from: date)
//                newResult.workoutID = exercise.workoutID
//                newResult.exerciseID = exercise.exerciseID
                //Add one to the weight/reps because the picker values begin at 0
                newExercise.weight = weight + 1
                newExercise.reps = reps + 1
                
                //Send data
                //data.sendExercise(newExercise)
                
                //Show the alert
                showingAlert = true
                
                }) {
                HStack
                {
                    Text("Create Exercise")
                    Image(systemName: "plus.app.fill").font(.title).foregroundColor(.blue)
                }
                .alert("New exercise added", isPresented: $showingAlert)
                    {
                        Button("OK", role: .cancel) { }
                    }
            }
        }.navigationTitle("New Exercise")
    }
}

struct NewExercise_Previews: PreviewProvider {
    static var previews: some View {
        NewExercise()
    }
}
