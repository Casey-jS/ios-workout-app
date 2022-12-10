//
//  Exercise.swift
//  WorkoutBuddy
//
//  Created by Lucas D. Johnson on 11/29/22.
//

import Foundation
import UIKit

public class Exercise: NSObject, NSSecureCoding {
    
    public static var supportsSecureCoding: Bool = true
    
    var eKey: Int = -1
    var type: String = ""
    var name: String = ""
    var eSets: Int = 0
    var eReps: Int = 0
    var eTime: String = ""
    var eWeight: Int = 0
    
    enum Key:String{
        case eKey = "eKey"
        case type = "type"
        case name = "name"
        case eSets = "eSets"
        case eReps = "eReps"
        case eTime = "eTime"
        case eWeight = "eWeight"
    }
    
    // General initializer
    init(key: Int, type: String, name: String, sets: Int, reps: Int, time: String, weight: Int){
        self.eKey = key
        self.type = type
        self.name = name
        self.eSets = sets
        self.eReps = reps
        self.eTime = time
        self.eWeight = weight
    }
    // Initalizer for weighted exercises
    convenience init(key: Int, type: String, name: String, sets: Int, reps: Int, weight: Int){
        self.init(key: key, type: type, name: name, sets: sets, reps: reps, time: "", weight: weight)
    }
    // Initializer for non-weighted exercises
    convenience init(key: Int, type: String, name: String, sets: Int, reps: Int){
        self.init(key: key, type: type, name: name, sets: sets, reps: reps, time: "", weight: 0)
    }
    // Initializer for cardio exercises
    convenience init(key: Int, type: String, name: String, time: String){
        self.init(key: key, type: type, name: name, sets: 0, reps: 0, time: time, weight: 0)
    }
    convenience init(key: Int, type: String){
        self.init(key: key, type: type, name: "", sets: 0, reps: 0, time: "", weight: 0)
    }
    // Empty initializer
    override convenience init(){
        self.init(key: -1, type: "", name: "", sets: 0, reps: 0, time: "", weight: 0)
    }
    
    public func encode(with aCoder: NSCoder){
        aCoder.encode(eKey, forKey: Key.eKey.rawValue)
        aCoder.encode(type, forKey: Key.type.rawValue)
        aCoder.encode(name, forKey: Key.name.rawValue)
        aCoder.encode(eSets, forKey: Key.eSets.rawValue)
        aCoder.encode(eReps, forKey: Key.eReps.rawValue)
        aCoder.encode(eTime, forKey: Key.eTime.rawValue)
        aCoder.encode(eWeight, forKey: Key.eWeight.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder){
        let mKey = aDecoder.decodeInt32(forKey: Key.eKey.rawValue)
        let mType = aDecoder.decodeObject(forKey: Key.type.rawValue) as! String
        let mName = aDecoder.decodeObject(forKey: Key.name.rawValue) as! String
        let mSets = aDecoder.decodeInt32(forKey: Key.eSets.rawValue)
        let mReps = aDecoder.decodeInt32(forKey: Key.eReps.rawValue)
        let mTime = aDecoder.decodeObject(forKey: Key.eTime.rawValue) as! String
        let mWeight = aDecoder.decodeInt32(forKey: Key.eWeight.rawValue)
        
        self.init(key: Int(mKey), type: mType , name: mName , sets: Int(mSets), reps: Int(mReps), time: mTime, weight: Int(mWeight))
    }
}

public class Exercises: NSObject, NSSecureCoding {
    
    public static var supportsSecureCoding: Bool = true
    
    public var exercises: [Exercise] = []
    
    enum Key: String {
        case exercises = "exercises"
    }
    
    init(exercises: [Exercise]) {
        self.exercises = exercises
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(exercises, forKey: Key.exercises.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder){
        let mExercises = aDecoder.decodeObject(forKey: Key.exercises.rawValue) as! [Exercise]
        
        self.init(exercises: mExercises)
    }
}
