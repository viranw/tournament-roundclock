//
//  ViewController.swift
//  Easters 2019
//
//  Created by Viran Weerasekera on 17/12/18.
//  Copyright © 2018 Viran Weerasekera. All rights reserved.
//

import UIKit
import UserNotifications

class HomeVC: UITableViewController, UIViewControllerPreviewingDelegate {
    
    var hour:Int = 14
    var minute:Int = 45
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        registerLocal()
        
        registerForPreviewing(with: self, sourceView: tableView)
        
        
        // Basic navigation setup
        navigationController?.navigationBar.prefersLargeTitles = true
        title = tournamentName
        
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Tab", style: .plain, target: self, action: #selector(openTab))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset1))
        
        
        // Data load - Load default data, then overwrite with saved data if it exists
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
        
        // Title Label
        cell.titleLabel?.text = round.label_long
        if round.roundCompleted != nil {
            cell.titleLabel.textColor = UIColor.lightGray
        } else {
            cell.titleLabel.textColor = UIColor.black
        }
        
        // Scheduled Label
        let sched = DateFormatter.localizedString(from: round.schedStart, dateStyle: .none, timeStyle: .short)
        cell.sched?.text = "Scheduled \(sched)"
        if round.isStarted {
            cell.sched.textColor = UIColor.lightGray
        }
        
        //Progress Bar
        updateProgressBar(bar: cell.progressBar, forRoundIndex: indexPath.row)
        
        
        
        
        // Left sched/act delay - Text and formatting
        if round.isStarted {
            let adelay = calculateRawDelay(for: round)
            
            
            if adelay >= 0 {
                cell.delayleft?.text = "Actual +\(String(Int(adelay/60)))m"
            } else {
                cell.delayleft?.text = "Actual \(String(Int(adelay/60)))m"
            }
            cell.delayleft?.textColor = UIColor.purple

        } else {
            let sdelay = calculateRawDelay(for: round)
            if sdelay >= 0 {
                cell.delayleft?.text =  "Estimated +\(String(Int(sdelay/60)))m"
            } else {
                cell.delayleft?.text = "Estimated \(String(Int(sdelay/60)))m"
            }
            if sdelay == 0 {
                cell.delayleft?.textColor = UIColor.lightGray
            } else if sdelay < 0 {
                cell.delayleft?.textColor = UIColor.green
            } else if sdelay < 901 {
                cell.delayleft?.textColor = UIColor.orange
            } else {
                cell.delayleft?.textColor = UIColor.red
            }
        }
        
        // Left SNS
        if round.isStarted {
            cell.snsLeft.isHidden = true
        } else {
            cell.snsLeft.isHidden = false
            
            let snsgap = round.estStart.timeIntervalSince(round.snsStart)
            
            if snsgap >= 0 {
                cell.snsLeft.text = "SNS +\(String(Int(snsgap/60)))m"
            } else {
                cell.snsLeft.text = "SNS -\(String(Int(snsgap/60)))m"
            }
            
            if snsgap == 0 {
                cell.snsLeft.textColor = UIColor.lightGray
            } else if snsgap < 0 {
                cell.snsLeft.textColor = UIColor.green
            } else if snsgap < 901 {
                cell.snsLeft.textColor = UIColor.orange
            } else {
                cell.snsLeft.textColor = UIColor.red
            }
        }
        
        
        //Right labels
        
        // Set corner properties
        for row in [cell.row1, cell.row2, cell.row3] {
            row?.layer.cornerRadius = 10.0
            row?.clipsToBounds = true
        }
        
