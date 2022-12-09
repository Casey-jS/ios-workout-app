//
//  WorkoutHistoryViewController.swift
//  WorkoutBuddy
//
//  Created by Lucas D. Johnson on 12/9/22.
//

import UIKit

class WorkoutHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var workout: Workout?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
        
        let time = secondsToHoursMinutesSeconds(seconds: (workout?.time)!)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        
        dateLabel.text = "Date of workout: \(workout?.date!.formatted() ?? "")"
        lengthLabel.text = "Length of workout: \(timeString)"
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int){
        return (seconds / 3600, (seconds % 3600) / 60, ((seconds % 3600) % 60))
    }
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String{
        var timeString = ""
        timeString += String(format: "%01d", hours)
        timeString += ":"
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let exer = self.workout?.exercises {
            return exer.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "workoutHistoryCell", for:
            indexPath)
        if let exercise = self.workout?.exercises?[indexPath.row] {
            if(exercise.type == "Weighted"){
                cell.textLabel?.text = exercise.name
                cell.detailTextLabel?.text = "Sets: \(exercise.eSets )   Reps: \(exercise.eReps )   Weight: \(exercise.eWeight)"
                
                
            }else if(exercise.type == "Non-Weighted"){
                cell.textLabel?.text = exercise.name
                cell.detailTextLabel?.text = "Sets: \(exercise.eSets )   Reps: \(exercise.eReps )"
            }else{
                cell.textLabel?.text = exercise.name
                cell.detailTextLabel?.text = "Time: \(exercise.eTime)"
            }
        }
        return cell
    }

}
