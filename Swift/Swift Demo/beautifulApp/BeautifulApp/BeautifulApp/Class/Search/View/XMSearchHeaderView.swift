//
//  XMSearchCenterView.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/11/29.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

class XMSearchHeaderView: UIView {
    typealias cancleBtnDidClickBlock = () -> Void
    // 监听textfiled文字变化
    typealias textFieldDidChangeBlock = (_ text : String) -> Void
    @IBOutlet weak var cancleBtn: UIButton!
    var block : cancleBtnDidClickBlock?
    var textFieldBlock : textFieldDidChangeBlock?
    class func headerView() -> XMSearchHeaderView {
        return Bundle.main.loadNibNamed("XMSearchHeaderView", owner: nil, options: nil)!.first as! XMSearchHeaderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cancleBtn.layer.cornerRadius = 2
        self.cancleBtn.layer.masksToBounds = true
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        if let _ = self.textFieldBlock {
            self.textFieldBlock!(sender.text!)
        }
    }
    @IBAction func cancleBtnDidClick(_ sender: UIButton) {
        if let _ = self.block {
            self.block!()
        }
    }
    
    func textfieldDidChangeWithBlock (_ block : textFieldDidChangeBlock?) {
        self.textFieldBlock = block
    }

    func cancleBtnDidClickWithBlock (_ block : cancleBtnDidClickBlock?) {
        self.block = block
    }
}
