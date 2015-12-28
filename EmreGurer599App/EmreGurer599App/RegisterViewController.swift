//
//  RegisterViewController.swift
//  EmreGurer599App
//
//  Created by Emre Gurer on 20.12.2015.
//  Copyright © 2015 Emre Gurer. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var surnameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameTxt.delegate = self
        surnameTxt.delegate = self
        emailTxt.delegate = self
        passwordTxt.delegate = self
        phoneTxt.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        nameTxt.resignFirstResponder()
        surnameTxt.resignFirstResponder()
        emailTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        phoneTxt.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @IBAction func Save(sender: AnyObject) {
        let UDID = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let soapEnvelope = "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\"><s:Body><Register xmlns=\"http://tempuri.org/\"><Name>\(nameTxt.text!)</Name><Surname>\(surnameTxt.text!)</Surname><Email>\(emailTxt.text!)</Email><Password>\(passwordTxt.text!)</Password><Phone>\(phoneTxt.text!)</Phone><UDID>\(UDID)</UDID><DeviceToken>\(DeviceToken)</DeviceToken></Register></s:Body></s:Envelope>";
        
        let soapEnvelopeLength = String(soapEnvelope.characters.count)
        
        let clientTokenURL = NSURL(string: "http://safesend.emregurer.com/UserService.svc/basic")
        let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL!)
        let session = NSURLSession.sharedSession()
        
        clientTokenRequest.HTTPMethod = "POST"
        clientTokenRequest.HTTPBody = soapEnvelope.dataUsingEncoding(NSUTF8StringEncoding)
        
        clientTokenRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        clientTokenRequest.addValue(soapEnvelopeLength, forHTTPHeaderField: "Content-Length")
        clientTokenRequest.addValue("http://tempuri.org/IUserService/Register", forHTTPHeaderField: "soapAction")
        
        let task = session.dataTaskWithRequest(clientTokenRequest, completionHandler: {data, response, error -> Void in
            
            let clientToken = String(data: data!, encoding: NSUTF8StringEncoding)
            
            let xml = SWXMLHash.parse(clientToken!)
            
            let result = xml["s:Envelope"]["s:Body"]["RegisterResponse"]["RegisterResult"].element?.text!
            
            if error != nil {
            }
            
            if result == "true" {
                dispatch_async(dispatch_get_main_queue()) {
                    let alert = UIAlertController(title: "Register", message: "Registration completed successfully!", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        
                        let loginViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
                        self.presentViewController(loginViewController, animated:true, completion:nil)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }else {
                dispatch_async(dispatch_get_main_queue()) {
                    let alert = UIAlertController(title: "Register", message: "Invalid e-mail and phone number.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        })
        task.resume()
        
    }
    
}
