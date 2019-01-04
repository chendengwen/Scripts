//
//  XMHomeViewController.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/11/8.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class XMHomeViewController: UIViewController, XMHomeHeaderViewDelegate,UICollectionViewDataSource,XMHomeBottomCollectViewDelegate,UICollectionViewDelegate {
    // 页数
    fileprivate var page : Int = 1
    // viewModel对象
    fileprivate var viewModel : XMHomeViewModel!
    // 上一个index
    fileprivate var lastIndex : IndexPath?
    // 当前index
    fileprivate var index : Int! {
        willSet {
            self.index = newValue
        }
        
        didSet {
            guard self.viewModel.dataSource.count > 0 else {
                return
            }
            // 获取模型
            let model : XMHomeDataModel = self.viewModel.dataSource[index]
            // 设置header模型
            self.headerView.homeModel = model
            // 设置背景的动画
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.view.backgroundColor = UIColor.colorWithHexString(stringToConvert: model.recommanded_background_color!)
            })
        }
    }
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        NotificationCenter.default.addObserver(self, selector: #selector(XMHomeViewController.errorBtnDidClick), name: NSNotification.Name(rawValue: NOTIFY_ERRORBTNCLICK), object: nil)
        // 初始化界面
        self.view.backgroundColor = UI_COLOR_APPNORMAL
        // 添加头部view
        self.view.addSubview(headerView)
        // 添加中间collection
        self.view.addSubview(centerCollectView)
        // 添加底部collection
        self.view.addSubview(bottomCollectView)
        
        // 获取viewModel
        viewModel = XMHomeViewModel(regiHeaderView: headerView, centerView: centerCollectView, bottomView: bottomCollectView)
        // 获取数据
        self.centerCollectView.headerViewPullToRefresh(.xmRefreshDirectionHorizontal, callback: { [unowned self]() -> Void in
            self.page = 1
            self.viewModel.getData(self.page, successCallBack: { (dataSoure) -> Void in
                // 默认选中0
                self.lastIndex = nil
                self.index = 0
                self.bottomCollectView.setContentOffset(CGPoint.zero, animated: false)
                self.scrollViewDidEndDecelerating(self.centerCollectView)
                
                }, errorCallBack: { (error) -> Void in
                    // 显示网络错误按钮
//                    self.showNetWorkErrorView()
            })
        })
        
        // 加载更多
        self.centerCollectView.footerViewPullToRefresh (.xmRefreshDirectionHorizontal, callback:{ [unowned self]() -> Void in
            self.page += 1

            self.viewModel.getData(self.page, successCallBack: { (dataSoure) -> Void in
                // 默认选中0
                self.lastIndex = nil
                self.index = dataSoure.count-10
                self.scrollViewDidEndDecelerating(self.centerCollectView)
                }, errorCallBack: { (error) -> Void in
                    self.centerCollectView.setContentOffset(CGPoint(x: self.centerCollectView.contentSize.width-SCREEN_WIDTH, y: 0), animated: false)
            })
        })
        
        // 首次加载时中间显示加载框
        self.showProgress()
        self.viewModel.getData(self.page, successCallBack: { (dataSoure) -> Void in
            
            // 默认选中0
            self.lastIndex = nil
            self.index = 0
            self.bottomCollectView.setContentOffset(CGPoint.zero, animated: false)
            self.scrollViewDidEndDecelerating(self.centerCollectView)
            
            self.hiddenProgress()
            }) { (error) -> Void in
                // 显示网络错误按钮
                self.showNetWorkErrorView()
                self.hiddenProgress()
        }
        // 适配屏幕
        self.setupLayout()
//        self.centerCollectView.headerViewBeginRefreshing()
    }
    
    //MARK: - scrollerDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 100 {
            let index : Int = Int((scrollView.contentOffset.x + 0.5*scrollView.width) / scrollView.width)
            if index > self.viewModel.dataSource.count - 1 {
                self.index = self.viewModel.dataSource.count - 1
            } else {
                self.index = index
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == 100 {
            // 设置底部动画
            self.bottomAnimation(IndexPath(row: index, section: 0))
            // 发送通知改变侧滑菜单的颜色
            let model : XMHomeDataModel = self.viewModel.dataSource[index]
            let noti : Notification = Notification(name: Notification.Name(rawValue: NOTIFY_SETUPBG), object: model.recommanded_background_color!)
            NotificationCenter.default.post(noti)
        }
    }
    
    // MARK: - UICollection Delegate 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model : XMHomeDataModel = self.viewModel.dataSource[indexPath.row]
        if collectionView.tag == 100 {
        
            let cell : XMHomeCenterItemView = collectionView.dequeueReusableCell(withReuseIdentifier: "XMHomeCenterItemViewID", for: indexPath) as! XMHomeCenterItemView
            cell.homeModel = model
            return cell
        } else {
            let cell : XMHomeBottomItemView = collectionView.dequeueReusableCell(withReuseIdentifier: "XMHomeBottomItemViewID", for: indexPath) as! XMHomeBottomItemView
            cell.y = 50
            cell.iconUrl = model.icon_image

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model : XMHomeDataModel = self.viewModel.dataSource[indexPath.row]
        let detailController = XMHomeDetailController(model: model)
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    //MARK: -custom Delegate
    func homeHeaderViewMoveToFirstDidClick(_ headerView: XMHomeHeaderView, moveToFirstBtn: UIButton) {
        centerCollectView.setContentOffset(CGPoint.zero, animated: false)
        bottomCollectView.setContentOffset(CGPoint.zero, animated: false)
        self.index = 0
        self.scrollViewDidEndDecelerating(self.centerCollectView)
    }
    func homeHeaderViewMenuDidClick(_ header: XMHomeHeaderView, menuBtn: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_SHOWMENU), object: nil)
    }
  
    func homeBottomCollectView(_ bottomView: UICollectionView, touchIndexDidChangeWithIndexPath indexPath: IndexPath?, cellArrayCount: Int) {
        centerCollectView.scrollToItem(at: indexPath!, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        self.index = indexPath?.row
        // 执行底部横向动画
        let cell : UICollectionViewCell? = self.bottomCollectView.cellForItem(at: indexPath!)
        // 如果当前不够8个item就不让他滚动
        self.bottomHorizontalAnimation(cell!, indexPath: indexPath!)
        // 发送通知改变侧滑菜单的颜色
        let model : XMHomeDataModel = self.viewModel.dataSource[index]
        let noti : Notification = Notification(name: Notification.Name(rawValue: NOTIFY_SETUPBG), object: model.recommanded_background_color!)
        NotificationCenter.default.post(noti)
        self.lastIndex = indexPath
    }
    
    // MARK: - Event OR Action
    func errorBtnDidClick() {
        self.centerCollectView.headerViewBeginRefreshing()
    }
    
    //MARK: - private methods
    // 底部标签动画
    fileprivate func bottomAnimation (_ indexPath : IndexPath) {
        if self.lastIndex?.row == indexPath.row {
            return
        }

        var cell : UICollectionViewCell? = self.bottomCollectView.cellForItem(at: indexPath)
        
        if cell == nil {
            self.bottomCollectView.layoutIfNeeded()
            cell = self.bottomCollectView.cellForItem(at: indexPath)
        }
        
        if cell != nil {
            // 底部横向动画
            self.bottomHorizontalAnimation(cell!, indexPath: indexPath)
            // 底部纵向动画
            self.bottomVertical(cell!)
            
            self.lastIndex = indexPath
        }
    }
    // 横向动画
    fileprivate func bottomHorizontalAnimation(_ cell : UICollectionViewCell, indexPath:IndexPath) {
        guard self.viewModel.dataSource.count > 8 else {
            return
        }
        
        if cell.x < SCREEN_WIDTH*0.6 {
            self.bottomCollectView.setContentOffset(CGPoint.zero, animated: true)
        } else {
            var newX : CGFloat = 0
            // 判断下一个还是上一个
            if self.lastIndex?.row < indexPath.row {
                // 下一个
                newX = self.bottomCollectView.contentOffset.x + cell.width + 2
            } else  {
                // 上一个
                newX = self.bottomCollectView.contentOffset.x - cell.width - 2
            }
            self.bottomCollectView.setContentOffset(CGPoint(x: newX, y: 0), animated: true)
        }
    }
    // 纵向动画
    fileprivate func bottomVertical(_ cell : UICollectionViewCell) {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            cell.y = 10
            }, completion: { (finished) -> Void in
                UIView.animate(withDuration: 0.05, animations: { () -> Void in
                    cell.y = 15
                })
        }) 
        
        if let _ = self.lastIndex {
            let lastBottomView : UICollectionViewCell? = self.bottomCollectView.cellForItem(at: self.lastIndex!)
            if lastBottomView != nil {
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    lastBottomView!.y = 60
                    }, completion: { (finished) -> Void in
                        UIView.animate(withDuration: 0.05, animations: { () -> Void in
                            lastBottomView!.y = 50
                        })
                }) 
            }
        }
    }
    
    //MARK: - getter or setter
    // 头部headerview
    fileprivate lazy var headerView : XMHomeHeaderView = {
        let headerView : XMHomeHeaderView = XMHomeHeaderView.headerView()
        headerView.delegate = self
//        headerView.frame = CGRectMake(0, 20, SCREEN_WIDTH, headerView.height)
        return headerView
    }()
    
    // 中间collectionview
    fileprivate lazy var centerCollectView : UICollectionView = {
        let collectLayout : XMHomeCenterFlowLayout = XMHomeCenterFlowLayout()
        let collectView : UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 70, width: SCREEN_WIDTH, height: 420), collectionViewLayout: collectLayout)
        collectView.delegate = self
        collectView.dataSource = self
        collectView.showsHorizontalScrollIndicator = false
        collectView.isPagingEnabled = true
        
        collectView.register(UINib(nibName: "XMHomeCenterItemView", bundle: nil), forCellWithReuseIdentifier: "XMHomeCenterItemViewID")
        collectView.backgroundColor = UIColor.clear
        collectView.tag = 100
        return collectView
    }()
    
    // 底部collectionView
    fileprivate lazy var bottomCollectView : XMHomeBottomCollectView = {
        let collectionLayout : XMHomeBottomFlowLayout = XMHomeBottomFlowLayout()
        let collectView : XMHomeBottomCollectView = XMHomeBottomCollectView(frame: CGRect(x: 0, y: SCREEN_HEIGHT-60, width: SCREEN_WIDTH, height: 60), collectionViewLayout: collectionLayout)
        collectView.bottomViewDelegate = self
        collectView.delegate = self
        collectView.dataSource = self
        return collectView
    }()
    
    // MARK: - 屏幕适配
    fileprivate func setupLayout() {
        headerView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_topMargin).offset(20)
            make.height.equalTo(SCREEN_HEIGHT*50/IPHONE5_HEIGHT)
            make.left.right.equalTo(self.view)
        }
        
        bottomCollectView.snp_makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(SCREEN_HEIGHT*60/IPHONE5_HEIGHT)
        }
        
        centerCollectView.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(self.view)
            make.top.equalTo(headerView).offset(headerView.height)
            make.height.equalTo(SCREEN_HEIGHT*420/IPHONE5_HEIGHT)
        }
    }
    

}
