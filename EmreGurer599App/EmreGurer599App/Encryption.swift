//
//  Encryption.swift
//  EmreGurer599App
//
//  Created by Emre Gurer on 20.12.2015.
//  Copyright © 2015 Emre Gurer. All rights reserved.
//

import Foundation
import CryptoSwift

public class Encryption {
    
    public static func EncryptText(level:Int, text:String) -> String {
        switch level {
        case 1:
            return EncryptModerate(text)
        case 2:
            return EncryptSecure(text)
        case 3:
            return EncryptHighlySecure(text)
        default:
            return ""
        }
    }
    
    public static func DecryptText(level:Int, text:String) -> String {
        switch level {
        case 1:
            return DecryptModerate(text)
        case 2:
            return DecryptSecure(text)
        case 3:
            return DecryptHighlySecure(text)
        default:
            return ""
        }
    }
    
    private static func EncryptModerate(text:String) -> String {
        let key = "1234567890123456"
        let iv = "1234567890123456"
        
        var byteArray: [UInt8] = [UInt8](text.utf8)
        
        var emptyCount =  AES.blockSize - (byteArray.count % AES.blockSize)
        
        for var i = 0; i < emptyCount; i++ {
            byteArray.append(UInt8(0))
        }
        
        let aes = try! AES(key: key, iv: iv, blockMode: .CBC)
        let encrypted = try! aes.encrypt(byteArray, padding: nil)
        
        let encryptedData = NSData(bytes: encrypted)
        let encryptedBase64String = encryptedData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        return encryptedBase64String
    }
    
    private static func EncryptSecure(text:String) -> String {
        let key = "1234567890123456"
        let iv = "qwertyuasdfghjkl"
        
        var byteArray: [UInt8] = [UInt8](text.utf8)
        
        var emptyCount =  AES.blockSize - (byteArray.count % AES.blockSize)
        
        for var i = 0; i < emptyCount; i++ {
            byteArray.append(UInt8(0))
        }
        
        let aes = try! AES(key: key, iv: iv, blockMode: .CBC)
        let encrypted = try! aes.encrypt(byteArray, padding: nil)
        
        let encryptedData = NSData(bytes: encrypted)
        let encryptedBase64String = encryptedData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        return encryptedBase64String
    }
    
    private static func EncryptHighlySecure(text:String) -> String {
        let key = "12345678901234561234567890123456"
        let iv = "1234567890123456"
        
        var byteArray: [UInt8] = [UInt8](text.utf8)
        
        var emptyCount =  AES.blockSize - (byteArray.count % AES.blockSize)
        
        for var i = 0; i < emptyCount; i++ {
            byteArray.append(UInt8(0))
        }
        
        let aes = try! AES(key: key, iv: iv, blockMode: .CFB)
        let encrypted = try! aes.encrypt(byteArray, padding: nil)
        
        let encryptedData = NSData(bytes: encrypted)
        let encryptedBase64String = encryptedData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        return encryptedBase64String
    }
    
    private static func DecryptModerate(text:String) -> String {
        let encryptedData = NSData(base64EncodedString: text, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let count = encryptedData!.length / sizeof(UInt8)
        var encryptedArray = [UInt8](count: count, repeatedValue: 0)
        encryptedData!.getBytes(&encryptedArray, length:count * sizeof(UInt8))
        
        let key = "1234567890123456"
        let iv = "1234567890123456"
        
        let aes = try! AES(key: key, iv: iv, blockMode: .CBC)
        
        let decryptedArray = try! aes.decrypt(encryptedArray, padding: nil)
        
        let decryptedString = NSString(bytes: decryptedArray, length: decryptedArray.count, encoding: NSUTF8StringEncoding) as! String
        
        return decryptedString
    }
    
    private static func DecryptSecure(text:String) -> String {
        let encryptedData = NSData(base64EncodedString: text, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let count = encryptedData!.length / sizeof(UInt8)
        var encryptedArray = [UInt8](count: count, repeatedValue: 0)
        encryptedData!.getBytes(&encryptedArray, length:count * sizeof(UInt8))
        
        let key = "1234567890123456"
        let iv = "qwertyuasdfghjkl"
        
        let aes = try! AES(key: key, iv: iv, blockMode: .CBC)
        
        let decryptedArray = try! aes.decrypt(encryptedArray, padding: nil)
        
        let decryptedString = NSString(bytes: decryptedArray, length: decryptedArray.count, encoding: NSUTF8StringEncoding) as! String
        
        return decryptedString
    }
    
    private static func DecryptHighlySecure(text:String) -> String {
        let encryptedData = NSData(base64EncodedString: text, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let count = encryptedData!.length / sizeof(UInt8)
        var encryptedArray = [UInt8](count: count, repeatedValue: 0)
        encryptedData!.getBytes(&encryptedArray, length:count * sizeof(UInt8))
        
        let key = "12345678901234561234567890123456"
        let iv = "1234567890123456"
        
        let aes = try! AES(key: key, iv: iv, blockMode: .CFB)
        
        let decryptedArray = try! aes.decrypt(encryptedArray, padding: nil)
        
        let decryptedString = NSString(bytes: decryptedArray, length: decryptedArray.count, encoding: NSUTF8StringEncoding) as! String
        
        return decryptedString
    }
}
