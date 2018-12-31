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

func initialBuild() {
    
    
    allRounds = []
    allNotifications = []
    
    let center = UNUserNotificationCenter.current()
    center.removeAllPendingNotificationRequests()
    
    let tz = TimeZone(identifier: "Australia/Sydney")
    

    
    
    allRounds.append(round(seq: 1, label_long: "Round 1", label_short: "R1", isComplete:false, day:1, schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:19,hour:10,minute:0,second:0))!))
    allRounds.append(round(seq: 1, label_long: "Round 2", label_short: "R2", isComplete:false, day:1, schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:19,hour:13,minute:0,second:0))!))
    allRounds.append(round(seq: 1, label_long: "Round 3", label_short: "R3", isComplete:false, day:1, schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:19,hour:16,minute:0,second:0))!))
    
    allRounds.append(round(seq: 1, label_long: "Round 4", label_short: "R4", isComplete:false, day:2, schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:20,hour:10,minute:0,second:0))!))
    
    //for round in allRounds {
        //buildNotificationsforRound(round: round.label_long, schedStart: round.schedStart)
    //}
    
    
    
}