        // If the round is past, display the release time on the grey label and hide the rest
        // If not, populate and format accordingly
        if round.isStarted {
            let act = DateFormatter.localizedString(from: round.actStart!, dateStyle: .none, timeStyle: .short)
            cell.row1.text = "Released \(act)"
            cell.row1.layer.backgroundColor = UIColor.lightGray.cgColor
            cell.row1.textColor = UIColor.white
            
            cell.row2.isHidden = true
            cell.row3.isHidden = true
            
        } else {
            cell.row2.isHidden = false
            cell.row3.isHidden = false
            
            // Determine the label colour of estimated start based on delay
            if calculateRawDelay(for: round) == 0 {
                cell.row1.layer.backgroundColor = UIColor.yellow.cgColor
                cell.row1.textColor = UIColor.black
            } else if calculateRawDelay(for: round) < 0 {
                cell.row1.layer.backgroundColor = UIColor.green.cgColor
                cell.row1.textColor = UIColor.black
            } else if calculateRawDelay(for: round) < 901 {
                cell.row1.layer.backgroundColor = UIColor.yellow.cgColor
                cell.row1.textColor = UIColor.black
            } else {
                cell.row1.layer.backgroundColor = UIColor.red.cgColor
                cell.row1.textColor = UIColor.white
            }
            
           // If est start is past SNS (ie. we're accruing more delay), orange
            if round.snsStart.timeIntervalSince(round.estStart) < 0 {
                cell.row3.layer.backgroundColor = UIColor.orange.cgColor
                cell.row3.textColor = UIColor.black
            // If SNS is past sched. start (ie. we're running behind), purple)
            } else if round.snsStart.timeIntervalSince(round.schedStart) > 0 {
                cell.row3.layer.backgroundColor = UIColor.purple.cgColor
                cell.row3.textColor = UIColor.white
            } else {
            // If it's neither of the above then there's no need for concern, it can just sit
                cell.row3.layer.backgroundColor = UIColor.lightGray.cgColor
                cell.row3.textColor = UIColor.white
            }
            
            // Row 2 can just be always black
            cell.row2.layer.backgroundColor = UIColor.black.cgColor
            cell.row2.textColor = UIColor.white
            
            //TODO
            // Determine the label colour of the SNS based on how on-track the estimated start time suggests we are to meeting it
            
            let est = DateFormatter.localizedString(from: round.estStart, dateStyle: .none, timeStyle: .short)
            let cic = DateFormatter.localizedString(from: round.checkincloses, dateStyle: .none, timeStyle: .short)
            let sns = DateFormatter.localizedString(from: round.snsStart, dateStyle: .none, timeStyle: .short)
            
            cell.row1?.text = "Estimated \(est)"
            cell.row2?.text = "CIC \(cic)"
            cell.row3?.text = "SNS \(sns)"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if allRounds[indexPath.row].isStarted {
            return 120
        } else {
            return 185
        }
    }
    
    func startRound(index: Int) {
        startRoundSuper(index: index)
        timeCall(vc: self, roundIndex: index)
    }

    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let start = UITableViewRowAction(style: .default, title: "Start") {(action, indexPath) in
            if allRounds[indexPath.row].isStarted {
                let ac = UIAlertController(title: "Invalid Start", message: "\(allRounds[indexPath.row].label_long!) is already marked as started.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(ac, animated: true)
            } else {
                self.startRound(index: indexPath.row)
            }
            
            self.tableView.reloadData()
        }
        
        let unstart = UITableViewRowAction(style: .default, title: "Unstart") {(action, indexPath) in
            if !allRounds[indexPath.row].isStarted {
                let ac = UIAlertController(title: "Invalid Unstart", message: "\(allRounds[indexPath.row].label_long!) is not marked as started yet.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(ac, animated: true)
            } else {
                unstartRoundSuper(index: indexPath.row)
            }
            self.tableView.reloadData()
        }
        
        let reschedule = UITableViewRowAction(style: .default, title: "Reschedule") {(action, indexPath) in
            
            if allRounds[indexPath.row].isStarted {
                let ac = UIAlertController(title: "Round Locked", message: "\(allRounds[indexPath.row].label_long!) is marked as started and cannot be rescheduled.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(ac, animated: true)
            } else {
                if let edittimevc = self.storyboard?.instantiateViewController(withIdentifier: "EditTimes") as? EditTimesVC {
                    // Pass variables
                    edittimevc.currentStart = allRounds[indexPath.row].estStart
                    edittimevc.round = allRounds[indexPath.row].label_long
                    edittimevc.index = indexPath.row
                    
                    //3: Push controller
                    self.navigationController?.pushViewController(edittimevc, animated: true)
                }
            }
        }
        
        if allRounds[indexPath.row].roundCompleted != nil {
            reschedule.backgroundColor = UIColor.lightGray
            return [reschedule]
        } else if allRounds[indexPath.row].isStarted {
            unstart.backgroundColor = UIColor.orange
            reschedule.backgroundColor = UIColor.lightGray
            return [unstart, reschedule]
        } else {
            start.backgroundColor = UIColor.green
            unstart.backgroundColor = UIColor.gray
            reschedule.backgroundColor = UIColor.purple
            return [start, reschedule]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = detailViewController(for: indexPath.row)
        navigationController?.pushViewController(vc, animated: true)

    }
    
    // Function to return the deail view controller for a given selection (necessary for peek/pop implementation)
    func detailViewController(for index: Int) -> detailVC {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? detailVC else { fatalError("Couldn't load detail VC") }
        vc.roundIndex = index
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRow(at: location) {
            previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
            return detailViewController(for: indexPath.row)
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    @objc func openTab() {
        guard let url = URL(string: tabSite) else { return }
        UIApplication.shared.open(url)
    }
    
    
    
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay")
            } else {
                print("No")
            }
        }
        
    }
    
    // Reset data
    @objc func reset1() {
        let ac = UIAlertController(title: "Reset", message: "Are you sure you want to reset timings of all rounds to the schedule?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Confirm", style: .default) { (unowned) in
            initialBuild()
            writeRounds()
            self.tableView.reloadData()
        })
        self.present(ac, animated: true)
        self.tableView.reloadData()
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

