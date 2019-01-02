//
//  tournamentBuild.swift
//  Easters 2019
//
//  Created by Viran Weerasekera on 20/12/18.
//  Copyright © 2018 Viran Weerasekera. All rights reserved.
//

import Foundation
import UserNotifications

let days = [1,2,3]

let checkinLead:TimeInterval = -1200.0
let prepTime:TimeInterval = 1800.0

let tabSite:String = "http://easters2019.herokuapp.com"
let tournamentName = "Easters 2019"


func initialBuild(rdIndex: Int?) {
    
    allRoundsIntermediate = []
    allNotifications = []
    
    let center = UNUserNotificationCenter.current()
    center.removeAllPendingNotificationRequests()
    
    let tz = TimeZone(identifier: "Australia/Sydney")
    
    allRoundsIntermediate.append(round(seq: 1, label_long: "Round 1", label_short: "R1", isStarted:false, day:1, schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:19,hour:10,minute:0,second:0))!))
    allRoundsIntermediate.append(round(seq: 2, label_long: "Round 2", label_short: "R2", isStarted:false, day:1, schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:19,hour:13,minute:30,second:0))!))
    allRoundsIntermediate.append(round(seq: 3, label_long: "Round 3", label_short: "R3", isStarted:false, day:1, schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:19,hour:16,minute:15,second:0))!))
    
    allRoundsIntermediate.append(round(seq: 4, label_long: "Round 4", label_short: "R4", isStarted:false, day:2, schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:20,hour:9,minute:30,second:0))!))
    allRoundsIntermediate.append(round(seq: 5, label_long: "Round 5", label_short: "R5", isStarted:false, day:2, schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:20,hour:13,minute:15,second:0))!))
    allRoundsIntermediate.append(round(seq: 6, label_long: "Round 6", label_short: "R6", isStarted:false, day:2, schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:20,hour:16,minute:15,second:0))!))
    
    allRoundsIntermediate.append(round(seq: 7, label_long: "Octofinals", label_short: "OF", isStarted:false, day:3, schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:21,hour:9,minute:15,second:0))!))
    
    allRoundsIntermediate.append(round(seq: 8, label_long: "Quarterfinals", label_short: "QF", isStarted:false, day:3, schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:21,hour:11,minute:45,second:0))!))
    
    allRoundsIntermediate.append(round(seq: 9, label_long: "Semifinals", label_short: "SF", isStarted:false, day:3, schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:21,hour:14,minute:15,second:0))!))
    
    allRoundsIntermediate.append(round(seq: 10, label_long: "Grand Final", label_short: "GF", isStarted:false, day:3, schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:21,hour:18,minute:45,second:0))!))
    
    
    if rdIndex == nil {
        allRounds = []
        for r in allRoundsIntermediate {
            allRounds.append(r)
        }
        writeRounds()
    } else {
        // Receive the index of the round
        // Remove the round at that index
        // Insert the fresh round at that index
        allRounds.remove(at: rdIndex!)
        allRounds.insert(allRoundsIntermediate[rdIndex!], at: rdIndex!)
        estimateFutureStartsAfterEdit(forRoundIndex: rdIndex!)
        writeRounds()
    }

    //allRounds = []
    
    
    //Check-in lead is negative because the time interval is added
    
    
    
    
    
    //for round in allRounds {
        //buildNotificationsforRound(round: round.label_long, schedStart: round.schedStart)
    //}
    
    
    
}
