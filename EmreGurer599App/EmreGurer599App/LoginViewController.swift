//
//  LoginViewController.swift
//  EmreGurer599App
//
//  Created by Emre Gurer on 20.12.2015.
//  Copyright © 2015 Emre Gurer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emailTxt.delegate = self
        passwordTxt.delegate = self
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
        emailTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    
    @IBAction func Login(sender: AnyObject) {
        let soapEnvelope = ""
            + "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\"><s:Body><Signin xmlns=\"http://tempuri.org/\"><Email>\(emailTxt.text!)</Email><Password>\(passwordTxt.text!)</Password></Signin></s:Body></s:Envelope>";
        
        let soapEnvelopeLength = String(soapEnvelope.characters.count)
        
        let clientTokenURL = NSURL(string: "http://safesend.emregurer.com/UserService.svc/basic")
        let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL!)
        let session = NSURLSession.sharedSession()
        
        clientTokenRequest.HTTPMethod = "POST"
        clientTokenRequest.HTTPBody = soapEnvelope.dataUsingEncoding(NSUTF8StringEncoding)
        
        clientTokenRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        clientTokenRequest.addValue(soapEnvelopeLength, forHTTPHeaderField: "Content-Length")
        clientTokenRequest.addValue("http://tempuri.org/IUserService/Signin", forHTTPHeaderField: "soapAction")
        
        let task = session.dataTaskWithRequest(clientTokenRequest, completionHandler: {data, response, error -> Void in
            
            let clientToken = String(data: data!, encoding: NSUTF8StringEncoding)
            
            let xml = SWXMLHash.parse(clientToken!)
            
            let userID = xml["s:Envelope"]["s:Body"]["SigninResponse"]["SigninResult"].element?.text!
            
            if userID != nil && userID != "-1" {
                NSUserDefaults.standardUserDefaults().setObject(userID!, forKey: "userId")
                loggedUser.UserId = Int(userID!)!
                loggedUser.GetUserInfo()
                
                dispatch_async(dispatch_get_main_queue()) {
                    sleep(1)
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let historyViewController = storyBoard.instantiateViewControllerWithIdentifier("HistoryView") as! HistoryViewController
                    self.presentViewController(historyViewController, animated:true, completion:nil)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    let alert = UIAlertController(title: "Login", message: "Invalid username or password", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
        })
        task.resume()
    }
    
    
    @IBAction func ForgotPassword(sender: AnyObject) {
    }
}
