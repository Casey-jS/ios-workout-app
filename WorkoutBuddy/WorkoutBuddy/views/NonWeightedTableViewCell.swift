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
    @IBOutlet var minusButton: UIButton!
    @IBOutlet var plusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func addSet(_ sender: Any) {
        var temp: Int = Int(setsLabel.text!)!
        temp += 1
        setsLabel.text = String(temp)
    }
    
    @IBAction func subtractSet(_ sender: Any) {
        var temp: Int = Int(setsLabel.text!)!
        temp -= 1
        setsLabel.text = String(temp)
    }
}
