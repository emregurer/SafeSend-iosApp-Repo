//
//  FileTransfer.swift
//  EmreGurer599App
//
//  Created by Emre Gurer on 20.12.2015.
//  Copyright © 2015 Emre Gurer. All rights reserved.
//

import Foundation
import UIKit

public class FileTransfer {
    
    public static func DownloadFile(transferId:Int) {
        let soapEnvelope = "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\"><s:Body><DownloadFile xmlns=\"http://tempuri.org/\"><TransferId>\(transferId)</TransferId></DownloadFile></s:Body></s:Envelope>"
        let soapEnvelopeLength = String(soapEnvelope.characters.count)
        
        let clientTokenURL = NSURL(string: "http://safesend.emregurer.com/FileService.svc/basic")
        let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL!)
        let session = NSURLSession.sharedSession()

        clientTokenRequest.HTTPMethod = "POST"
        clientTokenRequest.HTTPBody = soapEnvelope.dataUsingEncoding(NSUTF8StringEncoding)
        
        clientTokenRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        clientTokenRequest.addValue(soapEnvelopeLength, forHTTPHeaderField: "Content-Length")
        clientTokenRequest.addValue("http://tempuri.org/IFileService/DownloadFile", forHTTPHeaderField: "soapAction")
        
        let task = session.dataTaskWithRequest(clientTokenRequest, completionHandler: {data, response, error -> Void in
            
            let clientToken = String(data: data!, encoding: NSUTF8StringEncoding)
            
            let xml = SWXMLHash.parse(clientToken!)
            
            let encryptedFileString = xml["s:Envelope"]["s:Body"]["DownloadFileResponse"]["DownloadFileResult"]["a:FileContent"].element?.text!
            let encryptionLevel = xml["s:Envelope"]["s:Body"]["DownloadFileResponse"]["DownloadFileResult"]["a:EncryptionLevel"].element?.text!
            let transferResponseId = xml["s:Envelope"]["s:Body"]["DownloadFileResponse"]["DownloadFileResult"]["a:TransferId"].element?.text!
            
            let decryptedFileString = Encryption.DecryptText(Int(encryptionLevel!)!, text: encryptedFileString!)
            let fileData:NSData = NSData(base64EncodedString: decryptedFileString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!

            let image = UIImage(data: fileData, scale: 1.0) //image nil oluyor.
            UIImageWriteToSavedPhotosAlbum(image!, self, nil, nil)
            
            UpdateFileStatus(transferResponseId!)
            
        })
        task.resume()
    }
    
    public static func SendFile(phone:String, imageData:NSData, encryptionLevel:Int) {
        let fileString = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        let encryptedFileContent = Encryption.EncryptText(encryptionLevel, text: fileString)
        let soapEnvelope = "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\"><s:Body><TransferFile xmlns=\"http://tempuri.org/\"><SenderId>\(loggedUser.UserId)</SenderId><Phone>\(selectedContact.Phone)</Phone><Data>\(encryptedFileContent)</Data><Level>\(encryptionLevel)</Level></TransferFile></s:Body></s:Envelope>"

        let soapEnvelopeLength = String(soapEnvelope.characters.count)
        
        let clientTokenURL = NSURL(string: "http://safesend.emregurer.com/FileService.svc/basic")
        let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL!)
        let session = NSURLSession.sharedSession()
        
        clientTokenRequest.HTTPMethod = "POST"
        clientTokenRequest.HTTPBody = soapEnvelope.dataUsingEncoding(NSUTF8StringEncoding)
        
        clientTokenRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        clientTokenRequest.addValue(soapEnvelopeLength, forHTTPHeaderField: "Content-Length")
        clientTokenRequest.addValue("http://tempuri.org/IFileService/TransferFile", forHTTPHeaderField: "soapAction")
        
        let task = session.dataTaskWithRequest(clientTokenRequest, completionHandler: {data, response, error -> Void in
            
            let clientToken = String(data: data!, encoding: NSUTF8StringEncoding)
            
            let xml = SWXMLHash.parse(clientToken!)
            
            let result = xml["s:Envelope"]["s:Body"]["TransferFileResponse"]["TransferFileResult"].element?.text!
            
        })
        task.resume()
    }
    
    public static func UpdateFileStatus(transferId: String) {
        let soapEnvelope = "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\"><s:Body><UpdateTransferStatus xmlns=\"http://tempuri.org/\"><TransferId>\(transferId)</TransferId></UpdateTransferStatus></s:Body></s:Envelope>"
        
        let soapEnvelopeLength = String(soapEnvelope.characters.count)
        
        let clientTokenURL = NSURL(string: "http://safesend.emregurer.com/FileService.svc/basic")
        let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL!)
        let session = NSURLSession.sharedSession()
        
        clientTokenRequest.HTTPMethod = "POST"
        clientTokenRequest.HTTPBody = soapEnvelope.dataUsingEncoding(NSUTF8StringEncoding)
        
        clientTokenRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        clientTokenRequest.addValue(soapEnvelopeLength, forHTTPHeaderField: "Content-Length")
        clientTokenRequest.addValue("http://tempuri.org/IFileService/UpdateTransferStatus", forHTTPHeaderField: "soapAction")
        
        let task = session.dataTaskWithRequest(clientTokenRequest, completionHandler: {data, response, error -> Void in
            
            let clientToken = String(data: data!, encoding: NSUTF8StringEncoding)
            
        })
        task.resume()
    }
}
