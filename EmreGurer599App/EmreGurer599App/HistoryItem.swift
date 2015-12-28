//
//  HistoryItem.swift
//  EmreGurer599App
//
//  Created by Emre Gurer on 20.12.2015.
//  Copyright © 2015 Emre Gurer. All rights reserved.
//

import Foundation

public class HistoryItem {
    
    public var TransferId:Int = 0
    
    public var TransferDate = NSDate()
    
    public var SenderName:String = ""
    
    public var ReceiverName:String = ""
    
    public var TransferDirection:Int = 0
    
    public var Status = 0
}
