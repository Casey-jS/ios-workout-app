//
//  ExerciseEntity+CoreDataProperties.swift
//  WorkoutBuddy
//
//  Created by Casey Sytsema on 12/5/22.
//
//

import Foundation
import CoreData


extension ExerciseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseEntity> {
        return NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
    }

    @NSManaged public var type: String?
    @NSManaged public var name: String?
    @NSManaged public var sets: Int16
    @NSManaged public var time: Float
    @NSManaged public var reps: Int16
    @NSManaged public var weight: Int16

}

extension ExerciseEntity : Identifiable {

}
