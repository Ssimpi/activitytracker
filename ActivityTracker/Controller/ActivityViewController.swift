//
//  ActivityViewController.swift
//  ActivityTracker
//
//  Created by macintosh on 12/20/18.
//  Copyright © 2018 macintosh. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var btnAdd:UIButton!
    @IBOutlet weak var lblZeroState: UILabel!
    var activityArray:[Activities] = []{
        didSet{
            tableView.reloadData()
        }
    }
    var imageURL:String!
    var currentRunningActivity: Activities?
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        lblZeroState.isHidden = false
       // tableView.estimatedRowHeight = 190
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let runningActivities = CoreDataManager.sharedInstance.getRunningActivity()
        if runningActivities.count == 0 {
            currentRunningActivity = nil
        } else {
            currentRunningActivity = runningActivities[0]
        }
        activityArray = CoreDataManager.sharedInstance.fetchActivities()
        tableView.reloadData()
    }
    //Show add activity view
    fileprivate func showAddActivity() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let balanceViewController = storyBoard.instantiateViewController(withIdentifier: "AddActivity") as! AddActivityViewController
        self.present(balanceViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnAddClicked(_ sender: Any){
        showAddActivity()
    }
    @objc func timerAction() {
        if let idTemp = currentRunningActivity?.id {
            CoreDataManager.sharedInstance.updateTimerCurrentRunningActivity(id: idTemp)
            activityArray = CoreDataManager.sharedInstance.fetchActivities()
            tableView.reloadData()
        }
        
    }
}
extension ActivityViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        lblZeroState.isHidden = true
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ActivityTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.btnCheckList.tag = indexPath.row
        cell.btnPlayOrPause.tag = indexPath.row
        cell.cellView.layer.cornerRadius = 10
        cell.lblTitle?.text = activityArray[indexPath.row].title
        cell.lblDescription.text = activityArray[indexPath.row].description
        cell.lblDueDate.text = activityArray[indexPath.row].date
        //       if let returnValue = UserDefaults.standard.object(forKey: "selectedCheckListCount"){
//        cell.lblCheckListCount.text = returnValue! as? String
//    }

        let (h,m,s) = activityArray[indexPath.row].totalTime.secondsToHoursMinutesSeconds()
        cell.lblTime.text = "\(h):\(m):\(s)"
        
        cell.imgLogo.layer.cornerRadius = cell.imgLogo.frame.width / 2
        if let imageData:NSData = activityArray[indexPath.row].url {
            cell.imgLogo.image = UIImage(data: imageData as Data)
        }
        if let currentRunAct = currentRunningActivity {
            if currentRunAct.id == activityArray[indexPath.row].id {
                cell.btnPlayOrPause.isEnabled = true
                cell.btnPlayOrPause.isSelected = true
                let runningActivities = CoreDataManager.sharedInstance.getRunningActivity()
                if runningActivities.count == 0 {
                    currentRunningActivity = nil
                } else {
                    currentRunningActivity = runningActivities[0]
                }
                timer.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
                
            } else {
                cell.btnPlayOrPause.isEnabled = false
            }
        } else {
            cell.btnPlayOrPause.isEnabled = true
        }
        cell.btnPlayOrPause.addTarget(self, action: #selector(changeSelect(_:)), for: .touchUpInside)
        
        return cell
    }
 
    @IBAction func changeSelect(_ sender: UIButton){
        timer.invalidate()
        if sender.isSelected == true{
            sender.isSelected = false
            if  sender.tag < activityArray.count{
                CoreDataManager.sharedInstance.updateActivityRunningStatus(id: activityArray[sender.tag].id)
                let runningActivities = CoreDataManager.sharedInstance.getRunningActivity()
                if runningActivities.count == 0 {
                    currentRunningActivity = nil
                } else {
                    currentRunningActivity = runningActivities[0]
                }
                
                activityArray = CoreDataManager.sharedInstance.fetchActivities()
                tableView.reloadData()
            }
            
        }
        else{
            sender.isSelected = true
            if  sender.tag < activityArray.count{
                CoreDataManager.sharedInstance.updateActivityRunningStatus(id: activityArray[sender.tag].id)
                let runningActivities = CoreDataManager.sharedInstance.getRunningActivity()
                if runningActivities.count == 0 {
                    currentRunningActivity = nil
                } else {
                    currentRunningActivity = runningActivities[0]
                }
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            }
            
        }
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Edit") { (action , indexPath ) -> Void in
            self.isEditing = false
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "DetailActivityView") as! DetailActivityViewController
            vc.titleName = self.activityArray[indexPath.row].title
            vc.imageLogo = self.activityArray[indexPath.row].url
            self.present(vc, animated: true, completion: nil)
        }
        editAction.backgroundColor = UIColor(red: 62/255, green: 233/255, blue: 173/255, alpha: 1)
        return [editAction]
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 185
//    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ActivityViewController: ActivityTableViewCellDelegate {
    
    func activityOptionsSelected(cell:ActivityTableViewCell, selectedOption:Int) {
        guard let indexpath = tableView.indexPath(for: cell) else {
            return
        }
        switch selectedOption {
        case 1:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "CheckListView") as! CheckListViewController
            vc.checkListTitle = activityArray[indexpath.row].title
                self.present(vc, animated: true, completion: nil)
        case 2:
            print("play")
        
        default:
            print("nothing")
        }
        tableView.reloadRows(at: [indexpath], with: .automatic)
}
    
}
extension Int64 {
    func secondsToHoursMinutesSeconds () -> (Int, Int, Int) {
        let seconds:Int = Int(self)
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
