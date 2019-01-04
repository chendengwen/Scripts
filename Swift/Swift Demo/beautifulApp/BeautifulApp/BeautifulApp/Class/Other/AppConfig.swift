//
//  AppConfig.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/11/9.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit
let IPHONE5_WIDTH : CGFloat = 320
let IPHONE5_HEIGHT : CGFloat = 568
let SCREEN_WIDTH : CGFloat = UIScreen.main.bounds.width
let SCREEN_HEIGHT : CGFloat = UIScreen.main.bounds.height
/// 网络超时时间
let NETWORK_TIMEOUT: TimeInterval = 15

// MARK: - 颜色
// 默认背景色
let UI_COLOR_APPNORMAL : UIColor = UIColor(red: 54/255.0, green: 142/255.0, blue: 198/155.0, alpha: 1)
let UI_COLOR_BORDER : UIColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
// MARK: - 字体
let UI_FONT_20 = UIFont.systemFont(ofSize: 20)
let UI_FONT_18 = UIFont.systemFont(ofSize: 18)
let UI_FONT_16 = UIFont.systemFont(ofSize: 16)
let UI_FONT_14 = UIFont.systemFont(ofSize: 14)
let UI_FONT_12 = UIFont.systemFont(ofSize: 12)
let UI_FONT_10 = UIFont.systemFont(ofSize: 10)

// MARK: - MARGIN
let UI_MARGIN_5 : CGFloat = 5
let UI_MARGIN_10 : CGFloat = 10
let UI_MARGIN_15 : CGFloat = 15
let UI_MARGIN_20 : CGFloat = 20
// MARK: - 通知
let NOTIFY_SHOWMENU : String = "NOTIFY_SHOWMENU"
let NOTIFY_HIDDEMENU : String = "NOTIFY_HIDDEMENU"
let NOTIFY_SETUPBG : String = "NOTIFY_SETUPBG"
let NOTIFY_ERRORBTNCLICK : String = "NOTIFY_ERRORBTNCLICK"
// 设置homeview类型 - 用于请求api
let NOTIFY_SETUPHOMEVIEWTYPE : String = "NOTIFY_SETUPHOMEVIEWTYPE"
let NOTIFY_OBJ_TODAY : String = "homeViewTodayType"
let NOTIFY_OBJ_FINDAPP : String = "homeViewFindAppType"
let NOTIFY_OBJ_RECOMMEND : String = "homeViewRecommendType"
let NOTIFY_OBJ_ARTICLE : String = "homeViewArticleViewType"
// 设置menu centreview 类型 - 用于切换centerView
let NOTIFY_SETUPCENTERVIEW : String = "NOTIFY_SETUPCENTERVIEW"
