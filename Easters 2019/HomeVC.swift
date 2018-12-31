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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset1))
        
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
        
        let round = allRounds[indexPath.row]

        cell.titleLabel?.text = round.label_long
        
        let sdelay = round.estStart.timeIntervalSince(round.schedStart)
        if sdelay > 0 {
            cell.scheddelay?.text =  "Estimated +\(String(Int(sdelay/60)))m"
        } else {
            cell.scheddelay?.text = "Estimated \(String(Int(sdelay/60)))m"
        }
        
        if sdelay == 0 {
           cell.scheddelay?.textColor = UIColor.blue
        } else if sdelay < 0 {
            cell.scheddelay?.textColor = UIColor.green
        } else if sdelay < 901 {
            cell.scheddelay?.textColor = UIColor.orange
        } else {
            cell.scheddelay?.textColor = UIColor.red
        }
        
        if round.status == "past" {
            let adelay = round.actStart!.timeIntervalSince(round.schedStart)
            cell.scheddelay?.textColor = UIColor.lightGray
            
            if adelay > 0 {
                cell.actdelay?.text = "Actual +\(String(Int(adelay/60)))m"
            } else {
                cell.actdelay?.text = "Actual \(String(Int(adelay/60)))m"
            }
            
            if adelay == 0 {
                cell.actdelay?.textColor = UIColor.blue
            } else if adelay < 0 {
                cell.actdelay?.textColor = UIColor.green
            } else if adelay < 901 {
                cell.actdelay?.textColor = UIColor.orange
            } else {
                cell.actdelay?.textColor = UIColor.red
            }
            
        } else {
            cell.actdelay?.text = ""
        }
        
        
        
        
        
        
        
        let sched = DateFormatter.localizedString(from: round.schedStart, dateStyle: .none, timeStyle: .short)
        
        cell.sched?.text = "Scheduled \(sched)"
        
        // Set corner properties of row labels
        cell.row1.layer.cornerRadius = 10.0
        cell.row3.layer.cornerRadius = 10.0
        cell.row2.layer.cornerRadius = 10.0
        
        cell.row1.clipsToBounds = true
        cell.row2.clipsToBounds = true
        cell.row3.clipsToBounds = true
        
        if round.estDelay == 0 {
            cell.row1.layer.backgroundColor = UIColor.yellow.cgColor
            cell.row1.textColor = UIColor.black
        } else if round.estDelay < 0 {
            cell.row1.layer.backgroundColor = UIColor.green.cgColor
            cell.row1.textColor = UIColor.black
        } else if round.estDelay < 901 {
            cell.row1.layer.backgroundColor = UIColor.yellow.cgColor
            cell.row1.textColor = UIColor.black
        } else {
            cell.row1.layer.backgroundColor = UIColor.red.cgColor
            cell.row1.textColor = UIColor.white

        }
        
        // If the round has not started, and the tournament net delay is 0, row1 = est, row2 = cic, row3 = "No Delay"
        // If the round has not started, row1 = est, row2 = cic, row3 = schedule-neutral start time (ie. start time if no more time is to be lost)
        
        // For now SNS calculator doesn't exist, so we just go with option 2 and row 3 just saying "SNS"
        
        let est = DateFormatter.localizedString(from: round.estStart, dateStyle: .none, timeStyle: .short)
        let cic = DateFormatter.localizedString(from: round.checkincloses, dateStyle: .none, timeStyle: .short)
        let sns = DateFormatter.localizedString(from: round.snsStart, dateStyle: .none, timeStyle: .short)
        
        
        
        cell.row1?.text = "Estimated \(est)"
        cell.row2?.text = "CIC \(cic)"
        cell.row3?.text = "SNS \(sns)"
        
    
        
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
        
        // Check if the status is past, disallow editing if so
        if allRounds[indexPath.row].status == "past" {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
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
    
    @objc func reset1() {
        let ac = UIAlertController(title: "Reset", message: "Are you sure you want to reset timings of all rounds to the schedule?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Confirm", style: .default) { (unowned) in
            initialBuild()
            writeRounds()
            self.tableView.reloadData()
        })
        
        self.present(ac, animated: true)
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

