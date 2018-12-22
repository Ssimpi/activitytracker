//
//  CheckListViewController.swift
//  ActivityTracker
//
//  Created by macintosh on 12/20/18.
//  Copyright © 2018 macintosh. All rights reserved.
//

import UIKit

class CheckListViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddCheckList: UIButton!
    @IBOutlet weak var txtCheckList: UITextView!
    @IBOutlet weak var checkListView: UIView!
    @IBOutlet weak var lblZeroState: UILabel!
    @IBOutlet weak var btnCancelCheckList: UIButton!
    var selectedCount:Int!
    var checkListTitle:String!
    var checkListArray : [CheckListModel] = []{
        didSet{
            tableView.reloadData()
        }
    }
    var isComingFromAddActivity:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "CheckListHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "checkListHeader")
        tableView.register(UINib(nibName: "CheckListFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "footerCell")
        lblZeroState.isHidden = false
        checkListView.isHidden = true
        btnAddCheckList.layer.cornerRadius = 6
        btnCancelCheckList.layer.cornerRadius = 6
        textViewPlaceholder()
        shadowEffectToCheckListView()
        selectedCount = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if isComingFromAddActivity == true{
            print("from add")
        }else{
            checkListArray = CoreDataManager.sharedInstance.fetchCheckList()
        }
        tableView.reloadData()
    }
    
    @IBAction func btnAddCheckListClicked(_ sender: Any) {
        
        if self.txtCheckList.text == "Type here" {
            
            self.txtCheckList.text = ""
            alert(withTitle: "", andMessage: "Enter task")
            return
        }
        CoreDataManager.sharedInstance.saveCheckList(task: txtCheckList.text!)
        checkListView.isHidden = true
        tableView.isHidden = false
        viewWillAppear(true)
        txtCheckList.resignFirstResponder()
        textViewPlaceholder()
        tableView.reloadData()
    }
    @IBAction func btnCancelCheckListClicked(_ sender: Any) {
        checkListView.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        
        // self.dismiss(animated: true, completion: nil)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ActivityViewController") as! ActivityViewController
        self.present(vc, animated: true, completion: nil)
        
    }
    
    //MARK: Setting placeholder for textview
    fileprivate func textViewPlaceholder() {
        
        txtCheckList.text = "Type here"
        txtCheckList.textColor = UIColor.lightGray
        txtCheckList.font = UIFont(name: "verdana", size: 13.0)
        txtCheckList.returnKeyType = .done
        txtCheckList.delegate = self
    }
    
    //Shadow effect to view
    fileprivate func shadowEffectToCheckListView() {
        
        checkListView.layer.shadowColor = UIColor.lightGray.cgColor
        checkListView.layer.shadowOpacity = 1
        checkListView.layer.shadowOffset = CGSize.zero
        checkListView.layer.shadowRadius = 5
        self.view.addSubview(checkListView)
    }
    
    //Show alert
    func alert(withTitle title: String,
               andMessage message: String,
               andActions actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)]) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        present(alert, animated: false, completion: nil)
    }
    
    //MARK:- UITextViewDelegates
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "Type here" {
            
            textView.text = ""
            textView.textColor = UIColor.black
            textView.font = UIFont(name: "verdana", size: 18.0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            
            textView.text = "Type here"
            textView.textColor = UIColor.lightGray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
}
extension CheckListViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return checkListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! checkListTableViewCell
        cell.btnCheck.tag = indexPath.row
        cell.lblTitle.text = "  \(indexPath.row + 1). \(checkListArray[indexPath.row].task)"
        cell.btnCheck.addTarget(self, action: #selector(connected), for: .touchUpInside)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.lblTitle.text!)
        
        if cell.btnCheck.isSelected == true{
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            selectedCount += 1
        }
        else{
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
        }
        cell.lblTitle.attributedText = attributeString
        selectedCount -= 1
        
        return cell
    }
    @IBAction func connected(_ sender: UIButton){
        
        if sender.isSelected == true{
            sender.isSelected = false
            
        }
        else{
            sender.isSelected = true
        }
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkListHeader") as! CheckListHeaderTableViewCell
        // cell.lblCheckListCount.text = "\(selectedCount!)/\(checkListArray.count)"
        UserDefaults.standard.set(selectedCount, forKey: "selectedCheckListCount")
        
        //  cell.lblCheckListName.text = checkListTitle
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 86.0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "footerCell") as! CheckListFooterTableViewCell
        cell.btnAddItem.addTarget(self, action: #selector(btnAddClicked), for: .touchUpInside)
        
        return cell.contentView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 81.0
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func btnAddClicked()
    {
        checkListView.isHidden = false
        tableView.isHidden = true
    }
}
