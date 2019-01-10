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
var dayLabels:[Int:String] = [0:"Friday", 1:"Saturday", 2:"Sunday"]
let cal = Calendar(identifier: .gregorian)
var tz = TimeZone(identifier: "Australia/Sydney")

let appDefaults = UserDefaults.init(suiteName: "group.com.viranweerasekera.Easters-2019-Clock.Widget")

class round: NSObject, Codable {
    var label_long:String
    var label_short:String
    var sched:Date
    var day:Int
    var dayInd:Int
    
    init(label_long:String, label_short:String, sched:Date, day:Int, dayInd:Int) {
        self.label_long = label_long
        self.label_short = label_short
        self.sched = sched
        self.day = day
        self.dayInd = dayInd
    }
    
}

func initialBuild() {
    allRounds = []
    
    allRounds.append(round(label_long: "Round 1", label_short: "R1", sched: cal.date(from: DateComponents(timeZone: tz, year: 2019, month: 1, day: 10, hour: 20, minute: 20, second: 0))!, day: 0, dayInd: 0))
    allRounds.append(round(label_long: "Round 2", label_short: "R2", sched: cal.date(from: DateComponents(timeZone: tz, year: 2019, month: 4, day: 19, hour: 13, minute: 0, second: 0))!, day: 0, dayInd: 1))
    allRounds.append(round(label_long: "Round 3", label_short: "R3", sched: cal.date(from: DateComponents(timeZone: tz, year: 2019, month: 4, day: 19, hour: 16, minute: 0, second: 0))!, day: 0, dayInd: 2))
    
    allRounds.append(round(label_long: "Round 4", label_short: "R4", sched: cal.date(from: DateComponents(timeZone: tz, year: 2019, month: 4, day: 20, hour: 10, minute: 0, second: 0))!, day: 1, dayInd: 0))
    allRounds.append(round(label_long: "Round 5", label_short: "R5", sched: cal.date(from: DateComponents(timeZone: tz, year: 2019, month: 4, day: 20, hour: 13, minute: 0, second: 0))!, day: 1, dayInd: 1))
    allRounds.append(round(label_long: "Round 6", label_short: "R6", sched: cal.date(from: DateComponents(timeZone: tz, year: 2019, month: 4, day: 20, hour: 16, minute: 0, second: 0))!, day: 1, dayInd: 2))
    
    allRounds.append(round(label_long: "Octofinals", label_short: "OF", sched: cal.date(from: DateComponents(timeZone: tz, year: 2019, month: 4, day: 21, hour: 10, minute: 0, second: 0))!, day: 2, dayInd: 0))
    allRounds.append(round(label_long: "Quarterfinals", label_short: "QF", sched: cal.date(from: DateComponents(timeZone: tz, year: 2019, month: 4, day: 21, hour: 13, minute: 0, second: 0))!, day: 2, dayInd: 1))
    allRounds.append(round(label_long: "Semifinals", label_short: "SF", sched: cal.date(from: DateComponents(timeZone: tz, year: 2019, month: 4, day: 21, hour: 16, minute: 0, second: 0))!, day: 2, dayInd: 2))
    allRounds.append(round(label_long: "Grand Final", label_short: "GF", sched: cal.date(from: DateComponents(timeZone: tz, year: 2019, month: 4, day: 21, hour: 19, minute: 0, second: 0))!, day: 2, dayInd: 3))

}

