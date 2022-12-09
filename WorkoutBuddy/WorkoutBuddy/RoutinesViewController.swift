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
        
        getRoutines()
        self.routines = self.routines.reversed()
        
        // Do any additional setup after loading the view.
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: Menu)
    }
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Clear Routines", image: UIImage(systemName: "trash"), handler: { _ in self.clearRoutines()
            }),
        ]
    }

    var Menu: UIMenu {
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    func clearRoutines(){
        
        self.routines = []
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "RoutineEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        }
        catch{
            print("Failed to clear history")
        }
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
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let routineToDelete: Int32 = Int32(routines[indexPath.row].key!)
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RoutineEntity")
            do{
                let result = try managedContext.fetch(request)
                for routine in result as! [NSManagedObject]{
                    if routine.value(forKey: "rKey") as! Int32 == routineToDelete{
                        managedContext.delete(routine)
                    }
                }
            } catch{
                print("Failed to find")
            }
            do{
                try managedContext.save()
            }
            catch{
                print("error deleting from core data")
            }
            
            
            
            
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
                let routine = Routine(key: generateKey(), name: "", date: Date(), exercises: [])
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
    
    func generateKey() -> Int {
        
        var newKey = Int.random(in: 0...9999)
        for r in self.routines{
            if r.key == newKey{
                newKey = generateKey()
            }
        }
        return newKey
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

extension RoutinesViewController: AddRoutineViewControllerDelegate {
    func addRoutine(routine: Routine){
        
        // Saves new routine to Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        
            let newRoutine = NSEntityDescription.entity(forEntityName: "RoutineEntity", in: managedContext)!
            
            let rout = NSManagedObject(entity: newRoutine, insertInto: managedContext) as! RoutineEntity
            let mExercises = Exercises(exercises: routine.exercises!)
            
            rout.setValue(mExercises, forKey: "rExercises")
            rout.setValue(routine.name, forKey: "rName")
            rout.setValue(routine.date, forKey: "rDate")
            rout.setValue(routine.key, forKey: "rKey")
        do {
            try managedContext.save()
            print("Success")
        } catch {
            print("Error saving: \(error)")
        }
        
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RoutineEntity")
        do{
            let result = try managedContext.fetch(request)
            for r in result as! [NSManagedObject]{
                if (r.value(forKey: "rKey") as! Int) == routine.key{
                    // Deletes old routine
                    managedContext.delete(r)
                    
                    // Places updated routine into context
                    let newRoutine = NSEntityDescription.entity(forEntityName: "RoutineEntity", in: managedContext)!
                    
                    let rout = NSManagedObject(entity: newRoutine, insertInto: managedContext) as! RoutineEntity
                    let mExercises = Exercises(exercises: routine.exercises!)
                    
                    rout.setValue(mExercises, forKey: "rExercises")
                    rout.setValue(routine.name, forKey: "rName")
                    rout.setValue(routine.date, forKey: "rDate")
                    rout.setValue(routine.key, forKey: "rKey")
                }
            }
        } catch{
            print("Failed to find")
        }
        do{
            try managedContext.save()
        }
        catch{
            print("error deleting from core data")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
