//
//  LoadWorkoutViewController.swift
//  WorkoutBuddy
//
//  Created by Lucas Johnson on 12/8/22.
//

import UIKit
import CoreData

protocol LoadWorkoutViewControllerDelegate{
    func loadWorkout(exercises: [Exercise])
}

class LoadWorkoutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    var delegate: LoadWorkoutViewControllerDelegate?
    
    var routines: [Routine] = []
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
        getRoutines()
        self.routines = self.routines.reversed()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routines.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "selectWorkoutCell", for:
            indexPath)
        let routine = self.routines[indexPath.row]
        cell.textLabel?.text = routine.name
        
        
        return cell
        
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let routine = self.routines[indexPath.row]
        if let del = self.delegate {
            del.loadWorkout(exercises: routine.exercises!)
        }
        self.dismiss(animated: true)
    }
    
    
    func getRoutines(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                
        let managedContext = appDelegate.persistentContainer.viewContext
                
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RoutineEntity")
        
        do {
           let result = try managedContext.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                
                
                let mExercises = data.value(forKey: "rExercises") as! Exercises
                let mName = data.value(forKey: "rName") as! String
                let mDate = data.value(forKey: "rDate") as! Date
                let mKey = data.value(forKey: "rKey") as! Int
                
                let mExer = mExercises.exercises
                
                let rout = Routine(key: mKey, name: mName, date: mDate, exercises: mExer)
                
                self.routines.append(rout)
            }
            
            
            } catch {
                  
                print("Failed")
            }
    }
}
