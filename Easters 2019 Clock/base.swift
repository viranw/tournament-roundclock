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
let appDefaults = UserDefaults.init(suiteName: "group.com.viranweerasekera.Easters-2019-Clock.Widget")


var tz = TimeZone(identifier: "Australia/Sydney")
var dayLabels:[Int:String] = [0:"Friday", 1:"Saturday", 2:"Sunday", 3:"Monday", 4:"Tuesday", 5:"Wednesday"]

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
                                                                month: 1,
                                                                day: 11,
                                                                hour: 10,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Round 2",
                           label_short: "R2",
                           day: 0,
                           dayInd: 1,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 1,
                                                                day: 11,
                                                                hour: 13,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Round 3",
                           label_short: "R3",
                           day: 0,
                           dayInd: 2,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 1,
                                                                day: 11,
                                                                hour: 16,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Round 4",
                           label_short: "R4",
                           day: 1,
                           dayInd: 0,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 1,
                                                                day: 11,
                                                                hour: 10,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Round 5",
                           label_short: "R5",
                           day: 1,
                           dayInd: 1,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 1,
                                                                day: 11,
                                                                hour: 13,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Round 6",
                           label_short: "R6",
                           day: 1,
                           dayInd: 2,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 1,
                                                                day: 11,
                                                                hour: 16,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Round 7",
                           label_short: "R7",
                           day: 2,
                           dayInd: 0,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 1,
                                                                day: 11,
                                                                hour: 10,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Round 8",
                           label_short: "R8",
                           day: 2,
                           dayInd: 1,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 1,
                                                                day: 11,
                                                                hour: 15,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Open Partial Double-Octofinals",
                           label_short: "OPDOF",
                           day: 4,
                           dayInd: 0,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 1,
                                                                day: 11,
                                                                hour: 9,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Open Octofinals",
                           label_short: "OOF",
                           day: 4,
                           dayInd: 1,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 1,
                                                                day: 11,
                                                                hour: 11,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "ESL Quarterfinals/EFL Semifinals",
                           label_short: "OR3",
                           day: 4,
                           dayInd: 2,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 1,
                                                                day: 11,
                                                                hour: 13,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Open Quarterfinals/ESL Semifinals",
                           label_short: "OR4",
                           day: 4,
                           dayInd: 3,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 1,
                                                                day: 11,
                                                                hour: 15,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Open Semifinals",
                           label_short: "OSF",
                           day: 5,
                           dayInd: 0,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 1,
                                                                day: 11,
                                                                hour: 9,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "EFL Grand Final",
                           label_short: "EFLGF",
                           day: 5,
                           dayInd: 1,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 1,
                                                                day: 11,
                                                                hour: 11,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "ESL Grand Final",
                           label_short: "ESLGF",
                           day: 5,
                           dayInd: 2,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 1,
                                                                day: 11,
                                                                hour: 17,
                                                                minute: 0,
                                                                second: 0))!))
    
    allRounds.append(round(label_long: "Open Grand Final",
                           label_short: "OGF",
                           day: 5,
                           dayInd: 3,
                           sched: cal.date(from: DateComponents(timeZone: tz,
                                                                year: 2019,
                                                                month: 1,
                                                                day: 11,
                                                                hour: 19,
                                                                minute: 0,
                                                                second: 0))!))
    
    
}

