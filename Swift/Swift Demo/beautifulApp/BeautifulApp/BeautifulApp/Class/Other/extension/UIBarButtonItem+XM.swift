//
//  UIBarButtonItem+XM.swift
//  baiduCourse
//
//  Created by 梁亦明 on 15/9/17.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    class func barButtonItemWithImg(_ image : UIImage!, selectorImg : UIImage?, target : AnyObject!, action : Selector!) -> UIBarButtonItem {
        let button : UIButton = UIButton()
        button.setBackgroundImage(image, for: UIControlState())
        button.setBackgroundImage(selectorImg, for: UIControlState.highlighted)
        button.frame = CGRect(x: 0, y: 0, width: (button.currentBackgroundImage?.size.width)!, height: (button.currentBackgroundImage?.size.height)!)
        button.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        return UIBarButtonItem(customView: button)
    }
}
