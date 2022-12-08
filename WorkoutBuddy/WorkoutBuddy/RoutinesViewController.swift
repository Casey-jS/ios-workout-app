//
//  RoutinesViewController.swift
//  WorkoutBuddy
//
//  Created by Lucas Johnson on 12/5/22.
//

import UIKit
import CoreData


class RoutinesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var routines: [Routine] =  []
    var editRoutine: Routine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    //    createData()
        getRoutines()
        
        
        // Do any additional setup after loading the view.
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            routines.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
            return routines.count
  
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "routineCell", for: indexPath)
        
        let routine = self.routines[indexPath.row]
            cell.textLabel?.text = routine.name
            cell.detailTextLabel?.text = routine.date?.formatted()
        
        
        return cell
        
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let routine = self.routines[indexPath.row]
        editRoutine = routine
        performSegue(withIdentifier: "editRoutineSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addRoutineSegue" {
            if let dest = segue.destination.children[0] as? AddRoutineViewController {
                let routine = Routine(key: self.routines.count + 1, name: "", date: Date(), exercises: [])
                dest.routine = routine
                dest.editMode = false
                dest.delegate = self
            }
        }
        if segue.identifier == "editRoutineSegue" {
            if let dest = segue.destination.children[0] as? AddRoutineViewController {
                dest.routine = editRoutine
                dest.editMode = true
                dest.delegate = self
            }
        }
    }
    
    
    func createData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let model = RoutineModel()
        let routines = model.getRoutines()
        
        for r in routines {
            let newRoutine = NSEntityDescription.entity(forEntityName: "RoutineEntity", in: managedContext)!
            
            let rout = NSManagedObject(entity: newRoutine, insertInto: managedContext) as! RoutineEntity
            let mExercises = Exercises(exercises: r.exercises!)
            

            rout.setValue(mExercises, forKey: "exercises")
            rout.setValue(r.name, forKey: "name")
            rout.setValue(r.date, forKey: "date")
            rout.setValue(r.key, forKey: "key")
        }
        do {
            try managedContext.save()
            print("Success")
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    func getRoutines(){
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
                
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RoutineEntity")
        
        do {
           let result = try managedContext.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                
                
                let mExercises = data.value(forKey: "exercises") as! Exercises
                let mName = data.value(forKey: "name") as! String
                let mDate = data.value(forKey: "date") as! Date
                let mKey = data.value(forKey: "key") as! Int
                
                let mExer = mExercises.exercises
                
                let rout = Routine(key: mKey, name: mName, date: mDate, exercises: mExer)
                
                self.routines.append(rout)
            }
            
            
            } catch {
                  
                print("Failed")
            }
    }
}

extension RoutinesViewController: AddRoutineViewControllerDelegate {
    func addRoutine(routine: Routine){
        // Inserts new exercise into exercises list
        self.routines.insert(routine, at: 0)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func replaceRoutine(routine: Routine){
        // Inserts new exercise into exercises list
        self.routines.removeAll(where: { $0.key == routine.key })
        self.routines.insert(routine, at: 0)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
