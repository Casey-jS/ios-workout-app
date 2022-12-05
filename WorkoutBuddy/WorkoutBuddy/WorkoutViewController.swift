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
    
    var exercises: [Exercise]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets a monospaced font so timer doesn't shake
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 65, weight: UIFont.Weight.regular)
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let model = ExerciseModel()
        self.exercises = model.getExercises()

        // Rounds start button and timer label
        startButton.layer.cornerRadius = startButton.frame.width / 2
        startButton.layer.masksToBounds = true
        
        timerLabel.layer.cornerRadius = 15
        timerLabel.layer.masksToBounds = true
        
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
    }
    
    
    
    @IBAction func addTapped(_ sender: Any) {
        
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
            exercises?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let exer = self.exercises {
            return exer.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        
        
        // Returns weighted cell view
        if(exercises![indexPath.row].type == "Weighted"){
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "weightedCell", for:
                indexPath) as! WeightedTableViewCell
            if let exercise = self.exercises?[indexPath.row] {
                cell.titleLabel.text = exercise.name
                cell.setsLabel.text = String(exercise.sets!)
                cell.repsLabel.text = "Reps: \(String(exercise.reps!))"
                cell.weightLabel.text = "Weight: \(String(exercise.weight!))"
            }
            return cell
        // Returns non weighted cell view
        }else if(exercises![indexPath.row].type == "Non-Weighted"){
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "nonWeightedCell", for: indexPath) as! NonWeightedTableViewCell
            if let exercise = self.exercises?[indexPath.row] {
                cell.titleLabel.text = exercise.name
                cell.setsLabel.text = String(exercise.sets!)
                cell.repsLabel.text = "Reps: \(String(exercise.reps!))"
                
            }
            return cell
        // Returns cardio cell view
        }else{
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cardioCell", for: indexPath) as! CardioTableViewCell
            if let exercise = self.exercises?[indexPath.row] {
                cell.titleLabel.text = exercise.name
                cell.timeLabel.text = exercise.time
            }
            return cell
        }
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(exercises![indexPath.row].type == "Cardio"){
            return 100.0
        }
        return 130.0
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let exercise = self.exercises?[indexPath.row] else {
                return
            }
            print("Selected\(String(describing: exercise.name))")
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addExerciseSegue" {
            if let dest = segue.destination.children[0] as? AddExerciseViewController {
                let newExercise = Exercise(key: (self.exercises!.count + 1), type: "Weighted")
                dest.newExercise = newExercise
                dest.delegate = self
            }
        }
    }
    
}
    

extension WorkoutViewController : AddExerciseViewControllerDelegate {
    func newExercise(exercise: Exercise){
        // Inserts new exercise into exercises list
        self.exercises?.insert(exercise, at: 0)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

