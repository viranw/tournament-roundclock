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


var tz = TimeZone(identifier: "Asia/Singapore")
var dayLabels:[Int:String] = [0:"Tuesday", 1:"Wednesday", 2:"Thursday", 3:"Friday", 4:"Saturday", 5:"Sunday"]

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

//MARK: Round Times
func initialBuild() {
    allRounds = []
    
    allRounds.append(round(label_long: "Round 1",
                           label_short: "R1",
                           day: 0,
                           dayInd: 0,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 7,
                                                                day: 2,
                                                                hour: 13,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Round 2",
                           label_short: "R2",
                           day: 0,
                           dayInd: 1,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 7,
                                                                day: 2,
                                                                hour: 16,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Round 3",
                           label_short: "R3",
                           day: 1,
                           dayInd: 0,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 7,
                                                                day: 3,
                                                                hour: 10,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Round 4",
                          label_short: "R4",
                          day: 1,
                          dayInd: 1,
                          sched: cal.date(from: DateComponents(timeZone: tz,
                                                               year: 2019,
                                                               month: 7,
                                                               day: 3,
                                                               hour: 13,
                                                               minute: 0,
                                                               second: 0))!))
    
    allRounds.append(round(label_long: "Round 5",
                           label_short: "R5",
                           day: 1,
                           dayInd: 2,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 7,
                                                                day: 3,
                                                                hour: 16,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Round 6",
                           label_short: "R6",
                           day: 2,
                           dayInd: 0,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 7,
                                                                day: 4,
                                                                hour: 10,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Round 7",
                           label_short: "R7",
                           day: 2,
                           dayInd: 1,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 7,
                                                                day: 4,
                                                                hour: 12,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Round 8",
                           label_short: "R8",
                           day: 2,
                           dayInd: 2,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 7,
                                                                day: 4,
                                                                hour: 17,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Open Octofinals",
                           label_short: "OOF",
                           day: 4,
                           dayInd: 0,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 7,
                                                                day: 6,
                                                                hour: 11,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "All Quarterfinals",
                           label_short: "XQF",
                           day: 4,
                           dayInd: 1,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 7,
                                                                day: 6,
                                                                hour: 13,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "All Semifinals",
                           label_short: "XSF",
                           day: 4,
                           dayInd: 2,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 7,
                                                                day: 6,
                                                                hour: 15,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "EFL Grand Final",
                           label_short: "EFLGF",
                           day: 5,
                           dayInd: 0,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 7,
                                                                day: 7,
                                                                hour: 9,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "ESL Grand Final",
                           label_short: "ESLGF",
                           day: 5,
                           dayInd: 1,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 7,
                                                                day: 7,
                                                                hour: 10,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Open Grand Final",
                           label_short: "OGF",
                           day: 5,
                           dayInd: 2,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 7,
                                                                day: 7,
                                                                hour: 11,
                                                                minute: 0,
                                                                second: 0))!))
    
    
    
    
}

