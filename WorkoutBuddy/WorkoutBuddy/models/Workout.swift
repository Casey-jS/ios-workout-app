//
//  Workout.swift
//  WorkoutBuddy
//
//  Created by Lucas D. Johnson on 12/1/22.
//

import Foundation
import CoreData

struct Workout {
    var date: Date?
    var time: Int?
    var exercises: [Exercise]?
    
    init(date: Date? = nil, time: Int? = nil, exercises: [Exercise]? = nil) {
        self.date = date
        self.time = time
        self.exercises = exercises
    }
}
