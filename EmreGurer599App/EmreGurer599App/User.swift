//
//  User.swift
//  EmreGurer599App
//
//  Created by Emre Gurer on 20.12.2015.
//  Copyright © 2015 Emre Gurer. All rights reserved.
//

import Foundation
import AddressBook
import CoreData
import UIKit

public class User{
    
    public var UserId:Int = 0
    
    public var Name:String = ""
    
    public var Surname:String = ""
    
    public var Email:String = ""
    
    public var Password:String = ""
    
    public var Phone:String = ""
    
    public var UDID:String = ""
    
    public var History:[HistoryItem] = []
    
    public var Contacts:[Contact] = []
    
    public func Update() -> Bool {
        return true
    }
    
    public func GetUserInfo() {
        let soapEnvelope = "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\"><s:Body><GetUserInfo xmlns=\"http://tempuri.org/\"><UserId>\(UserId)</UserId></GetUserInfo></s:Body></s:Envelope>";
        
        let soapEnvelopeLength = String(soapEnvelope.characters.count)
        
        let clientTokenURL = NSURL(string: "http://safesend.emregurer.com/UserService.svc/basic")
        let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL!)
        let session = NSURLSession.sharedSession()
        
        clientTokenRequest.HTTPMethod = "POST"
        clientTokenRequest.HTTPBody = soapEnvelope.dataUsingEncoding(NSUTF8StringEncoding)
        
        clientTokenRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        clientTokenRequest.addValue(soapEnvelopeLength, forHTTPHeaderField: "Content-Length")
        clientTokenRequest.addValue("http://tempuri.org/IUserService/GetUserInfo", forHTTPHeaderField: "soapAction")
        
