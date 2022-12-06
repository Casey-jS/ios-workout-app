//
//  RoutinesViewController.swift
//  WorkoutBuddy
//
//  Created by Lucas Johnson on 12/5/22.
//

import UIKit


class RoutinesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var routines: [Routine]?
    var editRoutine: Routine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let model = RoutineModel()
        self.routines = model.getRoutines()

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
            routines?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rout = self.routines {
            return rout.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {

        let cell = self.tableView.dequeueReusableCell(withIdentifier: "routineCell", for: indexPath)
        
        if let routine = self.routines?[indexPath.row]{
            cell.textLabel?.text = routine.name
            cell.detailTextLabel?.text = routine.date?.formatted()
        }
            
        return cell

    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90.0
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let routine = self.routines?[indexPath.row] else {
            return
        }
        editRoutine = routine
        performSegue(withIdentifier: "editRoutineSegue", sender: nil)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addRoutineSegue" {
            if let dest = segue.destination.children[0] as? AddRoutineViewController {
                let routine = Routine(key: self.routines!.count + 1, name: "", date: Date(), exercises: [])
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
}

extension RoutinesViewController: AddRoutineViewControllerDelegate {
    func addRoutine(routine: Routine){
        // Inserts new exercise into exercises list
        self.routines?.insert(routine, at: 0)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func replaceRoutine(routine: Routine){
        // Inserts new exercise into exercises list
        self.routines?.removeAll(where: { $0.key == routine.key })
        self.routines?.insert(routine, at: 0)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}