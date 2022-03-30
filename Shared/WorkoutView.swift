//
//  WorkoutView.swift
//  workoutApp
//
//  Created by Adam Gorring on 25/3/22.
//

import SwiftUI

struct WorkoutView: View {

    //MARK: Declarations
    //Gives access to the DataManager from within the WorkoutView struct
    @EnvironmentObject var data : DataManager
    
    //selectedWorkoutID serves as an indicator for which workout is currently selected by the user. It is initialised with a value of 1.
    @State var selectedWorkoutID : Int = 1
    
    //Variable exerciseList is an array of type Exercise. It is a computed variable, which means its value is calculated when it is called. It returns a filtered and sorted list of the downloaded exercises.
    var exerciseList : [Exercise]
    {
        return data.exercises
                .filter({$0.workoutID == selectedWorkoutID})
                //The array is filtered by finding all exercises which have the ID of the selectedWorkoutID.
    }
    
    //MARK: View
    var body: some View
    {
        NavigationView {
            VStack
            {
                //MARK: LIST
                //A list displays its contents in a default iOS list.
                List
                {
                    
                    NavigationLink(destination: NewExercise())
                    {
                        Text("New Exercise")
                        Image(systemName: "plus.circle").font(.title).foregroundColor(.blue)
                    }
                    
                    //For each exercise in exerciseList, the title of the exercise is displayed, and pressing on it will travel to the exercise view
                    ForEach(exerciseList, id: \.exerciseID)
                    {
                        exercise in
                        
                        NavigationLink(destination: ExerciseView(exercise: exercise))
                        {
                            Text(exercise.exerciseName)
                            Text(String(exercise.weight) + "kg")
                            Image(systemName: "multiply").foregroundColor(.blue)
                            Text(String(exercise.reps))
                        }
                    }
                }
            }.navigationBarItems(leading: workoutPicker, trailing: addWorkout)
        }
    }
    
    var workoutPicker: some View {
        HStack
        {
            Image(systemName: "note.text").foregroundColor(.blue)
            //A picker is an object which allows the user to pick an option. When a picker option is selected, the selectedWorkoutID variable will be updated to the selection. The selection of options exists within the picker.
            Picker(selection: $selectedWorkoutID, label: Text("Select Workout"))
            {
                
                //The ForEach statement creates a view for each item within data.workouts. So for every workout, it will create text containting the workout name, and a tag for its workoutID. The tag is the value that is selected by the picker.
                ForEach(data.workouts, id: \.workoutID)
                {
                    workout in
                    
                    Text(workout.workoutName)
                        .tag(workout.workoutID)
                }
            }
            Spacer()
        }
    }
    
    var addWorkout: some View {
        VStack {
            NavigationLink(destination: NewWorkout())
            {
                Image(systemName: "plus.app.fill").font(.title).foregroundColor(.blue)
            }
        }
    }
    
}





struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
