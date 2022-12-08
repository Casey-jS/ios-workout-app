//
//  ExerciseModel.swift
//  WorkoutBuddy
//
//  Created by Lucas D. Johnson on 11/29/22.
//

import Foundation

class ExerciseModel {
    fileprivate var items : [Exercise] = [Exercise]()
    init() {
        createExercises()
    }
    func getExercises() -> [Exercise]{
        return self.items
    }
    fileprivate func createExercises(){
        items.append(Exercise(key: 1, type: "Weighted", name: "Benchpress", sets: 4, reps: 10, time: "0:00:00", weight: 145))
        items.append(Exercise(key: 2, type: "Weighted", name: "Squat", sets: 4, reps: 12, weight: 225))
        items.append(Exercise(key: 6, type: "Non-Weighted", name: "Pull-ups", sets: 4, reps: 10))
        items.append(Exercise(key: 3, type: "Weighted", name: "Deadlift", sets: 2, reps: 20, weight: 225))
        items.append(Exercise(key: 4, type: "Weighted", name: "Incline dumbell benchpress", sets: 4, reps: 10, weight: 45))
        items.append(Exercise(key: 5, type: "Cardio", name: "Treadmill", time: "0:00:00"))
    }
}
