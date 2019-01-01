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


func initialBuild() {

    allRounds = []
    allNotifications = []
    
    let center = UNUserNotificationCenter.current()
    center.removeAllPendingNotificationRequests()
    
    let tz = TimeZone(identifier: "Australia/Sydney")
    
    //Check-in lead is negative because the time interval is added
    
    
    
    allRounds.append(round(seq: 1, label_long: "Round 1", label_short: "R1", isStarted:false, day:1, schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:19,hour:10,minute:0,second:0))!))
    allRounds.append(round(seq: 1, label_long: "Round 2", label_short: "R2", isStarted:false, day:1, schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:19,hour:13,minute:0,second:0))!))
    allRounds.append(round(seq: 1, label_long: "Round 3", label_short: "R3", isStarted:false, day:1, schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:19,hour:16,minute:0,second:0))!))
    
    allRounds.append(round(seq: 1, label_long: "Round 4", label_short: "R4", isStarted:false, day:2, schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:20,hour:10,minute:0,second:0))!))
    
    //for round in allRounds {
        //buildNotificationsforRound(round: round.label_long, schedStart: round.schedStart)
    //}
    
    
    
}
