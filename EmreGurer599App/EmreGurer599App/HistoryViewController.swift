//
//  HistoryViewController.swift
//  EmreGurer599App
//
//  Created by Emre Gurer on 20.12.2015.
//  Copyright © 2015 Emre Gurer. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        loggedUser.GetHistory()
        sleep(1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loggedUser.History.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: HistoryVwCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! HistoryVwCell
        
        if loggedUser.History[indexPath.row].TransferDirection == 1 {
            cell.statusImg.image = UIImage(named: "Sent-25")
            cell.infoLbl.text = loggedUser.History[indexPath.row].ReceiverName
            cell.downloadBtn.hidden = true
        } else {
            cell.statusImg.image = UIImage(named: "Low Importance-25")
            cell.infoLbl.text = loggedUser.History[indexPath.row].SenderName
        }
        
        cell.downloadBtn.tag = loggedUser.History[indexPath.row].TransferId
        
        if loggedUser.History[indexPath.row].Status == 1 {
            cell.downloadBtn.enabled = true
        } else {
            cell.downloadBtn.enabled = false
        }
        
        return cell
    }
    
    @IBAction func Signout(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "userId")
        loggedUser = User()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let loginViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
        self.presentViewController(loginViewController, animated:true, completion:nil)
    }
    
    public static func TransferFile(transferId:Int) {
        FileTransfer.DownloadFile(transferId)
    }
    
}
