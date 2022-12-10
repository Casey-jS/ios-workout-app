//
//  WorkoutViewController.swift
//  WorkoutBuddy
//
//  Created by Lucas D. Johnson on 11/29/22.
//

import UIKit
import CoreData


class WorkoutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var running = false
    var timer: Timer = Timer()
    var count: Int = 0
    
    var exercises: [Exercise] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets a monospaced font so timer doesn't shake
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 65, weight: UIFont.Weight.regular)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Rounds start button and timer label
        // startButton.layer.cornerRadius = startButton.frame.width / 2
        startButton.layer.masksToBounds = true
        
        timerLabel.layer.cornerRadius = 15
        timerLabel.layer.masksToBounds = true
        
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: Menu)
        
    }
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Load Workout", image: nil, handler: { _ in self.performSegue(withIdentifier: "loadWorkoutSegue", sender: self)
            }),
            UIAction(title: "Clear Exercises", image: nil, handler: { _ in self.clearExercises()
            }),
        ]
    }

    func clearExercises(){
        self.exercises = []
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    var Menu: UIMenu {
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    
    
    @IBAction func addTapped(_ sender: Any) {
        if(running == true){
            performSegue(withIdentifier: "addWorkoutExerciseSegue", sender: nil)
        }else{
            let alert = UIAlertController(title: "Begin workout?", message: "Would you like to begin a workout?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "NO", style: .cancel))
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
                self.startTapped(self)
                self.performSegue(withIdentifier: "addWorkoutExerciseSegue", sender: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Starts a workout when start button is tapped
    @IBAction func startTapped(_ sender: Any) {
        if(!running){
            startButton.setTitle("Finish", for: .normal)
            running = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }else{
            let alert = UIAlertController(title: "Finish workout?", message: "Are you sure would like to finish your workout?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel))
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
                
                let workout = Workout(date: Date(), time: self.count, exercises: self.exercises)
                self.addWorkout(workout: workout)
                
                self.count = 0
                self.timer.invalidate()
                self.timerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
                self.startButton.setTitle("Start", for: .normal)
                self.running = false
                self.exercises = []
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func addWorkout(workout: Workout){
        
        // Saves new routine to Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        
        let newWorkout = NSEntityDescription.entity(forEntityName: "WorkoutEntity", in: managedContext)!
            
        let work = NSManagedObject(entity: newWorkout, insertInto: managedContext) as! WorkoutEntity
        let mExercises = Exercises(exercises: workout.exercises!)
            
        work.setValue(mExercises, forKey: "wExercises")
        work.setValue(workout.date, forKey: "wDate")
        work.setValue(workout.time, forKey: "wTime")
        
        do {
            try managedContext.save()
            print("Success")
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    // MARK:  Timer functions
    @objc func timerCounter() -> Void {
        count = count + 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        timerLabel.text = timeString
    }
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int){
        return (seconds / 3600, (seconds % 3600) / 60, ((seconds % 3600) % 60))
    }
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String{
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            exercises.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercises.count
  
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        
        
        // Returns weighted cell view
        if(exercises[indexPath.row].type == "Weighted"){
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "weightedCell", for:
                indexPath) as! WeightedTableViewCell
            let exercise = self.exercises[indexPath.row]
                cell.titleLabel.text = exercise.name
                cell.setsLabel.text = "\(exercise.eSets)"
                cell.repsLabel.text = "Reps: \(exercise.eReps)"
                cell.weightLabel.text = "Weight: \(exercise.eWeight)"
            cell.exercise = exercise
            cell.delegate = self
   
            return cell
        // Returns non weighted cell view
        }else if(exercises[indexPath.row].type == "Non-Weighted"){
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "nonWeightedCell", for: indexPath) as! NonWeightedTableViewCell
            let exercise = self.exercises[indexPath.row]
                cell.titleLabel.text = exercise.name
                cell.setsLabel.text = "\(exercise.eSets)"
                cell.repsLabel.text = "Reps: \(exercise.eReps)"
            cell.exercise = exercise
            cell.delegate = self
    
            return cell
        // Returns cardio cell view
        }else{
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cardioCell", for: indexPath) as! CardioTableViewCell
            let exercise = self.exercises[indexPath.row]
            cell.titleLabel.text = exercise.name
            cell.timeLabel.text = exercise.eTime
            cell.exercise = exercise
            cell.delegate = self
            return cell
        }
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(exercises[indexPath.row].type == "Cardio"){
            return 80.0
        }
        if(exercises[indexPath.row].type == "Weighted"){
            return 120.0
        }
        return 100.0
    }

    func generateKey() -> Int {
        
        var newKey = Int.random(in: 0...9999)
        let exercises = self.exercises
        for r in exercises{
            if r.eKey == newKey{
                newKey = generateKey()
            }
        }
        return newKey
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addWorkoutExerciseSegue" {
            if let dest = segue.destination.children[0] as? AddExerciseViewController {
                let newExercise = Exercise(key: generateKey(), type: "Weighted")
                dest.newExercise = newExercise
                dest.delegate = self
            }
        }
        if segue.identifier == "loadWorkoutSegue" {
            if let dest = segue.destination.children[0] as? LoadWorkoutViewController {
                dest.delegate = self
            }
        }
    }
    
}
    

extension WorkoutViewController : AddExerciseViewControllerDelegate {
    func newExercise(exercise: Exercise){
        // Inserts new exercise into exercises list
        self.exercises.insert(exercise, at: 0)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
extension WorkoutViewController: LoadWorkoutViewControllerDelegate {
    func loadWorkout(exercises: [Exercise]){
        self.exercises = exercises
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension WorkoutViewController : CardioTableViewCellDelegate {
    func setTime(_ cardioTableViewCell: CardioTableViewCell, timerChangeTo count: Int, forKey key: Int) {
        for e in self.exercises {
            if e.eKey == key {
                let time = secondsToHoursMinutesSeconds(seconds: count)
                let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
                e.eTime = timeString
            }
        }
    }
}

extension WorkoutViewController : WeightedTableViewCellDelegate {
    func setSets(_ WeightedTableViewCell: WeightedTableViewCell, changeSetsTo sets: Int, forKey key: Int) {
        for e in self.exercises {
            if e.eKey == key {
                e.eSets = sets
            }
        }
    }
}

extension WorkoutViewController : NonWeightedTableViewCellDelegate {
    func setSets(_ nonWeightedTableViewCell: NonWeightedTableViewCell, changeSetsTo sets: Int, forKey key: Int) {
        for e in self.exercises {
            if e.eKey == key {
                e.eSets = sets
            }
        }
    }
}


