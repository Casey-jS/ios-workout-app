//
//  HistoryViewController.swift
//  WorkoutBuddy
//
//  Created by Lucas D. Johnson on 11/29/22.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var tableView: UITableView!

    var history: [Workout] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Do any additional setup after loading the view.
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
        
        self.getHistory()
        self.history = self.history.reversed()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getHistory(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                
        let managedContext = appDelegate.persistentContainer.viewContext
                
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutEntity")
        
        do {
           let result = try managedContext.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                
                let mExercises = data.value(forKey: "wExercises") as! Exercises
                let mDate = data.value(forKey: "wDate") as! Date
                let mTime = data.value(forKey: "wTime") as! Int
                
                let mExer = mExercises.exercises
                
                let workout = Workout(date: mDate, time: mTime, exercises: mExer)

                self.history.append(workout)
            }
            
            
            } catch {
                  
                print("Failed")
            }
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

    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
            return history.count
  
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        
        let routine = self.history[indexPath.row]
        cell.textLabel?.text = routine.date?.formatted()
        let time = secondsToHoursMinutesSeconds(seconds: routine.time!)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)

        cell.detailTextLabel?.text = "Workout Length: \(timeString)"
        
        
        return cell
        
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workout = self.history[indexPath.row]
        print("Clicked \(workout)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
