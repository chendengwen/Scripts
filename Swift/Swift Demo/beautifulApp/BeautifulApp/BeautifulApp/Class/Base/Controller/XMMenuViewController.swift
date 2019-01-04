//
//  XMMenuViewController.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/11/16.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit
enum MenuViewControllerType {
    case menuViewControllerTypeHome
    case menuViewControllerTypeFindApp
}
class XMMenuViewController: UIViewController {
    fileprivate let menuWith : CGFloat = 0.8*SCREEN_WIDTH
    fileprivate let animationDuration = 0.3
    /// 中间控制器
    fileprivate var centerController : XMBaseNavController!
    fileprivate var homeController : XMHomeViewController?
    fileprivate var findAppController : XMFindAppController?
    /// 左边menu控制器
    fileprivate var leftController : UIViewController!
    /// 按钮覆盖层最大值
//    private var coverMaxAlpha : CGFloat = 0.02
    fileprivate weak var cover : UIWindow!
    // 当前控制器
    fileprivate var currentController : UIViewController?
    var type : MenuViewControllerType! = .menuViewControllerTypeHome {
        willSet {
            self.type = newValue
        }
        
        didSet {
            // 首页
            if type == .menuViewControllerTypeHome {
                // 如果当前控制器不是homecontroller才继续执行
                guard !(self.currentController is XMHomeViewController) else {
                    self.leftMenuHiddenAnimate()
                    return
                }
                
                self.currentController!.view.removeFromSuperview()
                self.currentController?.removeFromParentViewController()
                self.currentController = nil
                
                if self.homeController == nil {
                    self.homeController = XMHomeViewController()
                }
                
                self.centerController.addChildViewController(self.homeController!)
                self.homeController!.view.frame = self.view.bounds
                self.centerController!.view.x = self.menuWith
                self.currentController = homeController
               
                
            } else if type == .menuViewControllerTypeFindApp {
                // 如果当前控制器是findAppcontroller就退出
                guard !(self.currentController is XMFindAppController) else {
                    self.leftMenuHiddenAnimate()
                    return
                }
                
                self.currentController?.view.removeFromSuperview()
                self.currentController?.removeFromParentViewController()
                self.currentController = nil
                
                if findAppController == nil {
                    findAppController = XMFindAppController()
                }
                
                self.centerController.addChildViewController(findAppController!)
                self.findAppController!.view.frame = self.view.bounds
                self.centerController!.view.x = self.menuWith
                self.currentController = findAppController
            }
            self.centerController.view.addSubview(self.currentController!.view)
            self.leftMenuHiddenAnimate()
          
        }
    }
    
