//
//  MainView.swift
//  workoutApp
//
//  Created by Adam Gorring on 25/3/22.
//

import SwiftUI

struct MainView: View
{
    //Declaring the DataManager allows it to be accessed within the MainView struct by referencing "data".
    @EnvironmentObject var data : DataManager
    
    //Declaration of two shades of blue that will be used to stylise the app
    let lightBlue = Color(red:0.00, green:0.43, blue:0.68)
    let darkBlue = Color(red:0.00, green:0.27, blue:0.44)
    
    //Content within the body will be displayed on the screen.
    //MARK: View
    var body: some View
    {
        //Creating a NavigationView allows pages to be connected using NavigationLinks.
        NavigationView
        {
            //A VStack is a view that arranges its contents into a vertical line.
            VStack
            {
                //Placing a spacer creates a space to evenly distribute the objects within the view.
                Spacer()
                
                Text("Workouts").foregroundColor(lightBlue).fontWeight(.semibold).font(.title)
                Spacer()
                
                //The content within the NavigationLink will initiate a travel to the WorkoutView when clicked.
                NavigationLink(destination: WorkoutView().environmentObject(data))
                {
                    //A HStack is a view that arranges its contents into a vertical line.
                    HStack
                    {
                        Text("View Exercises").fontWeight(.semibold).font(.title)
                        //The SF Symbols extension provides common iOS symbols, such as "list.bullet".
                        Image(systemName: "list.bullet").font(.title)
                    }
                    .padding(.horizontal, 60)
                    .padding(.vertical, 20)
                    .background(lightBlue)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    }
                    //Applying a navigationBarTitle ensures that the user knows where they are located in the app.
                    .navigationBarTitle("Home", displayMode: .inline)
                
                //The content within this NavigationLink initiates a travel to the viewScores view when clicked.
                NavigationLink(destination: WorkoutView())
                {
                    HStack
                    {
                        Text("View Something").fontWeight(.semibold).font(.title)
                        Image(systemName: "timer").font(.title)
                    }.padding(.horizontal, 60).padding(.vertical, 20).background(darkBlue).foregroundColor(.white).cornerRadius(30)
                }
                .navigationBarTitle("Home", displayMode: .inline)

                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

