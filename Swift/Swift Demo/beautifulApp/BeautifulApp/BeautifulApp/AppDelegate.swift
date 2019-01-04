//
//  AppDelegate.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/11/5.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        // 在homecontroller里套一层navcontroller
        window?.rootViewController = XMMenuViewController(centerController: XMBaseNavController(rootViewController:XMHomeViewController()), leftController: XMClassifyViewController())
        
        self.setupShareSDK()
        return true
    }
    
    fileprivate func setupShareSDK() {
        
        ShareSDK.registerApp("d3eb48e7c2d9")
        //初始化新浪微博
        ShareSDK.connectSinaWeibo(withAppKey: "3251853898", appSecret: "816acc6102b92c8aa862431fdc7142a7", redirectUri: "https://github.com/lyimin", weiboSDKCls: WeiboSDK.classForCoder())
        //初始化微信，微信开放平台上注册应用
        ShareSDK.connectWeChat(withAppId: "wx5e0a9f56decb72ba",appSecret:"d5f0dacaf2c5b20401c1569645605221",wechatCls:WXApi.classForCoder());
        //初始化QQ,QQ空间
        ShareSDK.connectQQ(withQZoneAppKey: "1104940507", qqApiInterfaceCls: QQApiInterface.classForCoder(), tencentOAuthCls: TencentOAuth.classForCoder())
        //连接QQ空间应用
        ShareSDK.connectQZone(withAppKey: "1104940507", appSecret: "x4fpQbKWfydGNRyD", qqApiInterfaceCls: QQApiInterface.classForCoder(), tencentOAuthCls: TencentOAuth.classForCoder())
    }
    
    //添加两个回调方法,return的必须要ShareSDK的方法
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        return ShareSDK.handleOpen(url, wxDelegate: self)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any ) -> Bool{
        
        return ShareSDK.handleOpen(url, sourceApplication: sourceApplication, annotation: annotation, wxDelegate: self)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

