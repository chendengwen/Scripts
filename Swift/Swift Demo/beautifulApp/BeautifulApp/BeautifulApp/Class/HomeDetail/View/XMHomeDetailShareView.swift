//
//  XMHomeDetailShareView.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/12/6.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

class XMHomeDetailShareView: UIView {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var centerView: XMView!
    
    typealias ShareViewDidClickBlock = () -> Void
    
    var block : ShareViewDidClickBlock?
    var iconURL : String! {
        willSet {
            self.iconURL = newValue
        }
        
        didSet {
            self.iconView.xm_setBlurImageWithURL(URL(string: iconURL), placeholderImage: UIImage(named: "home_logo_pressed"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.centerView.viewAddTarget(self, action: "centerViewDidClick")
    }
    
    class func shareView () -> XMHomeDetailShareView {
        return Bundle.main.loadNibNamed("XMHomeDetailShareView", owner: nil, options: nil)!.first as! XMHomeDetailShareView
    }
    
    func centerViewDidClick() {
        if let _ = self.block {
            self.block!()
        }
    }
    
    func centerViewDidClickWithBlock(_ block : @escaping ShareViewDidClickBlock) {
        self.block = block
    }
}
