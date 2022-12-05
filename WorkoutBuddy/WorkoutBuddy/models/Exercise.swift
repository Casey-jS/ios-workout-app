//
//  Exercise.swift
//  WorkoutBuddy
//
//  Created by Lucas D. Johnson on 11/29/22.
//

import Foundation

public struct Exercise{
    var key: Int?
    var type: String? 
    var name: String?
    var sets: Int?
    var reps: Int?
    var time: String?
    var weight: Int?
    
//    let persistentContainer: NSPersistentContainer = {
//        // creates the NSPersistentContainer object
//        // must be given the name of the Core Data model file “Exercise”
//        let container = NSPersistentContainer(name: "ExerciseEntity")
//
//        // load the saved database if it exists, creates it if it does not, and returns an error under failure conditions
//        container.loadPersistentStores { (description, error) in
//            if let error = error {
//                print("Error setting up Core Data (\(error)).")
//            }
//        }
//        return container
//    }()
    
    // General initializer
    init(key: Int?, type: String?, name: String?, sets: Int?, reps: Int?, time: String?, weight: Int?){
        self.key = key
        self.type = type
        self.name = name
        self.sets = sets
        self.reps = reps
        self.time = time
        self.weight = weight
    }
    // Initalizer for weighted exercises
    init(key: Int?, type: String?, name: String?, sets: Int?, reps: Int?, weight: Int?){
        self.init(key: key, type: type, name: name, sets: sets, reps: reps, time: nil, weight: weight)
    }
    // Initializer for non-weighted exercises
    init(key: Int?, type: String?, name: String?, sets: Int?, reps: Int?){
        self.init(key: key, type: type, name: name, sets: sets, reps: reps, time: nil, weight: nil)
    }
    // Initializer for cardio exercises
    init(key: Int?, type: String?, name: String?, time: String?){
        self.init(key: key, type: type, name: name, sets: nil, reps: nil, time: time, weight: nil)
    }
    init(key: Int?, type: String?){
        self.init(key: key, type: type, name: nil, sets: nil, reps: nil, time: nil, weight: nil)
    }
    // Empty initializer
    init(){
        self.init(key: nil, type: nil, name: nil, sets: nil, reps: nil, time: nil, weight: nil)
    }
}
