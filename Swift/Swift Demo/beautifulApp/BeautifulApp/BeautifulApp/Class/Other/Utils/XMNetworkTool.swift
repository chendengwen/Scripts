//
//  XMNetworkTool.swift
//  baiduCourse
//
//  Created by 梁亦明 on 15/9/13.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import Foundation

class XMNetworkTool: NSObject {
    
    // 当前网络是否可达
    static var reachable : Bool = false
    static var status : AFNetworkReachabilityStatus!
    
    /**检测网路状态**/
    static func connected() -> Bool {
        return reachable
    }
    
    static func netWorkStatus() {
        /**
        AFNetworkReachabilityStatusUnknown          = -1,  // 未知
        AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
        AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
        AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
        */
        // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
        AFNetworkReachabilityManager.shared().startMonitoring();
        // 检测网络连接的单例,网络变化时的回调方法
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (statuss : AFNetworkReachabilityStatus) -> Void in
            
            status = statuss
            reachable = status != AFNetworkReachabilityStatus.notReachable;
        }
        
        
    }
    
    /**
    *   get方式获取数据
    *   url : 请求地址
    *   params : 传入参数
    *   success : 请求成功回调函数
    *   fail : 请求失败回调函数
    */
    
    static func get(_ url : String, params : AnyObject?, success :@escaping (_ json : AnyObject) -> Void , fail:@escaping (_ error : Any) -> Void) {
        var url = url
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
//        manager.requestSerializer = AFHTTPRequestSerializer()
//        manager.responseSerializer = AFHTTPResponseSerializer()
        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        // 设置网络请求
        manager.requestSerializer.timeoutInterval = NETWORK_TIMEOUT
        manager.get(url, parameters: params, success: { (operation, obj) -> Void in
                print ("请求地址:\(url)\(params)")
                success(obj as AnyObject)
            
            }) { (operation, error) -> Void in
            
                fail(error: error)
                
                print(error)
        }
        
    }
    
    /**
    *   post方式获取数据
    *   url : 请求地址
    *   params : 传入参数
    *   success : 请求成功回调函数
    *   fail : 请求失败回调函数
    */
    
    static func post(_ url : String, params : NSDictionary, success:@escaping (_ json : Any) -> Void , fail:@escaping (_ error : Any) -> Void) {
    
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        manager.post(url, parameters: params, success: { (operration, obj) -> Void in
            success(json:obj)
            }) { (operration, error) -> Void in
            fail(error: error)
        }
    }
}
