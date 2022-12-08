//
//  Routine.swift
//  WorkoutBuddy
//
//  Created by Lucas Johnson on 12/5/22.
//

import Foundation
import CoreData

struct Routine {
    var key: Int?
    var name: String?
    var date: Date?
    var exercises: [Exercise]?
    
    init(key: Int? = -1, name: String? = nil, date: Date? = nil, exercises: [Exercise]? = nil) {
        self.key = key
        self.name = name
        self.date = date
        self.exercises = exercises
    }
}
