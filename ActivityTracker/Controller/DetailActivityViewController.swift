//
//  DetailActivityViewController.swift
//  ActivityTracker
//
//  Created by macintosh on 12/20/18.
//  Copyright © 2018 macintosh. All rights reserved.
//

import UIKit

class DetailActivityViewController: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    var titleName: String?
    var imageLogo:NSData?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imgLogo.layer.cornerRadius = imgLogo.frame.width / 2
        imgLogo.clipsToBounds = true
        lblTitle.text = titleName
        imgLogo.image = UIImage(data: imageLogo! as Data)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
}
