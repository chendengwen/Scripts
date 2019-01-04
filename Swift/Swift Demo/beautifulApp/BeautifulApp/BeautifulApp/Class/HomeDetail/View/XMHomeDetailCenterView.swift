//
//  XMHomeDetailCenterView.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/11/19.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

protocol XMHomeDetailCenterViewDelegate  {
    func homeDetailCenterView(_ centerView : XMHomeDetailCenterView ,returnButtonDidClick returnButton : UIButton)
    func homeDetailCenterViewBottomShareDidClick(_ centerView : XMHomeDetailCenterView)
    
}

class XMHomeDetailCenterView: UIScrollView {
    // 记录当前高度
    fileprivate var contentY : CGFloat = 0
    // MARK:-DATA
    // 代理
    var centerDelegate : XMHomeDetailCenterViewDelegate?
    var model : XMHomeDataModel! {
        willSet {
            self.model = newValue
        }
        
        didSet {
            self.headerImgView.xm_setBlurImageWithURL(URL(string: model.cover_image!), placeholderImage: UIImage(named: "home_logo_pressed"))
            // 图标
            self.appIconView.xm_setBlurImageWithURL(URL(string: model.icon_image!), placeholderImage: UIImage(named: "ic_launcher"))
            self.appTitleLabel.text = model.title!
            self.appDetailLabel.text = model.sub_title!
            // 添加其他控件
            
            self.setupOtherData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 添加centerView
        centerView.frame = self.bounds;
        self.addSubview(centerView)
        // 顶部图片
        headerImgView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 170);
        self.centerView.addSubview(headerImgView)
        // appIcon
        appIconView.frame = CGRect(x: UI_MARGIN_20, y: headerImgView.frame.maxY + UI_MARGIN_20, width: 50, height: 50)
        self.centerView.addSubview(appIconView)
        // app大标题
        let appTitleLabelX : CGFloat = appIconView.frame.maxX+UI_MARGIN_20;
        let appTitleLabelW : CGFloat = SCREEN_WIDTH-UI_MARGIN_20-appTitleLabelX;
        appTitleLabel.frame = CGRect(x: appTitleLabelX, y: headerImgView.frame.maxY+25, width: appTitleLabelW, height: 20)
        self.centerView.addSubview(appTitleLabel)
        // app详情
        appDetailLabel.frame = CGRect(x: appTitleLabelX, y: appTitleLabel.frame.maxY, width: appTitleLabelW, height: 20)
        self.centerView.addSubview(appDetailLabel)
        // appicon + toolbar高度
        contentY = headerImgView.height+UI_MARGIN_20+100
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK : -DataSource
    /**
    *  设置评论数据
    */
    func setCommentData(_ comments : Array<XMCommentsDataModel>) {
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
    
    //MARK:- private Methods
    fileprivate func setupOtherData() {
        // 计算文字高度，添加app描述文段
        let describeLabel = self.createPTitleLabel()
        self.centerView.addSubview(describeLabel)
        let descriSize = self.calculateTextHeight(model.digest!, label: describeLabel)
        describeLabel.frame = CGRect(x: UI_MARGIN_10, y: contentY + UI_MARGIN_10, width: SCREEN_WIDTH-2*UI_MARGIN_10, height: descriSize.height)
        contentY = describeLabel.frame.maxY + UI_MARGIN_20
        // 添加http文段
        let _ = XMLParserUtil(content: model.content!) { [unowned self](array) -> Void in
            // 拿到解析完的数组后添加控件
            for contentModel in array {
                
                if contentModel.contentType == XMLContentType.xmlContentTypeH2 {
                    // 标题
                    self.contentY += UI_MARGIN_10
                    let h2TitlLabel = self.createH2TitleLabel()
                    h2TitlLabel.text = contentModel.content
                    h2TitlLabel.frame = CGRect(x: UI_MARGIN_10, y: self.contentY, width: SCREEN_WIDTH-2*UI_MARGIN_10, height: 20)
                    self.centerView.addSubview(h2TitlLabel)
                    self.contentY += h2TitlLabel.height + UI_MARGIN_10
                } else if contentModel.contentType == XMLContentType.xmlContentTypeP {
                    // 描述
                    let pTitleLabel = self.createPTitleLabel()
                    pTitleLabel.frame = CGRect(x: UI_MARGIN_10, y: self.contentY, width: SCREEN_WIDTH-2*UI_MARGIN_10, height: 20)
                    let pTitleSize = self.calculateTextHeight(contentModel.content, label: pTitleLabel)
                    self.centerView.addSubview(pTitleLabel)
                    self.contentY += pTitleSize.height + UI_MARGIN_10
                } else if contentModel.contentType == XMLContentType.xmlContentTypeA {
                    // 点击下载
                    let aTitleBtn = self.createATitleButton()
                    aTitleBtn.frame = CGRect(x: UI_MARGIN_10, y: self.contentY, width: 60, height: 20)
                    self.centerView.addSubview(aTitleBtn)
                    self.contentY += aTitleBtn.height + UI_MARGIN_10
                } else if contentModel.contentType == XMLContentType.xmlContentTypeImg {
                    
                    // 根据url 获取图片高度
                    let size : CGSize = contentModel.content.getImageSizeWithURL()
                    // 获取 _ 的位置
                    let imgView : UIImageView = self.createImgView()
                    imgView.frame = CGRect(x: UI_MARGIN_10, y: self.contentY, width: size.width, height: size.height)
                    imgView.center.x = SCREEN_WIDTH*0.5
                    imgView.xm_setBlurImageWithURL(URL(string: contentModel.content), placeholderImage: UIImage(named: "home_logo_pressed"))
                    self.centerView.addSubview(imgView)
                    self.contentY += size.height + UI_MARGIN_10
                }
            }
        }

        
        // 分享view
        let shareView : XMHomeDetailShareView = XMHomeDetailShareView.shareView()
        shareView.frame = CGRect(x: UI_MARGIN_10, y: contentY, width: SCREEN_WIDTH-2*UI_MARGIN_10, height: shareView.height)
        shareView.centerViewDidClickWithBlock { [unowned self]() -> Void in
            self.centerDelegate?.homeDetailCenterViewBottomShareDidClick(self)
        }
        self.centerView.addSubview(shareView)
        contentY += shareView.height

        // 评论view
        if model.comments.count != 0 {
            let commentLabel = self.createTitleViwe("评论")
            commentLabel.frame = CGRect(x: UI_MARGIN_10, y: contentY+2*UI_MARGIN_10, width: 35, height: 20)
            contentY = commentLabel.frame.maxY+UI_MARGIN_10;
            // 分割线
            let sepLine = self.createTitleSeparatLine()
            sepLine.frame = CGRect(x: commentLabel.frame.maxX, y: commentLabel.center.y, width: 80, height: 0.5)
//
//            // 添加评论
//            for i in 0..<model.comments.count {
//                let commentView : XMFindAppDetailCommentCell = XMFindAppDetailCommentCell(frame: CGRectMake(0, contentY, SCREEN_WIDTH, 50))
//                commentView.setData(self.model.comments[i])
//                self.centerView.addSubview(commentView)
//                contentY += commentView.height
//            }
        }
        
        // 设置contentsize
        self.centerView.height = contentY
        self.contentSize = CGSize(width: 0, height: contentY)
    }
    // 根据文字计算高度
    fileprivate func calculateTextHeight (_ text : String, label : YYLabel) -> CGSize {
        // 设置文字样式
        let attributString : NSMutableAttributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        attributString.yy_font = UI_FONT_16
        attributString.yy_color = UIColor.darkGray
        attributString.addAttribute(NSParagraphStyleAttributeName , value: paragraphStyle, range: NSMakeRange(0, text.length))
        let textLayout = YYTextLayout(containerSize: CGSize(width: SCREEN_WIDTH-2*UI_MARGIN_10, height: CGFloat.greatestFiniteMagnitude), text: attributString)
        label.attributedText = attributString
        // 设置样式
        label.size = (textLayout?.textBoundingSize)!
        label.textLayout = textLayout
        
        return textLayout!.textBoundingSize
    }
    
    //MARK: - Public Method
    func updateHeaderView() {
        let HeaderHeight : CGFloat = headerImgView.height
        let HeaderCutAway: CGFloat = 170
        
        var headerRect = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: HeaderHeight)
        if self.contentOffset.y < 0 {
            headerRect.origin.y = self.contentOffset.y
            headerRect.size.height = -self.contentOffset.y + HeaderCutAway
            headerImgView.frame = headerRect
        }
    }
    
    //MARK: - Action Event

    //MARK: - getter or setter
    // 内容
    fileprivate lazy var centerView : UIView = {
        let centerView : UIView = UIView()
        return centerView
    }()
    
    // 顶部图片
    fileprivate lazy var headerImgView : UIImageView = {
        let headerImgView : UIImageView = UIImageView(image: UIImage(named: "home_logo_pressed"))
        headerImgView.contentMode = .scaleAspectFill
        return headerImgView
    }()
    
    // appIcon
    fileprivate lazy var appIconView : UIImageView = {
        let appIconView : UIImageView = UIImageView(image: UIImage(named: "ic_launcher"))
//        appIconView.contentMode = .ScaleAspectFit
        appIconView.layer.cornerRadius = UI_MARGIN_10
        appIconView.layer.masksToBounds = true
        return appIconView
    }()
    
    // app大标题
    fileprivate lazy var appTitleLabel : UILabel = {
        let appTitleLabel : UILabel = UILabel()
        appTitleLabel.font = UI_FONT_20
        appTitleLabel.textColor = UIColor.black
        return appTitleLabel
    }()
    
    // app 详情
    fileprivate lazy var appDetailLabel : UILabel = {
        let appDetailLabel : UILabel = UILabel()
        appDetailLabel.font = UI_FONT_14
        appDetailLabel.textColor = UIColor.darkGray
        return appDetailLabel
    }()
    
    fileprivate func createTitleViwe(_ title : String) -> UILabel {
        let label : UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
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
    // 标题(h2)
    fileprivate func createH2TitleLabel() -> UILabel {
        let h2TitleLabel = UILabel()
        h2TitleLabel.textColor = UIColor.black
        h2TitleLabel.font = UI_FONT_16
        return h2TitleLabel
    }
    
    // 描述(p)
    fileprivate func createPTitleLabel() -> YYLabel {
        let contentLabel : YYLabel = YYLabel()
        contentLabel.displaysAsynchronously = true
        contentLabel.font = UI_FONT_16
        contentLabel.textColor = UIColor.darkGray
        contentLabel.numberOfLines = 0
        return contentLabel
    }
    
    
    // 图片(Img)
    fileprivate func createImgView() -> UIImageView {
        let imgView : UIImageView = UIImageView()
        imgView.layer.cornerRadius = 3
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        imgView.layer.borderWidth = 0.5
        imgView.contentMode = .scaleAspectFit
        return imgView
    }
    
    // 下载(a) 
    fileprivate func createATitleButton() -> UIButton {
        let btn : UIButton = UIButton()
        btn.titleLabel?.textAlignment = NSTextAlignment.left
        btn.titleLabel?.font = UI_FONT_14
        btn.setTitle("点击下载", for: UIControlState())
        btn.setTitleColor(UI_COLOR_APPNORMAL, for: UIControlState())
        return btn
    }
}
