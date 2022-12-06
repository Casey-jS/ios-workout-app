//
//  Routine.swift
//  WorkoutBuddy
//
//  Created by Lucas Johnson on 12/5/22.
//

import Foundation
import CoreData

struct Routine {
    var name: String?
    var date: Date?
    var exercises: [Exercise]?
    
    
//    let persistentContainer: NSPersistentContainer = {
//        // creates the NSPersistentContainer object
//        // must be given the name of the Core Data model file “LoanedItems”
//        let container = NSPersistentContainer(name: "WorkoutEntity")
//
//        // load the saved database if it exists, creates it if it does not, and returns an error under failure conditions
//        container.loadPersistentStores { (description, error) in
//            if let error = error {
//                print("Error setting up Core Data (\(error)).")
//            }
//        }
//        return container
//    }()
    
    init(name: String? = nil, date: Date? = nil, exercises: [Exercise]? = nil) {
        self.name = name
        self.date = date
        self.exercises = exercises
    }
}
