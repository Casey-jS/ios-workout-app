//
//  AddRoutineViewController.swift
//  WorkoutBuddy
//
//  Created by Lucas Johnson on 12/5/22.
//

import UIKit

protocol AddRoutineViewControllerDelegate {
    func addRoutine(routine: Routine)
}

class AddRoutineViewController: UIViewController {

    var routine: Routine?
    
    var delegate: AddRoutineViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let del = self.delegate {
            del.addRoutine(routine: routine!)
        }
        self.dismiss(animated: true)
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
