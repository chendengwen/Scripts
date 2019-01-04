//
//  AboutViewController.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/11/28.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit
import SafariServices

class AboutViewController: UIViewController, AboutCenterViewDelegate {
    fileprivate weak var headerView : SettingHeaderView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置导航栏
        self.setupNavView()
        
        self.view.addSubview(centerView)
        
        // 适配屏幕
        self.setupLayout()
    }
    
    // MARK: - centerView delegate
    func AboutCenterViewOfficialWebViewDidClick() {
        // 官网地址
        let officialURL = "http://zuimeia.com/apps/?platform=1&utm_source=iosapp&utm_campaign=referral&utm_medium=about"
        UIApplication.shared.openURL(URL(string: officialURL)!)
    }
    func AboutCenterViewWechatViewDidClick() {
        let pasteboard : UIPasteboard = UIPasteboard.general
        pasteboard.string = "最美应用";
        let alert : UIAlertController = UIAlertController(title: "提示", message: "复制微信公众账号成功^_^\n跳转到微信关注我们", preferredStyle: UIAlertControllerStyle.alert)
        let cancleAction : UIAlertAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        let enterAction : UIAlertAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (enter) -> Void in
            
        }

        alert.addAction(cancleAction)
        alert.addAction(enterAction)
        self.present(alert, animated: true, completion: nil)
    }
    func AboutCenterViewExonerateViewDidClick() {
        let exonerateURL = "http://zuimeia.com/article/74/"
        let safaController : SFSafariViewController = SFSafariViewController(url: URL(string: exonerateURL)!)
        self.present(safaController, animated: true, completion: nil)
    }
    func AboutCenterViewUserAgreementDidClick() {
        let userAgressURL = "http://zuimeia.com/article/69/"
        let safaController : SFSafariViewController = SFSafariViewController(url: URL(string: userAgressURL)!)
        self.present(safaController, animated: true, completion: nil)
    }
    
    // MARK: - private
    fileprivate func setupNavView() {
        let headerView : SettingHeaderView = SettingHeaderView.headerView()
        self.headerView = headerView
        headerView.title.text = "关于我们"
        headerView.y = 0
        headerView.backBtnDidClickWithBlock { [unowned self]() -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        self.view.addSubview(headerView)
    }
    
    fileprivate func setupLayout() {
        self.headerView.snp_makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(headerView.height)
        }
        
        self.centerView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.headerView.snp_bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
    // MARK: - getter or setter 
    
    fileprivate lazy var centerView : AboutCenterView = {
        let centerView = AboutCenterView.centerView()
        centerView.delegate = self
        return centerView
    }()
}
