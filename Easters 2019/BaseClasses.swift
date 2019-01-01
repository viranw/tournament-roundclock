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
    print("Raw Delay: \(total)")
    var knockon:TimeInterval = 0.0
    
    if i != 0 && allRounds[i].day == allRounds[i-1].day {
        // Not round 1, not the first round of the day - There's knockon
        knockon = calculateRawDelay(for: allRounds[i-1])
        print("Knockon: \(total)")
        let unique = total - knockon
        print(calculateRawDelay(for: allRounds[i]) - calculateRawDelay(for: allRounds[i-1]))
        print(unique)
        return unique
    } else {
        // Either round 1 or the first round of the day - Delay is entirely unique
        print(total)
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
            print("---")
            print("Before: \(allRounds[i].schedStart)")
            // Past round occurred on the same day, add the delay from that round to the estimated unique delay from this round
            print("Round \(i+1) occurs on the same day as Round \(i)")
            print("\(calculateRawDelay(for: allRounds[i-1]))")
            let intermediate = allRounds[i].schedStart.addingTimeInterval(calculateRawDelay(for: allRounds[i-1]))
            print("Intermediate: \(intermediate)")
            print("RoundDelay: \(calculateUniqueDelay(forRoundIndex: i))")
            print("After: \(intermediate.addingTimeInterval(calculateUniqueDelay(forRoundIndex: i)))")
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
        bar.tintColor = UIColor.re
    } else if bar.progress > 0.5 && bar.progress < 1 {
        bar.tintColor = UIColor.blue
    } else if bar.progress == 1 {
        bar.tintColor = UIColor.green
    }
}







func buildNotificationsforRound(round:String, schedStart:DateComponents) {
    let cal = Calendar(identifier: .gregorian)
    let schedStartDated = cal.date(from: schedStart)!
    
    //Round begins in 15
    let minus15date = schedStartDated.addingTimeInterval(-15*60)
    let minus15 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: minus15date)
    scheduleNotification(title: round, body: "begins in 15 minutes.", sound: .default, year: minus15.year!, month: minus15.month!, day: minus15.day!, hour: minus15.hour!, minute: minus15.minute!, second: minus15.second!)
    
    //Round begins in 10
    let minus10date = schedStartDated.addingTimeInterval(-10*60)
    let minus10 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: minus10date)
    scheduleNotification(title: round, body: "begins in 10 minutes.", sound: .default, year: minus10.year!, month: minus10.month!, day: minus10.day!, hour: minus10.hour!, minute: minus10.minute!, second: minus10.second!)
    
    //Round begins in 5
    let minus5date = schedStartDated.addingTimeInterval(-10*60)
    let minus5 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: minus5date)
    scheduleNotification(title: round, body: "begins in 5 minutes.", sound: .default, year: minus5.year!, month: minus5.month!, day: minus5.day!, hour: minus5.hour!, minute: minus5.minute!, second: minus5.second!)
    
    
    //Check-in is now open (-60)
    let minus60date = schedStartDated.addingTimeInterval(-60*60)
    let minus60 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: minus60date)
    scheduleNotification(title: round, body: "Check-in for \(round) is now open.", sound: .default, year: minus60.year!, month: minus60.month!, day: minus60.day!, hour: minus60.hour!, minute: minus60.minute!, second: minus60.second!)
    
    //Check-in closes in 30 (-50)
    let minus50date = schedStartDated.addingTimeInterval(-50*60)
    let minus50 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: minus50date)
    scheduleNotification(title: round, body: "Check-in for \(round) closes in 30 minutes.", sound: .default, year: minus50.year!, month: minus50.month!, day: minus50.day!, hour: minus50.hour!, minute: minus50.minute!, second: minus50.second!)
    
    //Check-in closes in 15 (-35)
    let minus35date = schedStartDated.addingTimeInterval(-35*60)
    let minus35 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: minus35date)
    scheduleNotification(title: round, body: "Check-in for \(round) closes in 15 minutes.", sound: .default, year: minus35.year!, month: minus35.month!, day: minus35.day!, hour: minus35.hour!, minute: minus35.minute!, second: minus35.second!)
    
    
    //Check-in closes in 5 (-25)
    let minus25date = schedStartDated.addingTimeInterval(-25*60)
    let minus25 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: minus25date)
    scheduleNotification(title: round, body: "Check-in for \(round) closes in 5 minutes.", sound: .default, year: minus25.year!, month: minus25.month!, day: minus25.day!, hour: minus25.hour!, minute: minus25.minute!, second: minus25.second!)
    
    //Check-in closes in 1 (-21)
    let minus21date = schedStartDated.addingTimeInterval(-21*60)
    let minus21 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: minus21date)
    scheduleNotification(title: round, body: "Check-in for \(round) closes in 1 minute.", sound: .default, year: minus21.year!, month: minus21.month!, day: minus21.day!, hour: minus21.hour!, minute: minus21.minute!, second: minus21.second!)
    
    //Check-in is now closed (-20)
    let minus20date = schedStartDated.addingTimeInterval(-20*60)
    let minus20 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: minus20date)
    scheduleNotification(title: round, body: "Check-in for \(round) is now closed.", sound: .default, year: minus20.year!, month: minus20.month!, day: minus20.day!, hour: minus20.hour!, minute: minus20.minute!, second: minus20.second!)  
    
}





func adjustStartTimeForRound(round:String, schedStart:DateComponents, oldEstStart:DateComponents) {
    
}





func scheduleNotification(title:String, body:String, sound: UNNotificationSound, year:Int, month:Int, day:Int, hour:Int, minute:Int, second:Int) {
    
    let center = UNUserNotificationCenter.current()
    
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.categoryIdentifier = "alarm"
    content.userInfo = ["customData":"fizzbuzz"]
    content.sound = sound
    
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day
    dateComponents.hour = hour
    dateComponents.minute = minute
    dateComponents.second = second
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    center.add(request)
    
    allNotifications.append(notificationObject(title: title, body: body, date: dateComponents))
    
}






























func shortTimeStringfromComponents(components: DateComponents) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.none
    dateFormatter.timeStyle = DateFormatter.Style.short
    
    let cal = Calendar(identifier: .gregorian)
    let start = cal.date(from: components)!
    let timeString = dateFormatter.string(from: start)
    
    return timeString
}

func shortTimefromComponents(components: DateComponents) -> Date {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.none
    dateFormatter.timeStyle = DateFormatter.Style.short
    
    let cal = Calendar(identifier: .gregorian)
    let start = cal.date(from: components)!
    return start
}

func shortTimeStringfromDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.none
    dateFormatter.timeStyle = DateFormatter.Style.short
    
    let timeString = dateFormatter.string(from: date)
    return timeString
}

func scheduleNotification2(title:String, body:String, sound: UNNotificationSound, delay:Int) {
    
    let center = UNUserNotificationCenter.current()
    
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.categoryIdentifier = "alarm"
    content.userInfo = ["customData":"fizzbuzz"]
    content.sound = sound
    
    //var dateComponents = DateComponents()
    //dateComponents.hour = 14
    //dateComponents.minute = 40
    //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delay), repeats: false)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    center.add(request)
    
}



func clearNotifications() {
    let center = UNUserNotificationCenter.current()
    center.removeAllPendingNotificationRequests()
}

func getPending() {
    UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
        print("here are the iOS 10 notifs \(requests)")
    }
}

class notificationObject {
    var title:String
    var body:String
    var date:DateComponents


    init(title:String, body:String, date:DateComponents) {
        self.title = title
        self.body = body
        self.date = date
    }
}

