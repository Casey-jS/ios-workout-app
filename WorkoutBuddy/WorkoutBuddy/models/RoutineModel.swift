//
//  RoutineModel.swift
//  WorkoutBuddy
//
//  Created by Lucas Johnson on 12/5/22.
//

import Foundation

class RoutineModel {
    var exercises: [Exercise]?
    
    fileprivate var items : [Routine] = [Routine]()
    init() {
        let model = ExerciseModel()
        self.exercises = model.getExercises()
        
        createRoutines()
    }
    func getRoutines() -> [Routine]{
        return self.items
    }
    fileprivate func createRoutines(){
        items.append(Routine(key: 1, name: "Monday", date: Date(), exercises: exercises))
    }
}

