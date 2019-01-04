//
//  XMClassifyViewController.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/11/16.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit
import SafariServices

class XMClassifyViewController: UIViewController, XMClassifyCenterViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        
        self.view.addSubview(centerView)
        
        centerView.snp_makeConstraints { (make) -> Void in
            make.left.right.top.bottom.equalTo(self.view).offset(0)
        }
    }
    
    //MARK:- Custer delegate
    // 登陆
    func classifyCenterViewLoginViewDidClick(_ centerView: XMClassifyCenterView, loginView: UIView) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_HIDDEMENU), object: nil)
    }
    
    // 每日最美
    func classifyCenterViewEveryDayLoveViewDidClick(_ centerView: XMClassifyCenterView, everyDayLoveView: UIView) {
        // 隐藏menu
//        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_HIDDEMENU, object: nil)
        // 设置api
        let setupAPINotify : Notification = Notification(name: Notification.Name(rawValue: NOTIFY_SETUPHOMEVIEWTYPE), object: NOTIFY_OBJ_TODAY)
        NotificationCenter.default.post(setupAPINotify)
        // 是否切换centerView的通知
        let setupViewNotify : Notification = Notification(name: Notification.Name(rawValue: NOTIFY_SETUPCENTERVIEW), object: NOTIFY_OBJ_TODAY)
        NotificationCenter.default.post(setupViewNotify)
    }
    
    // 限免推荐
    func classifyCenterViewRecommendViewDidClick(_ centerView: XMClassifyCenterView, recommendView: UIView) {
//        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_HIDDEMENU, object: nil)
        let notify : Notification = Notification(name: Notification.Name(rawValue: NOTIFY_SETUPHOMEVIEWTYPE), object: NOTIFY_OBJ_RECOMMEND)
        NotificationCenter.default.post(notify)
        
        // 是否切换centerView的通知
        let setupViewNotify : Notification = Notification(name: Notification.Name(rawValue: NOTIFY_SETUPCENTERVIEW), object: NOTIFY_OBJ_RECOMMEND)
        NotificationCenter.default.post(setupViewNotify)
    }
    
    // 发现应用
    func classifyCenterViewFindViewDidClick(_ centerView: XMClassifyCenterView, findView: UIView) {
//        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_HIDDEMENU, object: nil)
        
        // 是否切换centerView的通知
        let setupViewNotify : Notification = Notification(name: Notification.Name(rawValue: NOTIFY_SETUPCENTERVIEW), object: NOTIFY_OBJ_FINDAPP)
        NotificationCenter.default.post(setupViewNotify)
    }
    
    // 文章专栏
    func classifyCenterViewArticleViewDidClick(_ centerView: XMClassifyCenterView, articleView: UIView) {
//        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_HIDDEMENU, object: nil)
        let notify : Notification = Notification(name: Notification.Name(rawValue: NOTIFY_SETUPHOMEVIEWTYPE), object: NOTIFY_OBJ_ARTICLE)
        NotificationCenter.default.post(notify)
        
        // 是否切换centerView的通知
        let setupViewNotify : Notification = Notification(name: Notification.Name(rawValue: NOTIFY_SETUPCENTERVIEW), object: NOTIFY_SETUPHOMEVIEWTYPE)
        NotificationCenter.default.post(setupViewNotify)
    }
    // 美我一下
    func classifyCenterViewSupportViewDidClick(_ centerView: XMClassifyCenterView, supportView: UIView) {
//        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_HIDDEMENU, object: nil)
        UIApplication.shared.openURL(URL(string: APIConfig.API_APPStoreComment)!)
    }
    // 我的收藏
    func classifyCenterViewCollectViewDidClick(_ centerView: XMClassifyCenterView, collectView: UIView) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_HIDDEMENU), object: nil)
    }
    // 搜索
    func classifyCenterViewSearchViewDidClick(_ centerView: XMClassifyCenterView, searchView: UIView) {
        self.present(XMSearchController(), animated: true, completion: nil)
    }
    
    // 招聘编辑
    func classifyCenterViewInviteViewDidClick(_ center: XMClassifyCenterView, inviteView: UIView) {
        let safaController : SFSafariViewController = SFSafariViewController(url: URL(string: APIConfig.API_Invite)!)
        self.present(safaController, animated: true, completion: nil)
    }
    
    // 更多
    func classifyCenterViewSettingViewDidClick(_ centerView: XMClassifyCenterView, settingView: UIView) {
        self.present(XMBaseNavController(rootViewController:SettingViewController()), animated: true, completion: nil)
    }
    

    //MARK:- getter or Setter
    
    fileprivate lazy var centerView : XMClassifyCenterView = {
        let centerView : XMClassifyCenterView = XMClassifyCenterView.centerView()
        centerView.delegate = self
        return centerView
    }()

}
