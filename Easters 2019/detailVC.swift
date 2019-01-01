//
//  detailVC.swift
//  Easters 2019
//
//  Created by Viran Weerasekera on 31/12/18.
//  Copyright © 2018 Viran Weerasekera. All rights reserved.
//

import UIKit

class detailVC: UIViewController {
    
    @IBOutlet weak var adjAllocCompletedButton: UIButton!
    @IBOutlet weak var drawReleasedButton: UIButton!
    @IBOutlet weak var motionReleasedButton: UIButton!
    @IBOutlet weak var debatesStartButton: UIButton!
    @IBOutlet weak var firstBallotButton: UIButton!
    @IBOutlet weak var roundCompletedButton: UIButton!
    
    @IBOutlet weak var startRoundButton: UIButton!
    @IBOutlet weak var unstartRoundButton: UIButton!
    
    var roundIndex:Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = allRounds[roundIndex].label_long
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reschedule", style: .plain, target: self, action: #selector(reschedule))
        
        if let aac = allRounds[roundIndex].adjAllocCompleted {
            print(aac)
        }

        
        configureStartButtons(i: roundIndex)
        fillInTimes(i: roundIndex)
        
        
    }
    
    func configureStartButtons(i: Int) {
        startRoundButton.layer.cornerRadius = 10.0
        unstartRoundButton.layer.cornerRadius = 10.0
        
        startRoundButton.setTitle("Start Round", for: .normal)
        unstartRoundButton.setTitle("Unstart Round", for: .normal)
        
        if allRounds[i].isStarted {
            startRoundButton.backgroundColor = UIColor.lightGray
            unstartRoundButton.backgroundColor = UIColor.orange
            
            startRoundButton.isUserInteractionEnabled = false
            unstartRoundButton.isUserInteractionEnabled = true
        } else {
            startRoundButton.backgroundColor = UIColor.green
            unstartRoundButton.backgroundColor = UIColor.lightGray
            
            startRoundButton.isUserInteractionEnabled = true
            unstartRoundButton.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func start() {
        startRoundSuper(index: roundIndex)
        
        timeCall(vc: self, roundIndex: roundIndex)
        
        configureStartButtons(i: roundIndex)
        fillInTimes(i: roundIndex)
        writeRounds()
    }
    
    @IBAction func unstart() {
       
        
        
        configureStartButtons(i: roundIndex)
        fillInTimes(i: roundIndex)
        writeRounds()
    }
    
    func fillInTimes(i: Int) {
        let round = allRounds[i]
        
        // Adj Allocation Completed
        adjAllocCompletedButton.layer.cornerRadius = 10.0
        if round.adjAllocCompleted != nil {
            adjAllocCompletedButton.setTitle(DateFormatter.localizedString(from: round.adjAllocCompleted!, dateStyle: .none, timeStyle: .short), for: .normal)
            adjAllocCompletedButton.backgroundColor = UIColor.black
            //adjAllocCompletedButton.title
        } else {
            adjAllocCompletedButton.setTitle("--", for: .normal)
            adjAllocCompletedButton.backgroundColor = UIColor.lightGray
        }
        
        // Draw Released
        drawReleasedButton.layer.cornerRadius = 10.0
        if let dr = round.drawReleased {
            drawReleasedButton.setTitle(DateFormatter.localizedString(from: dr, dateStyle: .none, timeStyle: .short), for: .normal)
            drawReleasedButton.backgroundColor = UIColor.black
        } else {
            drawReleasedButton.setTitle("--", for: .normal)
            drawReleasedButton.backgroundColor = UIColor.lightGray
        }
        
        // Motion Released
        motionReleasedButton.layer.cornerRadius = 10.0
        if round.isStarted {
            motionReleasedButton.setTitle(DateFormatter.localizedString(from: round.actStart!, dateStyle: .none, timeStyle: .short), for: .normal)
            motionReleasedButton.backgroundColor = UIColor.black
        } else {
            motionReleasedButton.setTitle("--", for: .normal)
            motionReleasedButton.backgroundColor = UIColor.lightGray
        }
        
        // Debates Start
        debatesStartButton.layer.cornerRadius = 10.0
        
        if round.isStarted {
           // Prep is 30 minutes
            let ds = round.actStart!.addingTimeInterval(prepTime)
            round.debatesStart = ds
            debatesStartButton.setTitle(DateFormatter.localizedString(from: ds, dateStyle: .none, timeStyle: .short), for: .normal)
            debatesStartButton.backgroundColor = UIColor.black
        } else {
            debatesStartButton.setTitle("--", for: .normal)
            debatesStartButton.backgroundColor = UIColor.lightGray
        }
        
        // First Ballot
        firstBallotButton.layer.cornerRadius = 10.0
        if let fb = round.firstBallot {
            firstBallotButton.setTitle(DateFormatter.localizedString(from: fb, dateStyle: .none, timeStyle: .short), for: .normal)
            firstBallotButton.backgroundColor = UIColor.black
        } else {
            firstBallotButton.setTitle("--", for: .normal)
            firstBallotButton.backgroundColor = UIColor.lightGray
        }
        
        // Completed
        roundCompletedButton.layer.cornerRadius = 10.0
        if let rc = round.roundCompleted {
            roundCompletedButton.setTitle(DateFormatter.localizedString(from: rc, dateStyle: .none, timeStyle: .short), for: .normal)
            roundCompletedButton.backgroundColor = UIColor.black
        } else {
            roundCompletedButton.setTitle("--", for: .normal)
            roundCompletedButton.backgroundColor = UIColor.lightGray
        }
        
        //Button logic
        //If the round hasn't started, disable ballot buttons
        if round.isStarted {
            firstBallotButton.isUserInteractionEnabled = true
            roundCompletedButton.isUserInteractionEnabled = true
        } else {
            firstBallotButton.isUserInteractionEnabled = false
            roundCompletedButton.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func adjAllocSelected() {
        if allRounds[roundIndex].adjAllocCompleted != nil {
            allRounds[roundIndex].adjAllocCompleted = nil
        } else {
            allRounds[roundIndex].adjAllocCompleted = Date()
        }
        fillInTimes(i: roundIndex)
        writeRounds()
    }
    
    @IBAction func drawReleaseSelected() {
        if allRounds[roundIndex].drawReleased != nil {
            allRounds[roundIndex].drawReleased = nil
        } else {
            allRounds[roundIndex].drawReleased = Date()
        }
        fillInTimes(i: roundIndex)
        writeRounds()
    }
    
    @IBAction func firstBallotSelected() {
        if allRounds[roundIndex].firstBallot != nil {
            allRounds[roundIndex].firstBallot = nil
        } else {
            allRounds[roundIndex].firstBallot = Date()
        }
        fillInTimes(i: roundIndex)
        writeRounds()
    }
    
    @IBAction func roundCompletedSelected() {
        if allRounds[roundIndex].roundCompleted != nil {
            allRounds[roundIndex].roundCompleted = nil
        } else {
            allRounds[roundIndex].roundCompleted = Date()
        }
        fillInTimes(i: roundIndex)
        writeRounds()
    }

    @objc func reschedule() {
        if allRounds[roundIndex].isStarted {
            let ac = UIAlertController(title: "Round Locked", message: "\(allRounds[roundIndex].label_long!) is marked as started and cannot be rescheduled.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true)
        } else {
            if let edittimevc = storyboard?.instantiateViewController(withIdentifier: "EditTimes") as? EditTimesVC {
                // Pass variables
                edittimevc.currentStart = allRounds[roundIndex].estStart
                edittimevc.round = allRounds[roundIndex].label_long
                edittimevc.index = roundIndex
                
                //3: Push controller
                navigationController?.pushViewController(edittimevc, animated: true)
            }
        }
    }
}
