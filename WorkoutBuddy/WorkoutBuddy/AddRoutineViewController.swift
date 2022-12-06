//
//  AddRoutineViewController.swift
//  WorkoutBuddy
//
//  Created by Lucas Johnson on 12/5/22.
//

import UIKit

protocol AddRoutineViewControllerDelegate {
    func addRoutine(routine: Routine)
    func replaceRoutine(routine: Routine)
}

class AddRoutineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var routine: Routine?
    var editMode: Bool?
    var delegate: AddRoutineViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        if(editMode == true){
            titleLabel.text = "Edit Routine"
        }
        nameInput.text = routine?.name
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        routine?.name = nameInput.text
        if let del = self.delegate {
            if editMode == false{
                del.addRoutine(routine: routine!)
            }else{
                del.replaceRoutine(routine: routine!)
            }
        }
        self.dismiss(animated: true)
    }
    
    // MARK: - Table stuff
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.routine?.exercises?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let exer = self.routine?.exercises {
            return exer.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "RoutineExerciseCell", for:
            indexPath)
        if let exercise = self.routine?.exercises?[indexPath.row] {
            if(exercise.type == "Weighted"){
                cell.textLabel?.text = exercise.name
                cell.detailTextLabel?.text = "Sets: \(exercise.sets ?? 0)   Reps: \(exercise.reps ?? 0)   Weight: \(exercise.weight ?? 0)"
            }else if(exercise.type == "Non-Weighted"){
                cell.textLabel?.text = exercise.name
                cell.detailTextLabel?.text = "Sets: \(exercise.sets ?? 0)   Reps: \(exercise.reps ?? 0)"
            }else{
                cell.textLabel?.text = exercise.name
                cell.detailTextLabel?.text = ""
            }
        }
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addRoutineExerciseSegue" {
            if let dest = segue.destination.children[0] as? AddExerciseViewController {
                let newExercise = Exercise(key: ((self.routine?.exercises!.count)! + 1), type: "Weighted")
                dest.newExercise = newExercise
                dest.delegate = self
            }
        }
    }

}

extension AddRoutineViewController : AddExerciseViewControllerDelegate {
    func newExercise(exercise: Exercise){
        // Inserts new exercise into exercises list
        self.routine?.exercises?.insert(exercise, at: 0)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
