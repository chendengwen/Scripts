//
//  XHNewsTableViewController.swift
//  XHNewsParsingSwift
//
//  Created by dw_iOS on 14-6-5.
//  Copyright (c) 2014年 广州华多网络科技有限公司 多玩事业部 iOS软件工程师 曾宪华. All rights reserved.
//写了一个sina news客户端，swift写的 有什么问题可以加swift群一起探讨,群号:328218600

import Foundation
import UIKit

class XHNewsTableViewController : UITableViewController {
    var dataSource = []
    
    var thumbQueue = NSOperationQueue()
    
    let hackerNewsApiUrl = "http://app.xxjr.com/org/queryList"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
        refreshControl.addTarget(self, action: "loadDataSource", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadDataSource();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDataSource() {
        self.refreshControl!.beginRefreshing()
        let loadURL = NSURL(string: hackerNewsApiUrl)
        let request = NSURLRequest(URL: loadURL!)
        let loadDataSourceQueue = NSOperationQueue();
        
        NSURLConnection.sendAsynchronousRequest(request, queue: loadDataSourceQueue, completionHandler: { response, data, error in
            if (error != nil) {
                print(error)
                dispatch_async(dispatch_get_main_queue(), {
                    self.refreshControl!.endRefreshing()
                    })
            } else {
                let json:NSDictionary! = try? NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let newsDataSource = json["rows"] as? NSArray
                dispatch_async(dispatch_get_main_queue(), {
                    self.dataSource = newsDataSource!
                    self.tableView.reloadData()
                    self.refreshControl!.endRefreshing()
                    })
            }
            })
    }
    
    // #pragma mark - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showWebDetail" {
//            let indexPath = self.tableView.indexPathForSelectedRow()
//            let object = dataSource[indexPath.row] as NSDictionary
//            (segue.destinationViewController as XHWebViewDetailController).detailID = object["id"] as NSInteger
        }
    }

    
    // #pragma mark - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("XHNewsCell", forIndexPath: indexPath) as UITableViewCell
        
        let object = dataSource[indexPath.row] as! NSDictionary
        
        cell.textLabel!.text = object["orgName"] as? String
        cell.detailTextLabel!.text = object["loanDesc"] as? String
        cell.imageView!.image = UIImage(named :"cell_photo_default_small")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        let imageName = object["orgImage"] as! String
        let urlStr = NSString(format: "http://app.xxjr.com%@" ,imageName)
        let request = NSURLRequest(URL :NSURL(string:urlStr as String)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: thumbQueue, completionHandler: { response, data, error in
            if (error != nil) {
                print(error)
                
            } else {
                let image = UIImage.init(data :data!)
                dispatch_async(dispatch_get_main_queue(), {
                    cell.imageView!.image = image
                    })
            }
            })
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
}
