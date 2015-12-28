//
//  ViewController.swift
//  EmreGurer599App
//
//  Created by Emre Gurer on 20.12.2015.
//  Copyright © 2015 Emre Gurer. All rights reserved.
//

import UIKit

var loggedUser = User()
var DeviceToken = ""

class ViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().valueForKey("userId") != nil {
            let userId = NSUserDefaults.standardUserDefaults().valueForKey("userId")! as! String
            loggedUser.UserId = Int(userId)!
            loggedUser.GetUserInfo()
            sleep(1)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let historyViewController = storyBoard.instantiateViewControllerWithIdentifier("HistoryView") as! HistoryViewController
            presentViewController(historyViewController, animated:true, completion:nil)
        } else {
            loginBtn.hidden = false
            registerBtn.hidden = false
        }
    }

}

