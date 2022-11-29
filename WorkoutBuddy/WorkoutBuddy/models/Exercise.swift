//
//  Exercise.swift
//  WorkoutBuddy
//
//  Created by Lucas D. Johnson on 11/29/22.
//

import Foundation

struct Exercise{
    var key: String?
    var type: String? 
    var name: String?
    var sets: Int?
    var reps: Int?
    var time: String?
    var weight: Int?
    
    // General initializer
    init(key: String?, type: String?, name: String?, sets: Int?, reps: Int?, time: String?, weight: Int?){
        self.key = key
        self.type = type
        self.name = name
        self.sets = sets
        self.reps = reps
        self.time = time
        self.weight = weight
    }
    // Initalizer for weighted exercises
    init(key: String?, type: String?, name: String?, sets: Int?, reps: Int?, weight: Int?){
        self.init(key: key, type: type, name: name, sets: sets, reps: reps, time: nil, weight: weight)
    }
    // Initializer for non-weighted exercises
    init(key: String?, type: String?, name: String?, sets: Int?, reps: Int?){
        self.init(key: key, type: type, name: name, sets: sets, reps: reps, time: nil, weight: nil)
    }
    // Initializer for cardio exercises
    init(key: String?, type: String?, name: String?, time: String?){
        self.init(key: key, type: type, name: name, sets: nil, reps: nil, time: time, weight: nil)
    }
    // Empty initializer
    init(){
        self.init(key: nil, type: nil, name: nil, sets: nil, reps: nil, time: nil, weight: nil)
    }
}
