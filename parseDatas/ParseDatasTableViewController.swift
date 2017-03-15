//
//  parseDatasTableViewController.swift
//  parseDatas
//
//  Created by Kevin Zhang on 2017-03-15.
//  Copyright © 2017 Kevin Zhang. All rights reserved.
//

import UIKit

class ParseDatasTableViewController: UITableViewController {
    
    var tableDatas:NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDatas()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadDatas() {
        let request = NSMutableURLRequest(url: NSURL(string: "http://api.duckduckgo.com/?q=apple&format=json&pretty=1")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                
                let jsonString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue);
                print(jsonString)
                
                self.parseData(data: data)
            }
        })
        
        dataTask.resume()
    }
    
    func parseData(data: Data?) {
        if let resultData = data {
            do {
                let jsonObj:Any = try JSONSerialization.jsonObject(with: resultData, options: JSONSerialization.ReadingOptions.mutableContainers)
                if jsonObj is Dictionary<NSString, AnyObject> {
                    let dictObj = jsonObj as! Dictionary<NSString, AnyObject>
                    let datalist = dictObj["RelatedTopics"] as! NSArray
                    self.tableDatas = self.dataItems(datalist: datalist)
                    self.tableView.reloadData()
                }
            } catch {
                
            }
            
            
            
        }
    }
    
    func dataItems(datalist: NSArray) -> NSArray {
        let items:NSMutableArray = NSMutableArray()
        for item in datalist {
            let dictItem = item as! Dictionary<NSString, AnyObject>
            if let topics = dictItem["Topics"] {
                let datas = self.dataItems(datalist: topics as! NSArray)
                for subItem in datas {
                    items.add(subItem)
                }
            }else {
                items.add(DataItem(topic: dictItem as Dictionary<String, AnyObject>))
            }
        }
        
        return items
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.tableDatas != nil {
            //return (self.tableDatas?.count)!
            if (self.tableDatas?.count)! < 20 {
                return (self.tableDatas?.count)!
            }else{
                return 20
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        
        for view in cell.subviews {
            //view.removeFromSuperview()
        }
        
        let data:DataItem = self.tableDatas?.object(at: indexPath.row) as! DataItem
        if cell is DataItemCell {
            let dataCell: DataItemCell = cell as! DataItemCell
            dataCell.item = data
            
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data:DataItem = self.tableDatas?.object(at: indexPath.row) as! DataItem
        if let url = data.linkURL {
            //should judge url reachabe or not
            
            //let myWebView = webViewController(url: url)
            //self.present(myWebView, animated: true, completion: nil)
            
            let mywebViewController = UIViewController()
            let webView = UIWebView(frame: mywebViewController.view.bounds)
            webView.loadRequest(NSURLRequest(url: NSURL(string: url) as! URL) as URLRequest)
            mywebViewController.view = webView
            
            
            let navController = UINavigationController(rootViewController: mywebViewController)
            mywebViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ParseDatasTableViewController.dismiss as (ParseDatasTableViewController) -> () -> ()))
            
            self.present(navController, animated: true, completion: nil)
        }
        
        
        
        
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

