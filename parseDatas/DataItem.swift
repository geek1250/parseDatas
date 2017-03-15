//
//  DataItem.swift
//  parseDatas
//
//  Created by Kevin Zhang on 2017-03-15.
//  Copyright © 2017 Kevin Zhang. All rights reserved.
//


import UIKit

class DataItem: NSObject {
    var text:String?
    var iconURL:String?
    var linkURL:String?
    
    init(topic: Dictionary<String,AnyObject>) {
        text = topic["Text"] as! String?
        linkURL = topic["FirstURL"] as! String?
        
        if let iconDict = topic["Icon"], iconDict is Dictionary<NSString, NSString> {
            iconURL = iconDict["URL"] as! String?
        }
    }
}
