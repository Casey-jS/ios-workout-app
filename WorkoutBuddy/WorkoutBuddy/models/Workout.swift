//
//  Workout.swift
//  WorkoutBuddy
//
//  Created by Lucas D. Johnson on 12/1/22.
//

import Foundation

struct Workout {
    var date: Date?
    var time: TimeInterval?
    var exercises: [Exercise]?
    
    
    let persistentContainer: NSPersistentContainer = {
        // creates the NSPersistentContainer object
        // must be given the name of the Core Data model file “LoanedItems”
        let container = NSPersistentContainer(name: "WorkoutEntity")

        // load the saved database if it exists, creates it if it does not, and returns an error under failure conditions
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container
    }()
    
    init(date: Date? = nil, time: TimeInterval? = nil, exercises: [Exercise]? = nil) {
        self.date = date
        self.time = time
        self.exercises = exercises
    }
}
