//
//  WorkoutEntity+CoreDataProperties.swift
//  WorkoutBuddy
//
//  Created by Casey Sytsema on 12/5/22.
//
//

import Foundation
import CoreData


extension WorkoutEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutEntity> {
        return NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var time: Float
    @NSManaged public var exercises: 

}

// MARK: Generated accessors for numExercises
extension WorkoutEntity {

    

}

extension WorkoutEntity : Identifiable {

}
