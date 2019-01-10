//
//  ViewController.swift
//  Easters 2019 Clock
//
//  Created by Viran Weerasekera on 10/1/19.
//  Copyright © 2019 Viran Weerasekera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var daySelector: UISegmentedControl!
    @IBOutlet weak var roundSelector: UISegmentedControl!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timeNowLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var roundLabel: UILabel!
    
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
        
        
        if let savedRounds = appDefaults?.object(forKey: "displayRound") as? Data {
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
        
        let index = daySelector.selectedSegmentIndex
        print(index)
        var roundstopopulate:[round] = []
        
        for round in allRounds {
            if round.day == index {
                roundstopopulate.append(round)
            }
        }
        
        roundSelector.removeAllSegments()
        var ind = 0
        for i in roundstopopulate {
            roundSelector.insertSegment(withTitle: i.label_long, at: ind, animated: false)
            
            ind += 1
        }
        
        timerLabel.text = ""

        
        confirmButton.layer.cornerRadius = 10.0
        confirmButton.clipsToBounds = true
        confirmButton.layer.backgroundColor = UIColor.green.cgColor
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        
        
        
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


    @IBAction func dayChanged(_ sender: Any) {
        
        let index = daySelector.selectedSegmentIndex
        print(index)
        var roundstopopulate:[round] = []
        
        for round in allRounds {
            if round.day == index {
                roundstopopulate.append(round)
            }
        }
        
        roundSelector.removeAllSegments()
        var ind = 0
        for i in roundstopopulate {
            roundSelector.insertSegment(withTitle: i.label_long, at: ind, animated: false)
            
            ind += 1
        }
    }
    
    @IBAction func roundChanged(_ sender: Any) {
        //Get the round to populate by cross-referencing the dayindex and roundindex from the selectors
        for round in allRounds {
            if round.day == daySelector.selectedSegmentIndex && round.dayInd == roundSelector.selectedSegmentIndex {
                selectedRound = round
            }
            updateSwitchButtonState()
        }
    }
    
    @IBAction func roundChangedConfirm(_ sender: Any) {
        displayRound = selectedRound
        let sched = DateFormatter.localizedString(from: selectedRound!.sched, dateStyle: .none, timeStyle: .short)
        roundLabel.text = "\(selectedRound!.label_long) - Scheduled \(sched)"
        save()
    }
    
    func updateSwitchButtonState() {
        if displayRound == nil {
            confirmButton.layer.backgroundColor = UIColor.green.cgColor
            confirmButton.isUserInteractionEnabled = true
        } else if selectedRound == displayRound! {
            confirmButton.layer.backgroundColor = UIColor.lightGray.cgColor
            confirmButton.isUserInteractionEnabled = false
        } else {
            confirmButton.layer.backgroundColor = UIColor.green.cgColor
            confirmButton.isUserInteractionEnabled = true
        }
    }
    
    func resetTimer() {
        
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
            let h = (interval2/3600)
            
            if s >= 0 && !intervalisnegative { m += 1 }
            
            var mstring = ""
            var hstring = ""
            
            if m < 10 { mstring = "0\(m)" } else { mstring = String(m)}
            if h < 10 { hstring = "0\(h)" } else { hstring = String(h)}

            
            timerLabel.text = "\(prefix) \(hstring):\(mstring)"
        }
        
       
        
    }
    
    @objc func updateCurrentTime() {
        let now = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        timeNowLabel.text = "The time now is \(now)"
        
    }

    @IBAction func toggleSwitcher(_ sender: Any) {
        switchStack.isHidden = !switchStack.isHidden
        
    }
}

