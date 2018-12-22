//
//  ViewController.swift
//  ActivityTracker
//
//  Created by macintosh on 12/20/18.
//  Copyright © 2018 macintosh. All rights reserved.
//

import UIKit
import CoreData
class AddActivityViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnUploadImage: UIButton!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDueDate: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var btnAdd: UIButton!
    let imagePicker = UIImagePickerController()
    let datePicker = UIDatePicker()
    var pickedImageProduct: NSData?
    var timerTime:String?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        uiDesignStuf()
    }

    @IBAction func txtDueDateClicked(_ sender: Any) {
        showDatePicker()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnUploadImageClicked(_ sender: Any) {
        openPhotoLibrary()
    }
    
    @IBAction func btnAddActivityClicked(_ sender: Any) {

        CheckTextFieldsEmpyOrNot()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "CheckListView") as! CheckListViewController
        vc.isComingFromAddActivity = true
        self.present(vc, animated: true, completion: nil)
       // self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Check wether textfields or empty or not
    func CheckTextFieldsEmpyOrNot(){
        
        guard let title = self.txtTitle.text, !title.isEmpty else {
            self.txtTitle.text = ""
            alert(withTitle: "", andMessage: "Enter title")
            return
        }
        if self.txtDescription.text == "Description"{
            alert(withTitle: "", andMessage: "Enter description")
            return
        }
        else{ }
        if imgLogo.image == nil{
            alert(withTitle: "", andMessage: "Upload image")
            return
        }
        else{ }
        guard let date = self.txtDueDate.text, !date.isEmpty else {
            self.txtDueDate.text = ""
            alert(withTitle: "", andMessage: "select due date")
            return
        }

        let id = Int.random(in: 0..<9223372036854775807)
        CoreDataManager.sharedInstance.saveActivities(id: Int64(id), imageUrl: pickedImageProduct!, title: txtTitle.text ?? "" , description: txtDescription.text, date: (txtDueDate?.text)!, timeHH: 00, timeMM: 00, timeSS: 00, totalTime: 0, isRunning: false)    }
    // Shows alert.
    func alert(withTitle title: String,
               andMessage message: String,
               andActions actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)]) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        present(alert, animated: false, completion: nil)
    }
    //MARK: Setting placeholder for textview
    fileprivate func textViewPlaceholder() {
        txtDescription.text = "Description"
        txtDescription.textColor = UIColor.lightGray
        txtDescription.font = UIFont(name: "verdana", size: 13.0)
        txtDescription.returnKeyType = .done
        txtDescription.delegate = self
    }
    
    //MARK: making uidesign
    fileprivate func uiDesignStuf() {
        // Do any additional setup after loading the view, typically from a nib.
        imgLogo.layer.cornerRadius = imgLogo.frame.width / 2
        imgLogo.clipsToBounds = true
        imgLogo.isHidden = true
        textViewPlaceholder()
        txtDescription.delegate = self
        txtDescription.layer.borderWidth = 0.5
        txtDescription.layer.borderColor = UIColor.lightGray.cgColor
        txtDescription.layer.cornerRadius = 6
        btnAdd.layer.cornerRadius = 6
    }
    //MARK: Show photo library
    func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    //MARK: show date picker
    @objc func showDatePicker(){
        datePicker.isHidden = false
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        txtDueDate.inputAccessoryView = toolbar
        txtDueDate.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "EEE"
        let dueDate = "\(formatter1.string(from: datePicker.date)), \(formatter.string(from: datePicker.date))"
        txtDueDate.text = dueDate
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "hh:mm:ss"
        timerTime = formatter3.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    //MARK:- UITextViewDelegates
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description" {
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
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }

}

extension AddActivityViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
 
    // MARK: - UIImagePickerControllerDelegate Methods
    //Final step put this Delegate
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            self.imgLogo.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            self.imgLogo.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        }
      if let img:UIImage = selectedImage {
            let data = img.jpegData(compressionQuality: 0.75)
            pickedImageProduct = (data! as NSData)
        }
        imgLogo.isHidden = false
        btnUploadImage.isHidden = true
        imgLogo.image = selectedImage
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)

    }
}
