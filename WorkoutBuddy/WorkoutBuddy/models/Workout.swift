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
    
    init(date: Date? = nil, time: TimeInterval? = nil, exercises: [Exercise]? = nil) {
        self.date = date
        self.time = time
        self.exercises = exercises
    }
}
