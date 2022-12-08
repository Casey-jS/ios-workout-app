//
//  AddExerciseViewController.swift
//  WorkoutBuddy
//
//  Created by Lucas D. Johnson on 11/29/22.
//

import UIKit

protocol AddExerciseViewControllerDelegate{
    func newExercise(exercise: Exercise)
}

class AddExerciseViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var repsInput: UITextField!
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightInput: UITextField!
    
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var setsTitleLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    
    var pickerData: [String] = [String]()
    
    var newExercise : Exercise?

    var delegate : AddExerciseViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.isHidden = true
        
        let tapType = UITapGestureRecognizer(target: self, action: #selector(self.typeTapped))
        self.typeLabel.addGestureRecognizer(tapType)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hidePicker))
        self.view.addGestureRecognizer(tap)
        
        
        guard let tStr = self.newExercise?.type else {
            return
        }
        self.typeLabel.text = tStr
    }
    
    @IBAction func plusTapped(_ sender: Any) {
        var temp: Int = Int(setsLabel.text!)!
        temp += 1
        setsLabel.text = String(temp)
    }
    
    @IBAction func subtractTapped(_ sender: Any) {
        var temp: Int = Int(setsLabel.text!)!
        if(temp > 0){
            temp -= 1
        }
        setsLabel.text = String(temp)
    }
    
    @objc func typeTapped(sender: UITapGestureRecognizer){
        self.pickerData = ["Weighted", "Non-Weighted", "Cardio"]
        self.picker.reloadAllComponents()
        self.picker.isHidden = false
    }
    @objc func hidePicker(sender: UITapGestureRecognizer){
        self.picker.isHidden = true
    }
    
    
    /*
    // MARK: - Navigation

    */
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        newExercise?.name = nameLabel.text!
        
        if(newExercise?.type == "Weighted"){
            
            // If no weight input is given, make 0
            var weightStr = weightInput.text
            if (weightInput.text?.isEmpty == true){
                weightStr = "0"
            }
            newExercise?.eWeight = Int(weightStr!)!
            
            // if no reps input is given, make 0
            var repsStr = repsInput.text
            if (repsInput.text?.isEmpty == true){
                repsStr = "0"
            }
            newExercise?.eReps = Int(repsStr!)!
            
            // 0 is default for sets
            newExercise?.eSets = Int(setsLabel.text!)!
            
        }else if(newExercise?.type == "Non-Weighted"){
            // if no reps input is given, make 0
            var repsStr = repsInput.text
            if (repsInput.text?.isEmpty == true){
                repsStr = "0"
            }
            newExercise?.eReps = Int(repsStr!)!
            
            // 0 is default for sets
            newExercise?.eSets = Int(setsLabel.text!)!
        }else{
            // Sets time to 0
            newExercise?.eTime = "0:00:00"
        }
        
        if let del = self.delegate {
            del.newExercise(exercise: newExercise!)
        }
        self.dismiss(animated: true)
    }
}

extension AddExerciseViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.newExercise?.type = self.pickerData[row]
        self.typeLabel.text = self.pickerData[row]
        if(self.pickerData[row] == "Non-Weighted"){
            self.weightLabel.isHidden = true
            self.weightInput.isHidden = true
            
            self.setsLabel.isHidden = false
            self.setsTitleLabel.isHidden = false
            self.plusButton.isHidden = false
            self.minusButton.isHidden = false
            
            self.repsInput.isHidden = false
            self.repsLabel.isHidden = false
        }else if(self.pickerData[row] == "Cardio"){
            self.weightLabel.isHidden = true
            self.weightInput.isHidden = true
            
            self.setsLabel.isHidden = true
            self.setsTitleLabel.isHidden = true
            self.plusButton.isHidden = true
            self.minusButton.isHidden = true
            
            self.repsInput.isHidden = true
            self.repsLabel.isHidden = true
        }else{
            self.weightLabel.isHidden = false
            self.weightInput.isHidden = false
            
            self.setsLabel.isHidden = false
            self.setsTitleLabel.isHidden = false
            self.plusButton.isHidden = false
            self.minusButton.isHidden = false
            
            self.repsInput.isHidden = false
            self.repsLabel.isHidden = false
        }
    }
}
