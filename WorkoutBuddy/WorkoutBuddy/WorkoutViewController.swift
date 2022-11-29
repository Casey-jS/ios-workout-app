//
//  WorkoutViewController.swift
//  WorkoutBuddy
//
//  Created by Lucas D. Johnson on 11/29/22.
//

import UIKit

class WorkoutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var running = false
    var timer: Timer = Timer()
    var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Rounds start button
        startButton.layer.cornerRadius = startButton.frame.width / 2
        startButton.layer.masksToBounds = true
        
        timerLabel.layer.cornerRadius = 15
        timerLabel.layer.masksToBounds = true
    }
    

    @IBAction func startTapped(_ sender: Any) {
        if(!running){
            startButton.setTitle("Finish", for: .normal)
            running = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }else{
            let alert = UIAlertController(title: "Finish workout?", message: "Are you sure would like to finish your workout?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel))
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
                self.count = 0
                self.timer.invalidate()
                self.timerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
                self.startButton.setTitle("Start", for: .normal)
                self.running = false
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func timerCounter() -> Void {
        count = count + 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        timerLabel.text = timeString
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int){
        return (seconds / 3600, (seconds % 3600) / 60, ((seconds % 3600) % 60))
    }
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String{
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    
}
