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
    
    var exercise: Exercise?
    
    weak var delegate: WeightedTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let sets = exercise?.eSets
        weightedStepper.value = Double(sets ?? 0)
        // Configure the view for the selected state
    }

    @IBAction func changeSet(_ sender: Any) {
        setsLabel.text = "Sets: \(Int(weightedStepper.value))"
        if let key = exercise?.eKey,
           let _ = delegate {
            self.delegate?.setSets(self, changeSetsTo: Int(weightedStepper.value), forKey: key)
        }
    }
    
}

protocol WeightedTableViewCellDelegate: AnyObject {
    func setSets(_ WeightedTableViewCell: WeightedTableViewCell, changeSetsTo sets: Int, forKey key: Int)
}
