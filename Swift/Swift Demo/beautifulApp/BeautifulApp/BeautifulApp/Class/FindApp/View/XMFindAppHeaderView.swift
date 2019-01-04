//
//  XMFindAppHeaderView.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/11/24.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

// 代理
protocol XMFindAppHeaderViewDelegate {
    // 点击最热分享
    func findAppHeaderViewHotBtnDidClick(_ headerView : XMFindAppHeaderView, hotBtn : UIButton)
    // 点击最新分享
    func findAppHeaderViewLastestBtnDidClick(_ headerView : XMFindAppHeaderView, lastestBtn : UIButton)
    // 点击菜单
    func findAppHeaderViewMenuBtnDidClick(_ headerView : XMFindAppHeaderView, menuBtn : UIButton)
}

class XMFindAppHeaderView: UIView {
    // 最热
    @IBOutlet weak var hotButton: UIButton!
    // 最新
    @IBOutlet weak var latestButton: UIButton!
    
    // 当前选中
    fileprivate weak var indexButton : UIButton!
    
    var delegate : XMFindAppHeaderViewDelegate?

    class func headerView () -> XMFindAppHeaderView {
        return Bundle.main.loadNibNamed("XMFindAppHeaderView", owner: nil, options: nil)!.first as! XMFindAppHeaderView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // 默认选中第一个
        self.indexButton = self.hotButton
    }
    
    //MARK: -Event Action
    
    // 点击最热分享
    @IBAction func hotBtnDidClick(_ sender: UIButton) {
        guard self.indexButton != sender else {
            return
        }
        delegate?.findAppHeaderViewHotBtnDidClick(self, hotBtn: sender)
        self.selectIndex(sender)
    }
    
    // 点击最新分享
    @IBAction func lastestBtnDidClick(_ sender: UIButton) {
        guard self.indexButton != sender else {
            return
        }
        delegate?.findAppHeaderViewLastestBtnDidClick(self, lastestBtn: sender)
        self.selectIndex(sender)
    }
    // 点击菜单按钮
    @IBAction func menuBtnDidClick(_ sender: AnyObject) {
        delegate?.findAppHeaderViewMenuBtnDidClick(self, menuBtn: sender as! UIButton)
    }
    //MARK : private 
    fileprivate func selectIndex(_ selectBtn : UIButton) {
        self.indexButton.isSelected = false
        self.indexButton.backgroundColor = UIColor.clear
        selectBtn.backgroundColor = UIColor.white
        selectBtn.isSelected = true
        self.indexButton = selectBtn
    }
    
}
