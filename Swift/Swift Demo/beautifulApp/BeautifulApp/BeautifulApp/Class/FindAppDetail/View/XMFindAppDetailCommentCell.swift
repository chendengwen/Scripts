//
//  XMFindAppDetailCommentCell.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/12/3.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

class XMFindAppDetailCommentCell: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 头像
        userImgView.frame = CGRect(x: UI_MARGIN_10, y: 0, width: 30, height: 30)
        self.addSubview(userImgView)
        // 名字
        userNameLabel.frame = CGRect(x: userImgView.frame.maxX + UI_MARGIN_10, y: 0, width: 150, height: 15)
        self.addSubview(userNameLabel)
        // 详情
        userDetailLabel.frame = CGRect(x: userNameLabel.x, y: userNameLabel.frame.maxY, width: 120, height: 15)
        self.addSubview(userDetailLabel)
        // 时间
        timeLabel.frame = CGRect(x: SCREEN_WIDTH-120-UI_MARGIN_10, y: 0, width: 120, height: 15)
        self.addSubview(timeLabel)
        // 评论背景
        commentBg.frame = CGRect(x: UI_MARGIN_10, y: userImgView.frame.maxY+UI_MARGIN_5, width: SCREEN_WIDTH-2*UI_MARGIN_10, height: 20)
        self.addSubview(commentBg)
        // 评论
        commentLabel.frame = CGRect(x: UI_MARGIN_10, y: 15, width: commentBg.width-2*UI_MARGIN_10, height: 20)
        commentBg.addSubview(commentLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData<T>(_ model : T) where T : NSObject {
        if model is XMFindAppCommentModel {
            let commentModel : XMFindAppCommentModel = model as! XMFindAppCommentModel
            // 1.设置头像
            self.userImgView.xm_setBlurImageWithURL(URL(string: commentModel.author_avatar_url!), placeholderImage: UIImage(named: "detail_portrait_default"))
            // 2.设置名字
            self.userNameLabel.text = commentModel.author_name!
            // 3.设置详情
            self.userDetailLabel.text = commentModel.author_career!
            // 4.时间
            self.timeLabel.text = commentModel.updated_at!
            // 5.评论内容
            let attributStr : NSMutableAttributedString = NSMutableAttributedString(string: commentModel.content!)
            attributStr.setAttributes([NSFontAttributeName : UI_FONT_12], range: NSMakeRange(0, commentModel.content!.length))
            attributStr.yy_color = UIColor.darkGray
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 5.0
            attributStr.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, commentModel.content!.length))
            let textLayout = YYTextLayout (containerSize: CGSize(width: commentBg.width-2*UI_MARGIN_10, height: CGFloat.greatestFiniteMagnitude), text: attributStr)
            commentLabel.size = (textLayout?.textBoundingSize)!
            commentLabel.textLayout = textLayout
            // 设置frame
            self.commentBg.height = commentLabel.frame.maxY+UI_MARGIN_10
            self.height = commentBg.frame.maxY+UI_MARGIN_10
            
        } else if model is XMCommentsDataModel {
            let commentModel : XMCommentsDataModel = model as! XMCommentsDataModel
            // 1.设置头像
            self.userImgView.xm_setBlurImageWithURL(URL(string: commentModel.author_avatar_url!), placeholderImage: UIImage(named: "detail_portrait_default"))
            // 2.设置名字
            self.userNameLabel.text = commentModel.author_name!
            // 3.设置详情
            self.userDetailLabel.text = commentModel.author_career!
            // 4.时间
            self.timeLabel.text = commentModel.updated_at!
            // 5.评论内容
            let attributStr : NSMutableAttributedString = NSMutableAttributedString(string: commentModel.content!)
            attributStr.setAttributes([NSFontAttributeName : UI_FONT_12], range: NSMakeRange(0, commentModel.content!.length))
            attributStr.yy_color = UIColor.darkGray
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 5.0
            attributStr.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, commentModel.content!.length))
            let textLayout = YYTextLayout (containerSize: CGSize(width: commentBg.width-2*UI_MARGIN_10, height: CGFloat.greatestFiniteMagnitude), text: attributStr)
            commentLabel.size = (textLayout?.textBoundingSize)!
            commentLabel.textLayout = textLayout
            // 设置frame
            self.commentBg.height = commentLabel.frame.maxY+UI_MARGIN_10
            self.height = commentBg.frame.maxY+UI_MARGIN_10
            
        }
        
    }
    
    // 头像
    fileprivate lazy var userImgView : UIImageView = {
        let userImgView : UIImageView = UIImageView()
        userImgView.layer.cornerRadius = 15
        userImgView.layer.borderColor = UIColor.lightGray.cgColor
        userImgView.layer.borderWidth = 1
        userImgView.layer.masksToBounds = true
        return userImgView
    }()
    
    // 名字
    fileprivate lazy var userNameLabel : UILabel = {
        let userNameLabel : UILabel = UILabel()
        userNameLabel.font = UI_FONT_12
        userNameLabel.textColor = UIColor.black
        return userNameLabel
    }()
    
    // 详情
    fileprivate lazy var userDetailLabel : UILabel = {
        let userDetailLabel : UILabel = UILabel()
        userDetailLabel.font = UI_FONT_10
        userDetailLabel.textColor = UIColor.lightGray
        return userDetailLabel
    }()
    
    // 时间
    fileprivate lazy var timeLabel : UILabel = {
        let timeLabel : UILabel = UILabel()
        timeLabel.textColor = UIColor.lightGray
        timeLabel.font = UI_FONT_10
        timeLabel.textAlignment = NSTextAlignment.right
        return timeLabel
    }()
    
    // 评论背景
    fileprivate lazy var commentBg : UIImageView = {
        var commentBg : UIImageView = UIImageView()
        let bgImg : UIImage = UIImage(named: "detail_comment_bg")!
        let stretchWidth = bgImg.size.width*0.8
        let stretchHeight = bgImg.size.height*0.4
        commentBg.image = bgImg.resizableImage(withCapInsets: UIEdgeInsets(top: stretchHeight, left: stretchWidth, bottom: stretchHeight, right: bgImg.size.width*0.1), resizingMode: UIImageResizingMode.stretch)
        return commentBg
    }()
    
    // 评论了内容
    fileprivate lazy var commentLabel : YYLabel = {
        var commentLabel : YYLabel = YYLabel()
        commentLabel.font = UI_FONT_10
        commentLabel.textColor = UIColor.darkGray
        commentLabel.numberOfLines = 0
        return commentLabel
    }()
}
