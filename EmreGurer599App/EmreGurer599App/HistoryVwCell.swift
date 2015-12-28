//
//  HistoryVwCell.swift
//  EmreGurer599App
//
//  Created by Emre Gurer on 25.12.2015.
//  Copyright © 2015 Emre Gurer. All rights reserved.
//

import UIKit

class HistoryVwCell: UICollectionViewCell {

    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var downloadBtn: UIButton!
    
    @IBAction func DownloadClicked(sender: AnyObject) {
        HistoryViewController.TransferFile(sender.tag!)
    }
}
