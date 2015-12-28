//
//  ContactListViewController.swift
//  EmreGurer599App
//
//  Created by Emre Gurer on 20.12.2015.
//  Copyright © 2015 Emre Gurer. All rights reserved.
//

import UIKit
import CoreData

var contactListArray = [Contact]()
var selectedContact = Contact()

class ContactListViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var contactsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        contactListArray.removeAll()
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Contacts")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                for result: AnyObject in results {
                    let item = Contact()
                    item.Name = (result.valueForKey("name") as? String)!
                    item.Surname = (result.valueForKey("surname") as? String)!
                    item.Phone = (result.valueForKey("phone") as? String)!
                    contactListArray.append(item)
                }
            } else {
                Refresh(true)
            }
        } catch {
            Refresh(true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactListArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = contactListArray[indexPath.row].Name + " " + contactListArray[indexPath.row].Surname
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedContact = contactListArray[indexPath.row]
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let photoListViewController = storyBoard.instantiateViewControllerWithIdentifier("photoListView") as! PhotoListViewController
        presentViewController(photoListViewController, animated:true, completion:nil)
    }
    
    @IBAction func RefreshList(sender: AnyObject) {
        Refresh(false)
    }
    
    func Refresh(FirstTime: Bool) {
        loggedUser.RefreshContactList()
        sleep(2)
        contactListArray = loggedUser.Contacts
        contactsTable.reloadData()
        
    }
    
}