//
//  NonWeightedTableViewCell.swift
//  WorkoutBuddy
//
//  Created by Lucas Johnson on 11/29/22.
//

import UIKit

class NonWeightedTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var repsLabel: UILabel!
    @IBOutlet var setsLabel: UILabel!
    @IBOutlet var nonWeightedStepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let sets = Double(setsLabel.text!)
        nonWeightedStepper.value = sets ?? 0.0
        // Configure the view for the selected state
    }

    @IBAction func changeSets(_ sender: Any) {
        setsLabel.text = "\(Int(nonWeightedStepper.value))"
    }
    

}
