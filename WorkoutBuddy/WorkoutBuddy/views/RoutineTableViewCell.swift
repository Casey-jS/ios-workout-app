//
//  RoutineTableViewCell.swift
//  WorkoutBuddy
//
//  Created by Lucas Johnson on 12/5/22.
//

import UIKit

class RoutineTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
