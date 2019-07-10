//
//  ViewController.swift
//  Easters 2019 Clock
//
//  Created by Viran Weerasekera on 10/1/19.
//  Copyright © 2019 Viran Weerasekera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var dsLabel: UILabel!
    
    @IBOutlet weak var daySelector: UISegmentedControl!
    @IBOutlet weak var roundSelector: UISegmentedControl!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timeNowLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var timeLabelCentreY: NSLayoutConstraint!
    
    @IBOutlet weak var switchStack: UIStackView!
  
    var selectedRound:round?
    var displayRound:round?
    
    var timer1 = Timer()
    var timer2 = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeNowLabel.text = ""
        roundLabel.text = ""
        initialBuild()
        
        
        updateButton.setTitle("", for: .normal)
        
        let defaults = UserDefaults.standard
        
        
        if let savedRounds = defaults.object(forKey: "displayRound") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                displayRound = try jsonDecoder.decode(round.self, from: savedRounds)
            } catch {
            }
        }
        
        daySelector.removeAllSegments()
        for (key, value) in dayLabels {
            daySelector.insertSegment(withTitle: value, at: key, animated: false)
        }
        
        for day in (0...daySelector.numberOfSegments-1) {
            if getRoundsForDay(day: day).count == 0 {
                daySelector.setEnabled(false, forSegmentAt: day)
            } else {
                daySelector.setEnabled(true, forSegmentAt: day)
            }
        }
        
        updateRoundOptions()
        updateConfirmButtonState()
        
        
        timerLabel.text = ""

        
        confirmButton.layer.cornerRadius = 10.0
        confirmButton.clipsToBounds = true
        
        if UIDevice().model == "iPhone" && UIDevice().orientation.isLandscape {
            roundLabel.textAlignment = .left
        } else {
            roundLabel.textAlignment = .center
        }
        
        
        
        timer1 = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: (#selector(updateCurrentTime)), userInfo: nil, repeats: true)
       
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData1 = try? jsonEncoder.encode(displayRound) {
            let defaults = UserDefaults.standard
            defaults.set(savedData1, forKey: "displayRound")
            //Zephyr.sync(keys: "allRounds")
        } else {
            print("Failed to Save")
        }
    }
    
    func getRoundsForDay(day: Int) -> [round] {
        var rounds:[round] = []
        for round in allRounds {
            if round.day == day {
                rounds.append(round)
            }
        }
        return rounds
    }


    func updateRoundOptions() {
        let index = daySelector.selectedSegmentIndex

        let roundstopopulate:[round] = getRoundsForDay(day: index)
        
        roundSelector.removeAllSegments()
        var ind = 0
        if roundstopopulate.count == 0 {
            roundSelector.insertSegment(withTitle: "No rounds today", at: 0, animated: false)
            roundSelector.setEnabled(false, forSegmentAt: 0)
        } else {
            for i in roundstopopulate {
                roundSelector.insertSegment(withTitle: i.label_short, at: ind, animated: false)
                roundSelector.setEnabled(true, forSegmentAt: ind)
                ind += 1
            }
        }
        
    }
    
    @IBAction func dayChanged(_ sender: Any) {

        updateRoundOptions()
        updateConfirmButtonState()
        
        if roundSelector.selectedSegmentIndex == -1 {
            confirmButton.backgroundColor = UIColor.gray
            confirmButton.setTitleColor(UIColor.white, for: .normal)
            confirmButton.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func roundChanged(_ sender: Any) {
        //Get the round to populate by cross-referencing the dayindex and roundindex from the selectors
        for round in allRounds {
            if round.day == daySelector.selectedSegmentIndex && round.dayInd == roundSelector.selectedSegmentIndex {
                selectedRound = round
            }
        }
        updateConfirmButtonState()
    }
    
    func updateConfirmButtonState() {
        var isEnabled:Bool = true
        
        if let dr = displayRound {
            if selectedRound == dr {
                isEnabled = false
            } else {
                isEnabled = true
            }
        } else {
            if roundSelector.selectedSegmentIndex == -1 {
                isEnabled = false
            } else {
                isEnabled = true
            }
        }
        
        if isEnabled {
            confirmButton.backgroundColor = UIColor.green
            confirmButton.setTitleColor(UIColor.white, for: .normal)
            confirmButton.isUserInteractionEnabled = true
        } else {
            confirmButton.backgroundColor = UIColor.gray
            confirmButton.setTitleColor(UIColor.white, for: .normal)
            confirmButton.isUserInteractionEnabled = false
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if UIDevice().model == "iPhone" && UIDevice().orientation.isLandscape {
            roundLabel.textAlignment = .left
        } else {
            roundLabel.textAlignment = .center
        }
    }
    
    @IBAction func roundChangedConfirm(_ sender: Any) {
        if roundSelector.selectedSegmentIndex != -1 {
            displayRound = selectedRound
            let sched = DateFormatter.localizedString(from: selectedRound!.sched, dateStyle: .none, timeStyle: .short)
            
            let testString1 = "\(selectedRound!.label_long) - Scheduled \(sched)"
            let testString2 = "\(selectedRound!.label_long) - \(sched)"
    
            if UIDevice().model == "iPhone" {
                // Both long
                if testString1.count > 18 && testString2.count > 18 {
                    roundLabel.text = "\(selectedRound!.label_short) - \(sched)"
                    
                    // String 1 is long, but 2 is OK
                } else if testString1.count > 18 && testString2.count <= 18 {
                    roundLabel.text = "\(selectedRound!.label_long) - \(sched)"
                    
                } else {
                    roundLabel.text = "\(selectedRound!.label_long) - Scheduled \(sched)"
                    
                }
                
                
            } else {
                roundLabel.text = "\(selectedRound!.label_long) - Scheduled \(sched)"
            }

            save()
        }
        
    }
    
    @objc func updateTimer() {
        var prefix = ""
        var interval1 = 0.0
        var intervalisnegative:Bool = false
        
        if displayRound != nil {
            if displayRound!.sched.timeIntervalSinceNow > -60 {
                prefix = "-"
                interval1 = displayRound!.sched.timeIntervalSinceNow
                intervalisnegative = false
            } else {
                prefix = "+"
                interval1 = -1 * displayRound!.sched.timeIntervalSinceNow
                intervalisnegative = true
            }
            
            let interval2 = Int(interval1)
            let s = interval2 % 60
            var m = (interval2/60) % 60
            var h = (interval2/3600)
            
            if s >= 0 && !intervalisnegative { m += 1 }
            
            var mstring = ""
            var hstring = ""
            
            //Weird top-of-the-hour bug
            if m == 60 {
                m = 0
                h += 1
            }
            
            if m < 10 { mstring = "0\(m)" } else { mstring = String(m)}
            if h < 10 { hstring = "0\(h)" } else { hstring = String(h)}

            
            timerLabel.text = "\(prefix) \(hstring):\(mstring)"
            updateConfirmButtonState()
        }
        
       
        
    }
    
    @objc func updateCurrentTime() {
        let now = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        let sDate = Date.init(timeIntervalSinceNow: 1800)
        let s = DateFormatter.localizedString(from: sDate, dateStyle: .none, timeStyle: .medium)
        timeNowLabel.text = "The time now is \(now)"
        dsLabel.text = "+30 Minutes: \(s)"
        
    }

    @IBAction func toggleSwitcher(_ sender: Any) {
        let stackDimensions = switchStack.frame.size
        let stackHeight = stackDimensions.height * -0.5
        
        if switchStack.isHidden {
            timeLabelCentreY.constant = 0.0
        } else {
            timeLabelCentreY.constant = stackHeight
        }
        switchStack.isHidden = !switchStack.isHidden
        
        
    }
}

