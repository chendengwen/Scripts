//
//  XMHomeHeaderView.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/11/9.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

protocol XMHomeHeaderViewDelegate {
    func homeHeaderViewMoveToFirstDidClick(_ headerView : XMHomeHeaderView, moveToFirstBtn : UIButton)
    func homeHeaderViewMenuDidClick(_ header : XMHomeHeaderView, menuBtn : UIButton)
}

class XMHomeHeaderView: UIView {
    
    // 返回到第一
    @IBOutlet weak var moveToFirstBtn: UIButton!
    // 日期
    @IBOutlet weak var dateLabel: UILabel!
    // 星期
    @IBOutlet weak var weakLabel: UILabel!
    // 右边标题
    @IBOutlet weak var rightTitleLabel: UILabel!
    
    var rightTitle : String? {
        willSet {
            self.rightTitle = newValue
        }
        didSet {
            self.rightTitleLabel.text = rightTitle
        }
    }
    
    var delegate : XMHomeHeaderViewDelegate?
    
    var homeModel : XMHomeDataModel! {
        willSet {
            self.homeModel = newValue
        }
        
        didSet {
            if Date.isToday(homeModel.publish_date!) {
                self.dateLabel.text = "今天"
                self.hiddenMoveToFirstAnimation()
            } else if Date.isLastDay(homeModel.publish_date!) {
                self.dateLabel.text = "昨天"
                self.hiddenMoveToFirstAnimation()
            } else {
                self.dateLabel.text = Date.formattDay(homeModel.publish_date!)
                self.showMoveToFirstAnimation()
            }
            self.weakLabel.text = Date.weekWithDateString (homeModel.publish_date!)
        }
    }
    
    class func headerView () -> XMHomeHeaderView {
        return Bundle.main.loadNibNamed("XMHomeHeaderView", owner: nil, options: nil)!.first as! XMHomeHeaderView
    }
    //MARK: --- ACTION EVENT
    
    // 点击菜单
    @IBAction func menuImgDidClick(_ sender: UIButton) {
        self.delegate?.homeHeaderViewMenuDidClick(self, menuBtn: sender)
    }
    // 点击返回第一
    @IBAction func moveToFirstImgDidClick(_ sender: UIButton) {
        self.delegate?.homeHeaderViewMoveToFirstDidClick(self, moveToFirstBtn: sender)
        self.hiddenMoveToFirstAnimation()
    }
    
    //MARK: --- PRIVATE
    
    fileprivate func hiddenMoveToFirstAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.moveToFirstBtn.alpha = 0
            }, completion: nil)
    }
    
    fileprivate func showMoveToFirstAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.moveToFirstBtn.alpha = 1
            }, completion: nil)
    }
    
    //MARK : -- Public
    func setRightTitleHidden(_ flag : Bool) {
       
        self.rightTitleLabel.isHidden = flag
        self.dateLabel.isHidden = !flag
        self.weakLabel.isHidden = !flag
        self.moveToFirstBtn.isHidden = !flag
    }
}
