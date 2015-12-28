//
//  PhotoListViewController.swift
//  EmreGurer599App
//
//  Created by Emre Gurer on 20.12.2015.
//  Copyright © 2015 Emre Gurer. All rights reserved.
//

import UIKit
import Foundation

class PhotoListViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let picker = UIImagePickerController()
    var encryptionPicker: UIPickerView!
    var selectFlag = true
    var encryptionModeValues = ["--Encryption Mode--", "Moderate","Secure","Highly Secure"]
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var encryptionTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        encryptionPicker = UIPickerView()
        encryptionPicker.dataSource = self
        encryptionPicker.delegate = self
        encryptionTxt.inputView = encryptionPicker
        encryptionTxt.text = encryptionModeValues[0]
        
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
    }
    
    override func viewDidAppear(animated: Bool) {
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        
        if selectFlag {
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        selectFlag = false
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        myImageView.contentMode = .ScaleAspectFit
        myImageView.image = chosenImage //4
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        selectFlag = false
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return encryptionModeValues.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return encryptionModeValues[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        encryptionTxt.text = encryptionModeValues[row]
        self.view.endEditing(true)
    }
    
    @IBAction func SelectPhoto(sender: AnyObject) {
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func SendPhoto(sender: AnyObject) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        if encryptionTxt.text == encryptionModeValues[0] {
            let alert = UIAlertController(title: "Warning", message: "Please select an encryption mode", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        } else {
            
            var level:Int = 0
            if encryptionTxt.text == encryptionModeValues[1] {
                level = 1
            } else if encryptionTxt.text == encryptionModeValues[2] {
                level = 2
            } else if encryptionTxt.text == encryptionModeValues[3] {
                level = 3
            }
            
            let imageData = UIImageJPEGRepresentation(myImageView.image!,0.25)
            FileTransfer.SendFile(selectedContact.Phone, imageData: imageData!, encryptionLevel: level)
            
            dispatch_async(dispatch_get_main_queue()) {
                sleep(1)
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let historyViewController = storyBoard.instantiateViewControllerWithIdentifier("HistoryView") as! HistoryViewController
                self.presentViewController(historyViewController, animated:true, completion:nil)
            }
        }
        PKHUD.sharedHUD.hide(animated: false)
    }
    
}
