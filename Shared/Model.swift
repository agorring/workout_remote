//
//  Model.swift
//  workoutApp
//
//  Created by Adam Gorring on 25/3/22.
//

import SwiftUI
import Foundation
import Combine

//MARK: User

//Conforming to Codable allows the data type to be compatible with JSON data. Conforming to Identifiable allows Student data types to have a stable identity. Conforming to Equatable allows Student data types to be compared using the == operator.
class User: Codable, Identifiable, Equatable
{
    var userID : Int
    var firstName: String
    var surname: String
    var yearOfBirth : Int
    var gender : String
    var fullName : String
    {
        return firstName + " " + surname
    }
    
    //An initial declaration must be made for the User type.
    init(studentID: Int, firstName: String, surname: String, yearOfBirth : Int, gender : String, house : String)
    {
        self.userID = studentID
        self.firstName = firstName
        self.surname = surname
        self.yearOfBirth = yearOfBirth
        self.gender = gender
    }

    //This must be included for the data type to conform to equatable.
    static func == (lhs: User, rhs: User) -> Bool
    {
        return lhs.userID == rhs.userID
    }
}
//MARK: Workout
class Workout : Codable, Identifiable, Equatable
{
    var workoutID : Int
    var workoutName : String
    var date : String

    init(workoutID: Int, workoutName: String, date : String)
        {
            self.workoutID = workoutID
            self.workoutName = workoutName
            self.date = date
        }

    static func == (lhs: Workout, rhs: Workout) -> Bool
    {
        return lhs.workoutID == rhs.workoutID
    }
}
//MARK: Exercise
class Exercise : Codable, Identifiable, Equatable
{
    var exerciseID : Int
    var exerciseName : String
    var maxResult : Double
    var workoutID : Int
    
    static func == (lhs: Exercise, rhs: Exercise) -> Bool
    {
        return lhs.exerciseID == rhs.exerciseID
    }
    
    init(exerciseID: Int, exerciseName: String, maxResult: Double, workoutID: Int)
    {
        self.exerciseID = exerciseID
        self.exerciseName = exerciseName
        self.maxResult = maxResult
        self.workoutID = workoutID
    }
}
//MARK: Result
class Result : Codable, Identifiable, Equatable
{
    var userID : Int
    var exerciseID : Int
    var result : Double
    
    static func == (lhs: Result, rhs: Result) -> Bool
    {
        return lhs.userID == rhs.userID
    }
    
    init(userID: Int, exerciseID: Int, result: Double)
    {
        self.userID = userID
        self.exerciseID = exerciseID
        self.result = result
    }
}

//MARK: Data Manager
class DataManager: ObservableObject
{
    
    init() {
        getOnlineData()
    }
    
    let getRequests = ["U", "W", "E", "R"]
    
    //A predefined SwiftUI variable that sends data to the view when the object is modified
    var willChange = PassthroughSubject<Void, Never>()

    //The URL for the location of the online data
    private var jsonURL = "http://localhost:8888/workout/api2.php"

    //Grab the location of the document library on the device
    private let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

    //When retrieving or creating local data from the device from an online source,the file name is fileData.json.
    private var localFileName = "fileData.json"

    //MARK: Variables
    //Arrays are created to store downloaded data. Each are arrays of their implied data type.
    @Published var workouts = [Workout]()
    @Published var results = [Result]()
    @Published var users = [User]()
    @Published var exercises = [Exercise]()
    
    //recordsInserted and recordsUpdated are declared as zero and are used to count records.
    @Published var recordsInserted : Int = 0
    @Published var recordsUpdated : Int = 0
    
    //showRecordsModifiedAlert is initially set to false. When its value is changed (didSet), it will check if the value is false. If it is false, it implies that the Alert has been dismissed, which means the recordsInserted and recordsUpdated must be reset to zero.
    @Published var showRecordsModifiedAlert : Bool = false
    {
        didSet
        {
            if !showRecordsModifiedAlert
            {
                recordsInserted = 0
                recordsUpdated = 0
            }
        }
    }

    // MARK: Get online data
    func getOnlineData()
    {
        for request in getRequests
        {
            //Set the file path to save the json data, taking the document library URL and adding the desired file name
            let saveFilePath = self.documentsUrl.appendingPathComponent(localFileName)

            let url = URL(string: jsonURL + "?data=" + request)!
            
            //Create a URL session to download the data, which will return the data, a response from the website and an error
            URLSession.shared.dataTask(with: url) { data, response, error in

                if let foundData = data {
                    do {
                        //Move the downloaded file from the online source to the file folder destination
                        try foundData.write(to: saveFilePath)
                        //Parse the json data in the array of rooms
                        self.parseJson(foundData, request: request)
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    //MARK: Send Data
    func sendData(_ results: [Result])
    {
        for result in results
        {
            var request = URLRequest(url: URL(string: jsonURL)!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            guard let uploadData = try? JSONEncoder().encode(result) else { return }

            let task = URLSession.shared.uploadTask(with: request, from: uploadData)
            {
                data, response, error in

                if let error = error
                {
                    print ("error: \(error)")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else
                {
                    print ("server error")
                    return
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8)
                {
                    print("got data: \(dataString)")
                    self.recordsInserted += 1
                }
            }
            task.resume()
        }
    }
    
    //MARK: Parse JSON
    func parseJson(_ data: Data, request: String)
    {
        do {
            if request == "U"
            {
                //Take the downloaded data and match the index of the dictionary with the property name in the object
                let downloadedData = try JSONDecoder().decode([User].self, from: data)
                
                //Save the users array as the downloaded students
                DispatchQueue.main.async {self.users = downloadedData}
            }
            else if request == "W"
            {
                let downloadedData = try JSONDecoder().decode([Workout].self, from: data)
                DispatchQueue.main.async {self.workouts = downloadedData}
            }
            else if request == "E"
            {
                let downloadedData = try JSONDecoder().decode([Exercise].self, from: data)
                DispatchQueue.main.async {self.exercises = downloadedData}
            }
            else if request == "R"
            {
                let downloadedData = try JSONDecoder().decode([Result].self, from: data)
                DispatchQueue.main.async {self.results = downloadedData}
            }
            
        } catch let error {
            print(error)
        }
    }
}

//MARK: Extension twoDP
//The extension returns a value rounded to 2 decimal points.
extension Double
{
    var twoDP : String
    {
        return String(format: "%.2f", self)
    }
}
