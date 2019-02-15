//
//  base.swift
//  Easters 2019 Clock
//
//  Created by Viran Weerasekera on 10/1/19.
//  Copyright © 2019 Viran Weerasekera. All rights reserved.
//

import Foundation


var allRounds:[round] = []
var allRoundsByDay:[Int:[round]] = [:]

let cal = Calendar(identifier: .gregorian)


var tz = TimeZone(identifier: "Australia/Sydney")
var dayLabels:[Int:String] = [0:"Saturday", 1:"Sunday"]

class round: NSObject, Codable {
    var label_long:String
    var label_short:String
    var sched:Date
    var day:Int
    var dayInd:Int // Round sequence number relative to other rounds in the same day
    
    init(label_long:String, label_short:String, day:Int, dayInd:Int, sched:Date) {
        self.label_long = label_long
        self.label_short = label_short
        self.day = day
        self.dayInd = dayInd
        self.sched = sched
    }
    
}

func initialBuild() {
    allRounds = []
    
    allRounds.append(round(label_long: "Round 1",
                           label_short: "R1",
                           day: 0,
                           dayInd: 0,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 2,
                                                                day: 9,
                                                                hour: 10,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Round 2",
                           label_short: "R2",
                           day: 0,
                           dayInd: 1,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 2,
                                                                day: 9,
                                                                hour: 13,
                                                                minute: 15,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Round 3",
                           label_short: "R3",
                           day: 0,
                           dayInd: 2,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 2,
                                                                day: 9,
                                                                hour: 16,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Round 4",
                          label_short: "R4",
                          day: 1,
                          dayInd: 0,
                          sched: cal.date(from: DateComponents(timeZone: tz,
                                                               year: 2019,
                                                               month: 2,
                                                               day: 10,
                                                               hour: 10,
                                                               minute: 0,
                                                               second: 0))!))
    
    allRounds.append(round(label_long: "Round 5",
                           label_short: "R5",
                           day: 1,
                           dayInd: 1,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 2,
                                                                day: 10,
                                                                hour: 12,
                                                                minute: 30,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Semifinals",
                           label_short: "SF",
                           day: 1,
                           dayInd: 2,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 2,
                                                                day: 10,
                                                                hour: 15,
                                                                minute: 30,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Grand Final",
                           label_short: "GF",
                           day: 1,
                           dayInd: 3,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 2,
                                                                day: 10,
                                                                hour: 17,
                                                                minute: 0,
                                                                second: 0))!))
    
    
    
    
}

