//
//  notifCell.swift
//  Easters 2019
//
//  Created by Viran Weerasekera on 20/12/18.
//  Copyright © 2018 Viran Weerasekera. All rights reserved.
//

import UIKit

class notifCell: UITableViewCell {
    
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        timeLabel.layer.cornerRadius = 10
        timeLabel.layer.backgroundColor = UIColor.blue.cgColor
        timeLabel.textColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
