//
//  ActivityTableViewCell.swift
//  ActivityTracker
//
//  Created by macintosh on 12/20/18.
//  Copyright © 2018 macintosh. All rights reserved.
//

import UIKit
protocol ActivityTableViewCellDelegate: class {
    func activityOptionsSelected(cell:ActivityTableViewCell, selectedOption:Int)
}
class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var imgMemberImage: UIImageView!
    @IBOutlet weak var imgMemberTwo: UIImageView!
    @IBOutlet weak var lblMemberCount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnPlayOrPause: UIButton!
    @IBOutlet weak var lblCheckListCount: UILabel!
    @IBOutlet weak var btnCheckList: UIButton!
    @IBOutlet weak var imgCheckList:UIImage!
    var delegate:ActivityTableViewCellDelegate?
    var indexPath:IndexPath!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnCheckListClicked(_ sender: Any) {
        delegate?.activityOptionsSelected(cell: self, selectedOption: 1)
    }
    
}
