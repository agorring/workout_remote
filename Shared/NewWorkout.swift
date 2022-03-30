//
//  NewWorkout.swift
//  workout
//
//  Created by Adam Gorring on 30/3/2022.
//

import SwiftUI

struct NewWorkout: View {
    
    @EnvironmentObject var data : DataManager
    
    @State var newWorkout = Workout(workoutID: -1, workoutName: "")
    
    var body: some View {
        VStack
        {
            List
            {
                TextField("Workout Name", text: $newWorkout.workoutName)
                
                Button(action:
                        {
                    //Set workoutID to 1 so that the API knows that a valid workout has been submitted. If the workoutID is < 0, it will not insert data.
                    newWorkout.workoutID = 1
                    data.sendWorkout(newWorkout)
                    }) {
                    HStack
                    {
                        Text("Create Workout")
                        Image(systemName: "plus.app.fill").font(.title).foregroundColor(.blue)
                    }
                    
                }
                
            }.navigationTitle("New Workout")
        }
    }
}

struct NewWorkout_Previews: PreviewProvider {
    static var previews: some View {
        NewWorkout()
    }
}
