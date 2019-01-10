//
//  TodayViewController.swift
//  Widget
//
//  Created by Viran Weerasekera on 10/1/19.
//  Copyright © 2019 Viran Weerasekera. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        if let roundLabelToLoad = UserDefaults.init(suiteName: "group.com.viranweerasekera.Easters-2019-Clock.Widget")?.value(forKey: "displayRound.label_long") {
            if roundLabelToLoad as? String != roundLabel.text {
                roundLabel.text = roundLabelToLoad as? String
            } else {
            }
        } else {
            roundLabel.text = "Round Not Selected"
        }
        
        if let roundTimeToLoad = UserDefaults.init(suiteName: "group.com.viranweerasekera.Easters-2019-Clock.Widget")?.value(forKey: "displayRound.sched") {
            if DateFormatter.localizedString(from: (roundTimeToLoad as? Date)!, dateStyle: .none, timeStyle: .short) != timeLabel.text {
                timeLabel.text = DateFormatter.localizedString(from: (roundTimeToLoad as? Date)!, dateStyle: .none, timeStyle: .short)
            } else {
            }
        } else {
            roundLabel.text = ""
        }
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
