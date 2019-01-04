//
//  UIViewController+XM.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/11/9.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showNetWorkErrorView () {
        let errorView : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 145))
        errorView.center = self.view.center
        errorView.setImage(UIImage(named: "not_network_icon_unpre"), for: UIControlState())
        errorView.setImage(UIImage(named: "not_network_icon_pre"), for: .highlighted)
        errorView.addTarget(self, action: #selector(UIViewController.errorViewDidClick(_:)), for: .touchUpInside)
        self.view.addSubview(errorView)
        // 让他处在view的最上层
        self.view.bringSubview(toFront: errorView)
    }
    
    func errorViewDidClick(_ errorView : UIButton) {
        errorView.removeFromSuperview()
        NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_ERRORBTNCLICK), object: nil)
    }
    
    func showProgress () {
        let progressView : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        progressView.tag = 500
        progressView.center = self.view.center
        self.view.addSubview(progressView)
        
        var imgArray : Array<UIImage> = Array()
        // 添加图片
        for i in 0..<8 {
            let image : UIImage = UIImage(named: "loading_\(i+1)")!
            imgArray.append(image)
        }
        progressView.animationImages = imgArray
        progressView.animationDuration = 0.5
        progressView.animationRepeatCount = 999
        progressView.startAnimating()
    }
    
    func hiddenProgress() {
        for view in self.view.subviews {
            if view.tag == 500 {
                let imgView : UIImageView = view as! UIImageView
                imgView.stopAnimating()
                imgView.perform(#selector(setter: UIImageView.animationImages) , with: nil)
            }
        }
    }
    
}
