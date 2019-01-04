//
//  XMFindAppDetailCenterView.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/12/1.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

class XMFindAppDetailCenterView: UIScrollView, UIScrollViewDelegate {
    
    var dataModel : XMFindAppModel! {
        willSet {
            self.dataModel = newValue
        }
        
        didSet {
            self.setData()
        }
    }
//MARK: -life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 添加内容
        self.addSubview(centerView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: - dataSource
    
    /**
        设置数据
     */
    fileprivate func setData() {
        // 1.头像
        let userIconView : UIImageView = self.createUserImgView()
        let userIconSize : CGFloat = 36
        userIconView.frame = CGRect(x:SCREEN_WIDTH-userIconSize-UI_MARGIN_20 , y: 40, width: userIconSize, height: userIconSize)
        userIconView.xm_setBlurImageWithURL(URL(string: dataModel.author_avatar_url!)!, placeholderImage:UIImage(named: "detail_portrait_default"))
        
        // 2.用户名
        let userNameLabel = self.createTitleView(dataModel.author_name!)
        userNameLabel.textAlignment = NSTextAlignment.right
        let userNameLabelWidth : CGFloat = 150
        userNameLabel.frame = CGRect(x: userIconView.x-UI_MARGIN_5-userNameLabelWidth, y: userIconView.y, width: userNameLabelWidth, height: 20)
        // 3.详情
        let userDetailLabel = self.createUserSubTitleLabel()
        userDetailLabel.text = dataModel.author_career!
        userDetailLabel.frame = CGRect(x: userNameLabel.x, y: userNameLabel.frame.maxY, width: userNameLabelWidth, height: 15)
        // 4.分割线
        let topLine = self.createTitleSeparatLine()
        topLine.frame = CGRect(x: 0, y: userDetailLabel.frame.maxY+UI_MARGIN_10, width: SCREEN_WIDTH-UI_MARGIN_20, height: 1)
        // 5.appIcon
        appIconView.frame = CGRect(x: UI_MARGIN_20, y: topLine.frame.maxY+UI_MARGIN_15, width: 50, height: 50)
        self.centerView.addSubview(appIconView)
        appIconView.xm_setBlurImageWithURL(URL(string: dataModel.icon_image!)!, placeholderImage: UIImage(named: "ic_launcher"))
        // 6.appName
        let appNameLabelX = appIconView.frame.maxX + UI_MARGIN_10;
        appNameLabel.frame = CGRect(x: appNameLabelX, y: appIconView.center.y-UI_MARGIN_10, width: SCREEN_WIDTH-appNameLabelX-UI_MARGIN_10, height: 20)
        self.centerView.addSubview(appNameLabel)
        self.appNameLabel.text = dataModel.title!
        
        // 计算当前高度+toolbar高度
        contentY = appIconView.frame.maxY + UI_MARGIN_5 + 30
// MARK : 设置动态的view ------------ 很多view需要手动创建
        let margin : CGFloat = 10
        self.contentLabel.frame = CGRect(x: margin, y: contentY + UI_MARGIN_10, width: SCREEN_WIDTH-2*margin, height: 20)
    // 详情文字
        // 计算高度
        let contentText : String = (dataModel.appDescription! as NSString).replacingOccurrences(of: "<br/>", with: "\n")
        // 设置样式
        let attributString : NSMutableAttributedString = NSMutableAttributedString(string: contentText)
        attributString.setAttributes([NSFontAttributeName : UI_FONT_16], range: NSMakeRange(0, contentText.length))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        attributString.yy_color = UIColor.darkGray
        attributString.addAttribute(NSParagraphStyleAttributeName , value: paragraphStyle, range: NSMakeRange(0, contentText.length))
        let textLayout = YYTextLayout(containerSize: CGSize(width: SCREEN_WIDTH-2*margin, height: CGFloat.greatestFiniteMagnitude), text: attributString)
        // 设置frame
        contentLabel.size = (textLayout?.textBoundingSize)!
        contentLabel.textLayout = textLayout
        self.centerView.addSubview(self.contentLabel)
    
        contentY += (textLayout?.textBoundingSize.height)! + UI_MARGIN_10
    // 添加图片
        contentY = contentLabel.frame.maxY + margin
        for i in 0..<dataModel.all_images.count {
            let url : String = self.dataModel.all_images[i]
            // 根据url 获取图片高度
            let size : CGSize = url.getImageSizeWithURL()
            // 获取 _ 的位置
            let imgView : UIImageView = self.createImgView()
            imgView.frame = CGRect(x: 10, y: contentY, width: size.width, height: size.height)
            imgView.center.x = SCREEN_WIDTH*0.5
            imgView.xm_setBlurImageWithURL(URL(string: url), placeholderImage: UIImage(named: "home_logo_pressed"))
            self.centerView.addSubview(imgView)
            contentY += size.height + margin
        }
        
    // 美过的美友
        if dataModel.up_users.count != 0 {
            let loveUserLabel = self.createTitleView("美过的美友")
            loveUserLabel.frame = CGRect(x: margin, y: contentY + margin*2, width: 80, height: 20)
            
            // 分割线
            let sepLine = self.createTitleSeparatLine()
            sepLine.frame = CGRect(x: loveUserLabel.frame.maxX, y: loveUserLabel.center.y, width: 220, height: 0.5)
            contentY = loveUserLabel.frame.maxY+margin;
            // 添加点赞的头像
            // 头像大小
            let imgMargin : CGFloat = (SCREEN_WIDTH-2*margin-8*userIconSize)/7
            for i in 0..<dataModel.up_users.count {
                let userImg : UIImageView = self.createUserImgView()
                // 获取模型
                let upUserDate : XMUpUserDataModel = dataModel.up_users[i]
                userImg.xm_setBlurImageWithURL(URL(string: upUserDate.avatar_url!), placeholderImage: UIImage(named: "detail_portrait_default"))
                userImg.frame = CGRect(x: margin+(CGFloat(i).truncatingRemainder(dividingBy: 8))*(userIconSize+imgMargin), y: contentY + (userIconSize+imgMargin) * CGFloat(i/8), width: userIconSize, height: userIconSize)
                if i == dataModel.up_users.count - 1 {
                    contentY = userImg.frame.maxY;
                }
            }
        }
        
    // 评论
        if dataModel.comments.count != 0 {
            let commentLabel = self.createTitleView("评论")
            commentLabel.frame = CGRect(x: margin, y: contentY+2*margin, width: 35, height: 20)
            contentY = commentLabel.frame.maxY+margin;
            commentY = commentLabel.frame.maxY+margin
            // 分割线
            let sepLine = self.createTitleSeparatLine()
            sepLine.frame = CGRect(x: commentLabel.frame.maxX, y: commentLabel.center.y, width: 80, height: 0.5)
            
            // 添加评论
            for i in 0..<dataModel.comments.count {
                let commentView : XMFindAppDetailCommentCell = XMFindAppDetailCommentCell(frame: CGRect(x: 0, y: contentY, width: SCREEN_WIDTH, height: 50))
                commentView.setData(self.dataModel.comments[i])
                self.centerView.addSubview(commentView)
                contentY += commentView.height
            }
        } else {
            commentY = self.contentSize.height-UI_MARGIN_10
        }
        
    //设置contentsize
        self.centerView.height = contentY
        self.contentSize = CGSize(width: 0, height: contentY)
    }
    
    /**
     *  设置评论数据
     */
    func setCommentData(_ comments : Array<XMFindAppCommentModel>) {
        if comments.count != 0 {
            // 添加评论
            for i in 0..<comments.count {
                let commentView : XMFindAppDetailCommentCell = XMFindAppDetailCommentCell(frame: CGRect(x: 0, y: contentY, width: SCREEN_WIDTH, height: 50))
                commentView.setData(comments[i])
                self.centerView.addSubview(commentView)
                contentY += commentView.height
            }
        }
        //设置contentsize
        self.centerView.height = contentY
        self.contentSize = CGSize(width: 0, height: contentY)
    }
    
    //MARK: - Private Methods
    // 用户名头像
    fileprivate func createUserImgView() -> UIImageView {
        let userImgView : UIImageView = UIImageView()
        userImgView.layer.cornerRadius = 18
        userImgView.layer.borderColor = UIColor.lightGray.cgColor
        userImgView.layer.borderWidth = 1
        userImgView.layer.masksToBounds = true
        self.centerView.addSubview(userImgView)
        return userImgView
    }
    
    // 用户详情
    fileprivate func createUserSubTitleLabel() -> UILabel {
        let userDetailLabel : UILabel = UILabel()
        userDetailLabel.textAlignment = .right
        userDetailLabel.font = UI_FONT_10
        userDetailLabel.textColor = UIColor.lightGray
        self.centerView.addSubview(userDetailLabel)
        return userDetailLabel
    }
    fileprivate func createImgView() -> UIImageView {
        let imgView : UIImageView = UIImageView()
        imgView.layer.cornerRadius = 3
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        imgView.layer.borderWidth = 0.5
        imgView.contentMode = .scaleAspectFit
        imgView.center.x = self.centerView.center.x
        return imgView
    }
    
    fileprivate func createTitleView(_ title : String) -> UILabel {
        let label : UILabel = UILabel()
        label.font = UI_FONT_16
        label.text = title
        label.textColor = UIColor.black
        self.centerView.addSubview(label)
        return label
    }
    
    fileprivate func createTitleSeparatLine() -> UIView {
        let line : UIView = UIView()
        line.backgroundColor = UIColor.lightGray
        self.centerView.addSubview(line)
        return line
    }
    
    //MARK：-Getter or Setter
    fileprivate var contentY : CGFloat = 0
    fileprivate var commentY : CGFloat = 0
    // 内容
    fileprivate lazy var centerView : UIView = {
        let centerView = UIView(frame: self.bounds)
        return centerView
    }()
    // appIcon
    fileprivate lazy var appIconView : UIImageView = {
        let appIconView : UIImageView = UIImageView()
        appIconView.layer.cornerRadius = 10
        return appIconView
    }()
    // appName
    fileprivate lazy var appNameLabel : UILabel = {
        let appNameLabel : UILabel = UILabel()
        appNameLabel.font = UI_FONT_18
        appNameLabel.textColor = UIColor.black
        return appNameLabel
    }()
    
    fileprivate lazy var contentLabel : YYLabel = {
        var contentLabel : YYLabel = YYLabel()
        contentLabel.font = UI_FONT_16
        contentLabel.textColor = UIColor.darkGray
        contentLabel.numberOfLines = 0
        return contentLabel
    }()

}
