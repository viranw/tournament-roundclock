//
//  tournamentBuild.swift
//  Easters 2019
//
//  Created by Viran Weerasekera on 20/12/18.
//  Copyright © 2018 Viran Weerasekera. All rights reserved.
//

import Foundation
import UserNotifications

func initialBuild() {
    
    allRounds = []
    allNotifications = []
    
    let center = UNUserNotificationCenter.current()
    center.removeAllPendingNotificationRequests()
    
    let tz = TimeZone(identifier: "Australia/Sydney")
    

    
    allRounds.append(round(seq: 1, label_long: "Round 1", label_short: "R1", status: "Estimated", schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:19,hour:10,minute:0,second:0))!))
   allRounds.append(round(seq: 1, label_long: "Round 2", label_short: "R2", status: "Estimated", schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:19,hour:13,minute:0,second:0))!))
    allRounds.append(round(seq: 1, label_long: "Round 3", label_short: "R3", status: "Estimated", schedStart:cal.date(from: DateComponents(timeZone: tz, year:2019,month:4,day:19,hour:10,minute:0,second:0))!))
    
    for round in allRounds {
        //buildNotificationsforRound(round: round.label_long, schedStart: round.schedStart)
    }
    
    
    
}
