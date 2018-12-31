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
    
    
    allRounds.append(round(seq: 1, label_long: "Round 1", label_short: "R1", status: "Estimated", schedStart:DateComponents(year:2018,month:12,day:19,hour:15,minute:10,second:0)))
    allRounds.append(round(seq: 2, label_long: "Round 2", label_short: "R2", status: "Estimated", schedStart:DateComponents(year:2018,month:12,day:19,hour:15,minute:20,second:0)))
    allRounds.append(round(seq: 3, label_long: "Round 3", label_short: "R3", status: "Estimated", schedStart:DateComponents(year:2018,month:12,day:19,hour:15,minute:30,second:0)))
    
    for round in allRounds {
        buildNotificationsforRound(round: round.label_long, schedStart: round.schedStart)
    }
    
    
    
}
