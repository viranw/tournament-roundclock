//
//  ViewController.swift
//  Easters 2019
//
//  Created by Viran Weerasekera on 17/12/18.
//  Copyright © 2018 Viran Weerasekera. All rights reserved.
//

import UIKit
import UserNotifications

class HomeVC: UITableViewController, UITabBarControllerDelegate {

    
    var hour:Int = 14
    var minute:Int = 45

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialBuild()
        
        let defaults = UserDefaults.standard
        if let savedRounds = defaults.object(forKey: "allRounds") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                allRounds = try jsonDecoder.decode([round].self, from: savedRounds)
            } catch {
                print("Failed to load from UserDefaults, loading default")
                
            }
        }
        

        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Rounds"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRounds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> HomeCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! HomeCell

        cell.titleLabel?.text = allRounds[indexPath.row].label_long
        
        let sched1 = cal.date(from: allRounds[indexPath.row].schedStart)
        let sched2 = DateFormatter.localizedString(from: sched1!, dateStyle: .none, timeStyle: .short)
        
        cell.sched?.text = "Scheduled \(sched2)"
        
        // Set corner properties of row labels
        cell.row1.layer.cornerRadius = 10.0
        cell.row3.layer.cornerRadius = 10.0
        cell.row2.layer.cornerRadius = 10.0
        
        cell.row1.clipsToBounds = true
        cell.row2.clipsToBounds = true
        cell.row3.clipsToBounds = true
        
        // If the round has not started, and the tournament net delay is 0, row1 = est, row2 = cic, row3 = "No Delay"
        // If the round has not started, row1 = est, row2 = cic, row3 = schedule-neutral start time (ie. start time if no more time is to be lost)
        
        // For now SNS calculator doesn't exist, so we just go with option 2 and row 3 just saying "SNS"
        
        let est1 = cal.date(from: allRounds[indexPath.row].estStart)
        let est2 = DateFormatter.localizedString(from: est1!, dateStyle: .none, timeStyle: .short)
        
        let cic1 = cal.date(from: allRounds[indexPath.row].checkincloses)
        let cic2 = DateFormatter.localizedString(from: cic1!, dateStyle: .none, timeStyle: .short)
        
        let sns1 = cal.date(from: allRounds[indexPath.row].snsStart)
        let sns2 = DateFormatter.localizedString(from: sns1!, dateStyle: .none, timeStyle: .short)
        
        
        
        cell.row1?.text = "Estimated \(est2)"
        cell.row2?.text = "CIC \(cic2)"
        cell.row3?.text = "SNS \(sns2)"
        
        cell.row1.backgroundColor = UIColor.yellow
        cell.row2.backgroundColor = UIColor.cyan
        cell.row3.backgroundColor = UIColor.lightGray
        
        cell.row3.textColor = UIColor.white
        
        for row in [cell.row1, cell.row2, cell.row3] {
            row?.layer.cornerRadius = 10.0
            row?.clipsToBounds = true
        }
        
        
        
        
        
        
        
        
       
        
        
        return cell
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        viewController.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //1: Try loading the detailVC
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EditTimes") as? EditTimesVC {
            // Pass variables
            vc.currentStart = allRounds[indexPath.row].estStart
            vc.round = allRounds[indexPath.row].label_long
            vc.index = indexPath.row
            
            //3: Push controller
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    
    
    @objc func registerLocal() {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay")
            } else {
                print("No")
            }
        }
        
    }
    
    
    
    @objc func scheduleLocal() {
        
    
        
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Test Title"
        content.body = "Test Body"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData":"fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 14
        dateComponents.minute = 40
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
        center.getPendingNotificationRequests { (requests) in
            print("here are the iOS 10 notifs \(requests)")
        }
    }
    
    

    

}

