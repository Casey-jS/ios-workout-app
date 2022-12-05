//
//  WorkoutEntity+CoreDataClass.swift
//  WorkoutBuddy
//
//  Created by Casey Sytsema on 12/5/22.
//
//

import Foundation
import CoreData

@objc(WorkoutEntity)
public class WorkoutEntity: NSManagedObject {
    override public func awakeFromInsert(){
        super.awakeFromInsert()
        // initialize with default values
        exercises = []
        date = Date()
        time = 0.0
    }
    
}
