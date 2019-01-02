//
//  BaseClasses.swift
//  Easters 2019
//
//  Created by Viran Weerasekera on 17/12/18.
//  Copyright © 2018 Viran Weerasekera. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

var allRounds:[round] = []
var allRoundsIntermediate:[round] = []
var upcomingRounds:[round] = []
var inProgressRounds:[round] = []
var pastRounds:[round] = []
var tournamentDelay:TimeInterval = 0
var allNotifications:[notificationObject] = []
var notificationsForRound:[String:notificationObject] = [:]

var cal = Calendar(identifier: .gregorian)

class round: NSObject, Codable {
    
    var seq:Int!
    var label_long:String!
    var label_short:String!
    var isStarted:Bool
    var schedStart:Date
    var estStart:Date
    var actStart:Date?
    var checkincloses:Date
    var snsStart:Date
    var day:Int
    var uniqueDelay:TimeInterval
    //Unique delay = Delay caused directly by rescheduling that round, not by knock-on - Only modified if you manually edit a round's start time
    //TODO: Automatically calculate when you start a round, reset if unstarted
    //Reset when unstarted: Unique = Sched v Est less knock on from the last round
    
    var adjAllocCompleted:Date?
    var drawReleased:Date?
    var debatesStart:Date?
    var firstBallot:Date?
    var roundCompleted:Date?
    
    init(seq:Int, label_long:String, label_short:String,isStarted:Bool, day:Int, schedStart:Date) {
        self.seq = seq
        self.label_long = label_long
        self.label_short = label_short
        self.isStarted = isStarted
        self.day = day
        self.schedStart = schedStart
        self.estStart = schedStart
        self.snsStart = schedStart
        self.uniqueDelay = 0.0
        self.checkincloses = schedStart.addingTimeInterval(checkinLead)
        
    }
}

func startRoundSuper(index: Int) {
    allRounds[index].isStarted = !allRounds[index].isStarted
    allRounds[index].actStart = Date()
    allRounds[index].debatesStart = allRounds[index].actStart!.addingTimeInterval(prepTime)
    allRounds[index].firstBallot = nil
    allRounds[index].roundCompleted = nil
    estimateFutureStartsAfterEdit(forRoundIndex: index)
    writeRounds()
}

func unstartRoundSuper(index: Int) {
    allRounds[index].isStarted = !allRounds[index].isStarted
    allRounds[index].actStart = nil
    allRounds[index].firstBallot = nil
    allRounds[index].roundCompleted = nil
    allRounds[index].uniqueDelay = calculateUniqueDelay(forRoundIndex: index)
    estimateFutureStartsAfterEdit(forRoundIndex: index)
    writeRounds()
}

// Calculate deviation from the schedule for the current round
func calculateRawDelay(for round: round) -> TimeInterval {
    if round.isStarted {
        // Round has started, the delay is sched vs act
        return round.actStart!.timeIntervalSince(round.schedStart)
    } else {
        // Round has not started, the delay is sched vs est
        return round.estStart.timeIntervalSince(round.schedStart)
    }
}

func calculateUniqueDelay(forRoundIndex i: Int) -> TimeInterval {
    //Unique = Total minus knockon
    let total = calculateRawDelay(for: allRounds[i])
    var knockon:TimeInterval = 0.0
    
    if i != 0 && allRounds[i].day == allRounds[i-1].day {
        // Not round 1, not the first round of the day - There's knockon
        knockon = calculateRawDelay(for: allRounds[i-1])
        let unique = total - knockon
        return unique
    } else {
        // Either round 1 or the first round of the day - Delay is entirely unique
        return total
    }
}

func estimateFutureStartsAfterEdit(forRoundIndex index:Int) {
    if index < allRounds.count {
        //This is the last round, there are no future rounds to estimate
        for i in (index+1...allRounds.count-1) {
            if !allRounds[i].isStarted {
                // Round has not started, we should calculate a new delay
                
                if i != 0 && allRounds[i].day == allRounds[i-1].day {
                    allRounds[i].estStart = allRounds[i].schedStart + calculateRawDelay(for: allRounds[i-1]) + allRounds[i].uniqueDelay
                } else {
                    allRounds[i].estStart = allRounds[i].schedStart + allRounds[i].uniqueDelay
                }
                
                allRounds[i].snsStart = calculateSNS(forRoundIndex: i)
            }
        }
    }
}

func calculateKnockOn(forRoundIndex i: Int) -> TimeInterval {
    return calculateRawDelay(for: allRounds[i]) - calculateUniqueDelay(forRoundIndex: i)
}

// Calculate delay, taking into account the knock-on effect from the past round
func calculateDelayWithKnockOn(forRoundIndex i:Int) -> Date {
    if i == 0 {
        // Round 1, no knockon
        // Sched vs Est only
        return allRounds[i].schedStart.addingTimeInterval(calculateRawDelay(for: allRounds[i]))
    } else {
        if allRounds[i].day == allRounds[i-1].day {
            // Past round occurred on the same day, add the delay from that round to the estimated unique delay from this round
            let intermediate = allRounds[i].schedStart.addingTimeInterval(calculateRawDelay(for: allRounds[i-1]))
            return intermediate.addingTimeInterval(calculateUniqueDelay(forRoundIndex: i))
        } else {
            return allRounds[i].schedStart.addingTimeInterval(calculateRawDelay(for: allRounds[i]))
        }
    }
}

func writeRounds() {
    let jsonEncoder = JSONEncoder()
    if let savedData = try? jsonEncoder.encode(allRounds) {
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "allRounds")
    } else {
        print("Failed to Save")
    }
}

func calculateSNS(forRoundIndex i: Int) -> Date {
    // SNS = Normal delay calculation, but only
    if i == 0 {
        // It's round 1, the array lookup will fail
        return allRounds[i].schedStart
    } else {
        if allRounds[i].day == allRounds[i-1].day {
            // The previous round is on the same day, return their delay
            return allRounds[i].schedStart.addingTimeInterval(calculateRawDelay(for: allRounds[i-1]))
        } else {
            return allRounds[i].schedStart
        }
    }
}

func timeCall(vc: UIViewController, roundIndex: Int) {
    
    let round = allRounds[roundIndex]
    
    if round.actStart != nil {
        if round.debatesStart != nil {
            
            let timeNow = DateFormatter.localizedString(from: round.actStart!, dateStyle: .none, timeStyle: .short)
            let debatesStart = DateFormatter.localizedString(from: round.debatesStart!, dateStyle: .none, timeStyle: .short)
            
            let ac = UIAlertController(title: "Time Call", message: "The time now is \(timeNow). Debates will start at \(debatesStart).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            vc.present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Error", message: "The selected round does not have a recorded round start time.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            vc.present(ac, animated: true)
        }
    } else {
        let ac = UIAlertController(title: "Error", message: "The selected round does not have a recorded motion release time.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
    }
}

func updateProgressBar(bar:UIProgressView, forRoundIndex: Int) {
    var progress:Float = 0.0
    let round = allRounds[forRoundIndex]
    
    for check in [round.adjAllocCompleted, round.drawReleased, round.actStart, round.firstBallot, round.roundCompleted] {
        if check != nil {
            progress += 0.2
        }
    }
    bar.progress = progress
    
    if bar.progress < 0.5 {
        bar.tintColor = UIColor.red
    } else if bar.progress > 0.5 && bar.progress < 1 {
        bar.tintColor = UIColor.blue
    } else if bar.progress == 1 {
        bar.tintColor = UIColor.green
    }
}
