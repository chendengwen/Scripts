//
//  SettingHeaderView.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/11/27.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

class SettingHeaderView: UIView {
    typealias backBtnClickBlock = () -> Void
    @IBOutlet weak var title: UILabel!
    // 回调
    fileprivate var block : backBtnClickBlock?
    
    class func headerView () -> SettingHeaderView {
        return Bundle.main.loadNibNamed("SettingHeaderView", owner: nil, options: nil)!.first as! SettingHeaderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func backBtnDidClick(_ sender: UIButton) {
        if let _ = self.block {
            self.block!()
        }
    }
    
    
    func backBtnDidClickWithBlock(_ block : backBtnClickBlock?) {
        self.block = block
    }
}
