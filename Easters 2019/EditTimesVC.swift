//
//  EditTimesVC.swift
//  Easters 2019
//
//  Created by Viran Weerasekera on 31/12/18.
//  Copyright © 2018 Viran Weerasekera. All rights reserved.
//

import UIKit

class EditTimesVC: UITableViewController {
    
    var index:Int!
    var round:String!
    var currentStart:DateComponents!
    var newStart:DateComponents!
    var diff : TimeInterval = 0
    
    @IBOutlet weak var sched: UILabel!
    @IBOutlet weak var offsetcheckin: UISwitch!
    @IBOutlet weak var dp: UIDatePicker!
    @IBOutlet weak var current: UILabel!
    @IBOutlet weak var new: UILabel!
    @IBOutlet weak var delay: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let currentStart2 = cal.date(from: currentStart)
        
        current.text = DateFormatter.localizedString(from: currentStart2!, dateStyle: .none, timeStyle: .short)
        new.text = DateFormatter.localizedString(from: currentStart2!, dateStyle: .none, timeStyle: .short)
        
        dp.date = currentStart2!
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Edit \(round!)"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNewTime))
        
        diff = allRounds[index].estDelay
        delay.text = "\(String(Int(diff/60))) minutes"
        
        let schedStart2 = cal.date(from: allRounds[index].schedStart)
        sched.text = DateFormatter.localizedString(from: schedStart2!, dateStyle: .none, timeStyle: .short)
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBAction func dpShowDateAction(_ sender: Any) {
        new.text = DateFormatter.localizedString(from: dp.date, dateStyle: .none, timeStyle: .short)
        
        diff = dp.date.timeIntervalSince(cal.date(from: allRounds[index].schedStart)!)
        delay.text = "\(String(Int(diff/60))) minutes"
        
        
    }
    
    @objc func saveNewTime() {
        
        // Update the round variable estStart
        allRounds[index].estStart = cal.dateComponents([.hour, .minute, .second], from: dp.date)
        
        // Offset check-in if required
        if offsetcheckin.isOn {
            let cic2 = cal.date(from: allRounds[index].checkincloses)
            let newcic = cic2?.addingTimeInterval(diff)
            allRounds[index].checkincloses = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newcic!)
        }
        
        // Update the estDelay
        allRounds[index].estDelay = diff
    
        // Save array
        writeRounds()
        
        // Load up the navController
        navigationController?.popToRootViewController(animated: true)
        
        
    }
}
