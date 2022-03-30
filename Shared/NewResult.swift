//
//  NewResult.swift
//  workout
//
//  Created by Adam Gorring on 30/3/2022.
//

import SwiftUI

struct NewResult: View {
    
    //Current exercise parameter is passed through the navigation view
    var exercise: Exercise
    
    @EnvironmentObject var data : DataManager
    
    //Setup date variable
    @State var date: Date = Date.now
    
    //Setup result variable to post to database
    @State var newResult = Result(exerciseID: -1, workoutID: -1, date: "", weight: -1, reps: -1)
    
    // Create Date Formatter
    let dateFormatter = DateFormatter()
 
    var body: some View {
        List
        {
            
            Picker("Weight", selection: $newResult.weight) {
                ForEach(1 ..< 100) {
                    Text("\($0) kg")
                }
            }
            
            Picker("Reps", selection: $newResult.reps) {
                ForEach(1 ..< 50) {
                    Text("\($0) kg")
                }
            }
            
            DatePicker("Date", selection: $date, displayedComponents: .date)
            
            Button(action:
                    {
                dateFormatter.dateFormat = "YYYY-MM-dd"
                newResult.date = dateFormatter.string(from: date)
                
                newResult.workoutID = exercise.workoutID
                newResult.exerciseID = exercise.exerciseID
                
                //Add one to the weight/reps because the picker values begin at 0
                newResult.weight = newResult.weight + 1
                newResult.reps = newResult.reps + 1
                
                //Send data
                data.sendResult(newResult)
                
                }) {
                HStack
                {
                    Text("Create Result")
                    Image(systemName: "plus.app.fill").font(.title).foregroundColor(.blue)
                }
            }
        }.navigationTitle("New Result")
    }
}

//struct NewResult_Previews: PreviewProvider {
//    static var previews: some View {
//        NewResult()
//    }
//}