    // MARK:- 生命周期 ============================

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 添加通知。当点击菜单按钮时
        NotificationCenter.default.addObserver(self, selector: #selector(XMMenuViewController.leftMenuShowAnimate), name: NSNotification.Name(rawValue: NOTIFY_SHOWMENU), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(XMMenuViewController.leftMenuHiddenAnimate), name: NSNotification.Name(rawValue: NOTIFY_HIDDEMENU), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(XMMenuViewController.leftMenuSetupBackColor(_:)), name: NSNotification.Name(rawValue: NOTIFY_SETUPBG), object: nil)
        // 设置中间控制器
        NotificationCenter.default.addObserver(self, selector: #selector(XMMenuViewController.leftMenuSetupCenterView(_:)), name: NSNotification.Name(rawValue: NOTIFY_SETUPCENTERVIEW), object: nil)
        
        self.view.bringSubview(toFront: self.centerController.view)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    /**
     初始化菜单控制器
     
     - parameter centerController: 中间的控制器
     - parameter leftController:   侧滑菜单的控制器
     
     - returns: <#return value description#>
     */
    convenience init(centerController : XMBaseNavController, leftController : UIViewController) {
        self.init(nibName:nil,bundle:nil)
        self.view.backgroundColor = UI_COLOR_APPNORMAL
        
        self.centerController = centerController
        self.homeController = centerController.viewControllers.first as? XMHomeViewController
        self.leftController = leftController
        // 初始化左边的控制器
        self.addLeftController()
        // 初始化中间的控制器
        self.addCenterController()
        // 添加覆盖层
        self.addCover()
        // 添加手势
        let leftPan : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(XMMenuViewController.leftMenuDidDrag(_:)))
        self.leftController.view.addGestureRecognizer(leftPan)

    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    //MARK:私有方法 ========================
    
    /**
    初始化中间控制器
    添加中间的控制器
    */
    fileprivate func addCenterController () {
        // 默认选中homecontroller
        self.homeController!.view.frame = self.view.bounds
        self.centerController.addChildViewController(self.homeController!)
        self.centerController.view.addSubview((self.homeController?.view)!)
        
        self.view.addSubview(self.centerController!.view)
        self.addChildViewController(self.centerController!)
        self.currentController = self.homeController
    }
    
    /**
     初始化左边菜单控制器
     添加左边的控制器
     */
    fileprivate func addLeftController () {
        self.leftController.view.frame = CGRect(x: 0, y: 0, width: menuWith, height: SCREEN_HEIGHT)
        self.leftController.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.view.addSubview(self.leftController.view)
        self.addChildViewController(self.leftController)
    }
    
    /**
     添加覆盖层按钮
     */
    fileprivate func addCover(){
        let cover : UIWindow = UIWindow(frame: centerController!.view.frame)
        // 拖拽覆盖层事件
        let pan : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(XMMenuViewController.leftMenuDidDrag(_:)))
        cover.backgroundColor = UIColor(red: 254/255.0, green: 254/255.0, blue: 254/255.0, alpha: 0.02)
        cover.addGestureRecognizer(pan)
        self.cover = cover
        self.centerController!.view.addSubview(cover)
        // 点击覆盖层事件
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(XMMenuViewController.leftMenuHiddenAnimate))
        cover.addGestureRecognizer(tap)
        
        self.view.bringSubview(toFront: cover)
    }

    /**
     在中间控制器手势操作是调用
     
     - parameter pan:
     */
    func leftMenuDidDrag(_ pan : UIPanGestureRecognizer) {
        // 拿到手指在屏幕中的位置
        let point = pan.translation(in: pan.view)
        
        // 如果手指取消了或者结束
        if (pan.state == .cancelled || pan.state == .ended) {
            self.leftMenuHiddenAnimate()
        } else {
            // 正在拖拽的状态
            
            // 让左边控制器的x值跟手拖动
            self.centerController!.view.x += point.x
            pan.setTranslation(CGPoint.zero, in: self.centerController.view)
            // 如果拖动x的值小于0 就不让他拖了
            if self.centerController!.view.x > menuWith {
                self.centerController?.view.x = menuWith
                self.cover.isHidden = false
            } else if self.centerController!.view.x <= 0 {
                self.centerController?.view.x = 0
                self.cover.isHidden = true
            }
        }
    }
    
    func coverButtonDidPan(_ pan : UIPanGestureRecognizer) {
        
    }
    
    //MARK: 给外部调用 =========================
    /**
    显示左边菜单动画
    */
    func leftMenuShowAnimate() {
        UIView.animate(withDuration: animationDuration, animations: { [unowned self]() -> Void in
            self.centerController!.view.x = self.menuWith
            self.leftController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.cover.isHidden = false
        })
    }
    
    /**
     *  隐藏左边菜单动画
     */
    func leftMenuHiddenAnimate () {
        
        UIView.animate(withDuration: animationDuration, animations: { [unowned self]() -> Void in
            self.centerController!.view.x = 0
            self.cover.isHidden = true
            }, completion: { (finish) -> Void in
                self.leftController.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) 
    }
    
    func leftMenuSetupBackColor(_ notify : Notification) {
        let bg : String = notify.object as! String
        self.view.backgroundColor = UIColor.colorWithHexString(stringToConvert: bg)
    }
    
    func leftMenuSetupCenterView(_ notify : Notification) {
        let type : String = notify.object as! String
        switch type {
            case NOTIFY_OBJ_TODAY,NOTIFY_OBJ_RECOMMEND,NOTIFY_OBJ_ARTICLE :
                self.type = .menuViewControllerTypeHome
            case NOTIFY_OBJ_FINDAPP:
                UIView.animate(withDuration: animationDuration, animations: { () -> Void in
                    self.view.backgroundColor = UI_COLOR_APPNORMAL
                })
                self.type = .menuViewControllerTypeFindApp
        default:
            self.type = .menuViewControllerTypeHome
            
        }
    }
    
}
