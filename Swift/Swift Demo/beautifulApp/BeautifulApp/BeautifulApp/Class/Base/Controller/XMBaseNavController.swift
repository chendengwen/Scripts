//
//  XMBaseNavController.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/11/21.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

class XMBaseNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.isNavigationBarHidden = true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            UIApplication.shared.statusBarStyle = .default
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if self.viewControllers.count == 2 {
            UIApplication.shared.statusBarStyle = .lightContent
        }
        return super.popViewController(animated: animated)
    }
}
