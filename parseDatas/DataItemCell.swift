//
//  DataItemCell.swift
//  parseDatas
//
//  Created by Kevin Zhang on 2017-03-15.
//  Copyright © 2017 Kevin Zhang. All rights reserved.
//

import UIKit

class DataItemCell: UITableViewCell {
    
    var item: DataItem? {
        didSet {
            self.textLabel?.text = item?.text
            self.imageView?.image = nil
            
            if item?.iconURL != nil && item?.iconURL != "" {
                let url:URL = URL(string: (item?.iconURL)! as String)!
                
                let session = URLSession.shared
                var task = URLSessionDownloadTask()
                task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                    if let data = try? Data(contentsOf: url){
                        DispatchQueue.main.async(execute: { () -> Void in
                            let img:UIImage! = UIImage(data: data)
                            self.imageView?.image = img
                            
                            self.setNeedsLayout()//update UI
                        })
                    }
                })
                task.resume()
            }
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.textLabel?.numberOfLines = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
