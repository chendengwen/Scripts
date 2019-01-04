//
//  XMFindAppViewModel.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/11/25.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

enum XMFindAppViewType {
    case xmFindAppViewTypeHotShare
    case xmFindAppViewTypeLastestShare
}

class XMFindAppViewModel: NSObject {
    // 最热分享
    fileprivate weak var hotShareView : UITableView!
    // 最新分享
    fileprivate weak var lastestView : UITableView!
    // 当前点击类型
    var findAppType : XMFindAppViewType = .xmFindAppViewTypeHotShare
    // 最热
    var hotDataSource : Array<XMFindAppModel> = Array()
    // 最新
    var lastDataSource : Array<XMFindAppModel> = Array()
    var lastDataPos : String = "-1"
    
    convenience init(hotShareView : UITableView, lastestView : UITableView) {
        self.init()
        self.hotShareView = hotShareView
        self.lastestView = lastestView
    }
    
    func getData(_ page : Int) {
        // api
        var apiString = APIConfig.API_FindApp_HotShare
        var params : NSDictionary? = ["page" : page]
        if self.findAppType == .xmFindAppViewTypeLastestShare {
            apiString = APIConfig.API_FindAPP_LastestShare
            if page > 0 {
                params = ["pos" : self.lastDataPos]
            } else {
                params = ["pos" : "-1"]
            }
            
        }
        // 参数
        
        XMNetworkTool.get(apiString, params: params, success: { (json) -> Void in
            
            let dataDic : NSDictionary = (json["data"] as? NSDictionary)!
            if dataDic["apps"] is NSArray {
                let array : NSArray = (dataDic["apps"] as? NSArray)!
                
                if self.findAppType == .xmFindAppViewTypeHotShare {
                    if page == 1 {
                        self.hotDataSource.removeAll()
                    }
                    
                    // 字典转模型
                    for dict in array {
                        let findAppModel : XMFindAppModel = XMFindAppModel(dict: dict as! NSDictionary)
                        self.hotDataSource.append(findAppModel)
                    }
                    
                    self.hotShareView.reloadData()
                    self.hotShareView.headerViewStopPullToRefresh()
                    self.hotShareView.footerEndRefreshing()
                } else {
                    if page < 0 {
                        self.lastDataSource.removeAll()
                    }
                    
                    // 字典转模型
                    for dict in array {
                        let findAppModel : XMFindAppModel = XMFindAppModel(dict: dict as! NSDictionary)
                        self.lastDataSource.append(findAppModel)
                    }
                    self.lastDataPos = (self.lastDataSource.last?.pos)!
                    self.lastestView.reloadData()
                    self.lastestView.headerViewStopPullToRefresh()
                    self.lastestView.footerEndRefreshing()
                }
            }
            }) { (error) -> Void in
                if self.findAppType == .xmFindAppViewTypeHotShare {
                    self.hotShareView.headerViewStopPullToRefresh()
                    self.hotShareView.footerEndRefreshing()
                } else {
                    self.lastestView.headerViewStopPullToRefresh()
                    self.lastestView.footerEndRefreshing()
                }
        }
        
    }
}
