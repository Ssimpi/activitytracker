//
//  CheckListHeaderTableViewCell.swift
//  ActivityTracker
//
//  Created by macintosh on 12/22/18.
//  Copyright © 2018 macintosh. All rights reserved.
//

import UIKit

class CheckListHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCheckListCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
