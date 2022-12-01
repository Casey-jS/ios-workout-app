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
    @IBOutlet weak var repsInput: UITextField!
    @IBOutlet weak var weightInput: UITextField!
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
        self.pickerData = ["Weighted", "non-Weighted", "Cardio"]
        self.picker.reloadAllComponents()
        self.picker.isHidden = false
    }
    @objc func hidePicker(sender: UITapGestureRecognizer){
        self.picker.isHidden = true
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
    
    @IBAction func addTapped(_ sender: Any) {
        
        newExercise?.name = nameLabel.text
        
        if(newExercise?.type == "Weighted"){
            newExercise?.weight = Int(weightInput.text!)
            newExercise?.reps = Int(repsInput.text!)
            newExercise?.sets = Int(setsLabel.text!)
        }else if(newExercise?.type == "non-Weighted"){
            newExercise?.reps = Int(repsInput.text!)
            newExercise?.sets = Int(setsLabel.text!)
        }else{
            newExercise?.time = "1:15"
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
    }
}
