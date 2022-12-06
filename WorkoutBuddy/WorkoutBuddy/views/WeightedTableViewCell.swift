//
//  WeightedTableViewCell.swift
//  WorkoutBuddy
//
//  Created by Lucas Johnson on 11/29/22.
//

import UIKit

class WeightedTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var repsLabel: UILabel!
    @IBOutlet var setsLabel: UILabel!
    @IBOutlet var weightedStepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let sets = Double(setsLabel.text!)
        weightedStepper.value = sets ?? 0.0
        // Configure the view for the selected state
    }

    @IBAction func changeSet(_ sender: Any) {
        setsLabel.text = "\(Int(weightedStepper.value))"
    }
    
}
