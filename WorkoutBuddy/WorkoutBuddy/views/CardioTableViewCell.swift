//
//  CardioTableViewCell.swift
//  WorkoutBuddy
//
//  Created by Lucas Johnson on 11/29/22.
//

import UIKit

class CardioTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet weak var cardioStartButton: UIButton!
    
    var cardioRunning = false
    var cardioTimer: Timer = Timer()
    var cardioCount: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Sets a monospaced font so timer doesn't shake
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: UIFont.Weight.regular)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func startTapped(_ sender: Any) {
        if(!cardioRunning){
            self.cardioStartButton.setTitle("Stop", for: .normal)
            self.cardioRunning = true
            self.cardioTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }else{
                self.cardioTimer.invalidate()
                self.cardioStartButton.setTitle("Start", for: .normal)
                self.cardioRunning = false
        }
    }
    
    // MARK:  Timer functions
    @objc func timerCounter() -> Void {
        cardioCount = cardioCount + 1
        let time = secondsToHoursMinutesSeconds(seconds: cardioCount)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        timeLabel.text = timeString
    }
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int){
        return (seconds / 3600, (seconds % 3600) / 60, ((seconds % 3600) % 60))
    }
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String{
        var timeString = ""
        timeString += String(format: "%01d", hours)
        timeString += ":"
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }
}
