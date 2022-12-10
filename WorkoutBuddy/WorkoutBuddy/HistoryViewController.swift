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
    
    private let refreshControl = UIRefreshControl()
    
    var history: [Workout] = []
    var selectedWorkout: Workout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Do any additional setup after loading the view.
        tableView.layer.cornerRadius = 15
        tableView.layer.masksToBounds = true
        
        self.getHistory()
        self.history = self.history.reversed()
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshHistory(_:)), for: .valueChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: Menu)
    }
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Clear History", image: UIImage(systemName: "trash"), handler: { _ in self.clearHistory()
            }),
        ]
    }

    var Menu: UIMenu {
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    @objc private func refreshHistory(_ sender: Any){
        self.history = []
        self.getHistory()
        self.history = self.history.reversed()

            self.refreshControl.endRefreshing()
            self.tableView.reloadData()

    }
    
    func clearHistory(){
        
        self.history = []
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "WorkoutEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        }
        catch{
            print("Failed to clear history")
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historyWorkoutSegue" {
            if let dest = segue.destination.children[0] as? WorkoutHistoryViewController {
                dest.workout = selectedWorkout
            }
        }
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
        selectedWorkout = workout
        performSegue(withIdentifier: "historyWorkoutSegue", sender: self)
    }
    


}