        let task = session.dataTaskWithRequest(clientTokenRequest, completionHandler: {data, response, error -> Void in
            
            let clientToken = String(data: data!, encoding: NSUTF8StringEncoding)
            let xml = SWXMLHash.parse(clientToken!)
            self.Email = xml["s:Envelope"]["s:Body"]["GetUserInfoResponse"]["GetUserInfoResult"]["a:Email"].element?.text! as String!
            self.Password = xml["s:Envelope"]["s:Body"]["GetUserInfoResponse"]["GetUserInfoResult"]["a:Password"].element?.text! as String!
            self.Name = xml["s:Envelope"]["s:Body"]["GetUserInfoResponse"]["GetUserInfoResult"]["a:Name"].element?.text! as String!
            self.Surname = xml["s:Envelope"]["s:Body"]["GetUserInfoResponse"]["GetUserInfoResult"]["a:Surname"].element?.text! as String!
            self.Phone = xml["s:Envelope"]["s:Body"]["GetUserInfoResponse"]["GetUserInfoResult"]["a:Phone"].element?.text! as String!
            self.UDID = xml["s:Envelope"]["s:Body"]["GetUserInfoResponse"]["GetUserInfoResult"]["a:UDID"].element?.text! as String!
        })
        task.resume()
    }
    
    public func GetHistory() {
        let soapEnvelope = "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\"><s:Body><GetHistory xmlns=\"http://tempuri.org/\"><UserId>\(UserId)</UserId></GetHistory></s:Body></s:Envelope>";
        
        let soapEnvelopeLength = String(soapEnvelope.characters.count)
        
        let clientTokenURL = NSURL(string: "http://safesend.emregurer.com/UserService.svc/basic")
        let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL!)
        let session = NSURLSession.sharedSession()
        
        clientTokenRequest.HTTPMethod = "POST"
        clientTokenRequest.HTTPBody = soapEnvelope.dataUsingEncoding(NSUTF8StringEncoding)
        
        clientTokenRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        clientTokenRequest.addValue(soapEnvelopeLength, forHTTPHeaderField: "Content-Length")
        clientTokenRequest.addValue("http://tempuri.org/IUserService/GetHistory", forHTTPHeaderField: "soapAction")
        
        let task = session.dataTaskWithRequest(clientTokenRequest, completionHandler: {data, response, error -> Void in
            
            let clientToken = String(data: data!, encoding: NSUTF8StringEncoding)
            let xml = SWXMLHash.parse(clientToken!)
            var count = xml["s:Envelope"]["s:Body"]["GetHistoryResponse"]["GetHistoryResult"].element?.count
            var i:Int
            self.History.removeAll()
            
            for i=0; i<count;i++ {
                var item = HistoryItem()
                item.ReceiverName = xml["s:Envelope"]["s:Body"]["GetHistoryResponse"]["GetHistoryResult"]["a:HistoryItem"][i]["a:ReceiverName"].element?.text as String!
                item.SenderName = xml["s:Envelope"]["s:Body"]["GetHistoryResponse"]["GetHistoryResult"]["a:HistoryItem"][i]["a:SenderName"].element?.text as String!
                item.Status = Int((xml["s:Envelope"]["s:Body"]["GetHistoryResponse"]["GetHistoryResult"]["a:HistoryItem"][i]["a:Status"].element?.text)!)!
                item.TransferDirection = Int((xml["s:Envelope"]["s:Body"]["GetHistoryResponse"]["GetHistoryResult"]["a:HistoryItem"][i]["a:TransferDirection"].element?.text)!)!
                item.TransferId = Int((xml["s:Envelope"]["s:Body"]["GetHistoryResponse"]["GetHistoryResult"]["a:HistoryItem"][i]["a:TransferId"].element?.text)!)!
                self.History.append(item)
            }
        })
        task.resume()
    }
    
    public func RefreshContactList() {
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        switch authorizationStatus {
        case .Denied, .Restricted:
            print("Denied")
        case .Authorized:
            CreateAddressbook()
        case .NotDetermined:
            ABAddressBookRequestAccessWithCompletion(nil) {
                (granted:Bool, err:CFError!) in
                dispatch_async(dispatch_get_main_queue()) {
                    if granted {
                        self.CreateAddressbook()
                    }
                }
            }
        }
    }
    
    func CreateAddressbook() {
        var tmpContactList = [Contact]()
        var phoneStr = ""
        let addressBookRef: ABAddressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        let people = ABAddressBookCopyArrayOfAllPeople(addressBookRef).takeRetainedValue() as NSArray as [ABRecord]
        for person in people {
            var firstName = ""
            if ABRecordCopyValue(person, kABPersonFirstNameProperty) != nil {
                firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty).takeRetainedValue() as! String
            }
            
            var lastName = ""
            if ABRecordCopyValue(person, kABPersonLastNameProperty) != nil {
                lastName = ABRecordCopyValue(person, kABPersonLastNameProperty).takeRetainedValue() as! String
            }
            
            let phones:ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
            for(var i = 0; i < ABMultiValueGetCount(phones); i++) {
                var phone: String = ABMultiValueCopyValueAtIndex(phones, i).takeRetainedValue() as! String
                let s = String(UnicodeScalar(160))
                phone = phone.stringByReplacingOccurrencesOfString("(", withString: "")
                phone = phone.stringByReplacingOccurrencesOfString(")", withString: "")
                phone = phone.stringByReplacingOccurrencesOfString(" ", withString: "")
                phone = phone.stringByReplacingOccurrencesOfString("+", withString: "")
                phone = phone.stringByReplacingOccurrencesOfString(s, withString: "")
                phoneStr = phoneStr + ";" + phone
                
                let tmpContact: Contact = Contact()
                tmpContact.Phone = phone
                tmpContact.Name = firstName
                tmpContact.Surname = lastName
                tmpContactList.append(tmpContact)
            }
        }
        
        phoneStr = phoneStr.stringByReplacingOccurrencesOfString("(", withString: "")
        phoneStr = phoneStr.stringByReplacingOccurrencesOfString(")", withString: "")
        phoneStr = phoneStr.stringByReplacingOccurrencesOfString(" ", withString: "")
        phoneStr = phoneStr.stringByReplacingOccurrencesOfString("+", withString: "")
        
        let soapEnvelope = "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\"><s:Body><GetContacts xmlns=\"http://tempuri.org/\"><UserId>\(UserId)</UserId><PhoneList>\(phoneStr)</PhoneList></GetContacts></s:Body></s:Envelope>"
        
        let soapEnvelopeLength = String(soapEnvelope.characters.count)
        
        let clientTokenURL = NSURL(string: "http://safesend.emregurer.com/UserService.svc/basic")
        let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL!)
        let session = NSURLSession.sharedSession()
        
        clientTokenRequest.HTTPMethod = "POST"
        clientTokenRequest.HTTPBody = soapEnvelope.dataUsingEncoding(NSUTF8StringEncoding)
        
        clientTokenRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        clientTokenRequest.addValue(soapEnvelopeLength, forHTTPHeaderField: "Content-Length")
        clientTokenRequest.addValue("http://tempuri.org/IUserService/GetContacts", forHTTPHeaderField: "soapAction")
        
        let task = session.dataTaskWithRequest(clientTokenRequest, completionHandler: {data, response, error -> Void in
            
            let clientToken = String(data: data!, encoding: NSUTF8StringEncoding)
            let xml = SWXMLHash.parse(clientToken!)
            
            let responseStr = xml["s:Envelope"]["s:Body"]["GetContactsResponse"]["GetContactsResult"].element?.text as String!
            let contactArray = responseStr.componentsSeparatedByString(";")
            
            var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            var context: NSManagedObjectContext = appDel.managedObjectContext
            
            let fetchRequest = NSFetchRequest(entityName: "Contacts")
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.executeFetchRequest(fetchRequest)
                for result in results {
                    let data:NSManagedObject = result as! NSManagedObject
                    context.deleteObject(data)
                }
            } catch {
                
            }
            
            self.Contacts.removeAll()
            
            for var i = 0; i < tmpContactList.count; i++ {
                if contactArray.contains(tmpContactList[i].Phone) {
                    self.Contacts.append(tmpContactList[i])
                }
            }
            
            for var i = 0; i < self.Contacts.count; i++ {
                var newContact = NSEntityDescription.insertNewObjectForEntityForName("Contacts", inManagedObjectContext: context) as! NSManagedObject
                
                newContact.setValue(self.Contacts[i].Name, forKey: "name")
                newContact.setValue(self.Contacts[i].Surname, forKey: "surname")
                newContact.setValue(self.Contacts[i].Phone, forKey: "phone")
                
                do{
                    try context.save()
                } catch {
                    
                }
            }
        })
        task.resume()
    }
}
