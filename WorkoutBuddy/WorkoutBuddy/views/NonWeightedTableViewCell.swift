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
    
    var exercise: Exercise?
    
    weak var delegate: NonWeightedTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let sets = exercise?.eSets
        nonWeightedStepper.value = Double(sets ?? 0)
        // Configure the view for the selected state
    }

    @IBAction func changeSets(_ sender: Any) {
        setsLabel.text = "Sets: \(Int(nonWeightedStepper.value))"
        if let key = exercise?.eKey,
           let _ = delegate {
            self.delegate?.setSets(self, changeSetsTo: Int(nonWeightedStepper.value), forKey: key)
        }
    }
    

}

protocol NonWeightedTableViewCellDelegate: AnyObject {
    func setSets(_ nonWeightedTableViewCell: NonWeightedTableViewCell, changeSetsTo sets: Int, forKey key: Int)
}
