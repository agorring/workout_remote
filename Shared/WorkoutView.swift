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
    
    //Boolean buttonTag is initally false and is used as a tag for a NavigationLink. When buttonTag becomes true, the navigation link will be initiated.
    @State var buttonTag : Bool? = false
    
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
//                HStack
//                {
//                    Image(systemName: "note.text").font(.title)
//
//                    //A picker is an object which allows the user to pick an option. When a picker option is selected, the selectedWorkoutID variable will be updated to the selection. The selection of options exists within the picker.
//                    Picker(selection: $selectedWorkoutID, label: Text("Select Workout"))
//                    {
//                        //The ForEach statement creates a view for each item within data.workouts. So for every workout, it will create text containting the workout name, and a tag for its workoutID. The tag is the value that is selected by the picker.
//                        ForEach(data.workouts, id: \.workoutID)
//                        {
//                            workout in
//
//                            Text(workout.workoutName).tag(workout.workoutID)
//                        }
//                    }
//                    Spacer()
//                }
                
                //A NavigationLink has been created which initiates when buttonTag becomes true, and the destination is the ExerciseView view.
                NavigationLink(destination: ExerciseView(), tag: true, selection: self.$buttonTag)
                {
                    EmptyView()
                }
                
                //MARK: LIST
                //A list displays its contents in a default iOS list.
                List
                {
                    //For each exercise in exerciseList, a list item is created which contains the title of the exercise and a select button.
                    ForEach(exerciseList, id: \.exerciseID)
                    {
                        exercise in
                        
                        HStack
                        {
                            Text(exercise.exerciseName)
                            Spacer()
                            //A ZStack is a view that arranges its contents into a line on the Z axis.
                            ZStack
                            {
                                //Applying an .onTapGesture to text allows the text to function as a button. When the text is pressed, data.currentExercise is set to the selected exercise, and the buttonTag is set to true, which initiates the NavigationLink to ExerciseView.
                                Button("Select")
                                {
                                    self.buttonTag?.toggle()
    //                              self.data.currentExercise = exercise
                                }
                            }
                        }
                    }
                }
            }.navigationBarItems(leading: workoutPicker)
        }
    }
    
    var workoutPicker: some View {
        HStack
        {
            Image(systemName: "note.text").font(.title)
            
            //A picker is an object which allows the user to pick an option. When a picker option is selected, the selectedWorkoutID variable will be updated to the selection. The selection of options exists within the picker.
            Picker(selection: $selectedWorkoutID, label: Text("Select Workout"))
            {
                //The ForEach statement creates a view for each item within data.workouts. So for every workout, it will create text containting the workout name, and a tag for its workoutID. The tag is the value that is selected by the picker.
                ForEach(data.workouts, id: \.workoutID)
                {
                    workout in
                    
                    Text(workout.workoutName).tag(workout.workoutID)
                }
            }
            Spacer()
        }
    }
    
}





struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
