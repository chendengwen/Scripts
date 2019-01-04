//
//  XMHomeBottomCollectView.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/11/20.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

protocol XMHomeBottomCollectViewDelegate {
    func homeBottomCollectView(_ bottomView : UICollectionView, touchIndexDidChangeWithIndexPath indexPath: IndexPath?,cellArrayCount : Int)
}

class XMHomeBottomCollectView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        // 注册item
        self.register(UINib(nibName: "XMHomeBottomItemView", bundle: nil), forCellWithReuseIdentifier: "XMHomeBottomItemViewID")
        self.isScrollEnabled = false
        self.backgroundColor = UIColor.clear
        self.showsHorizontalScrollIndicator = false
        self.tag = 101
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 获取显示的cell,保存cell的rect数组, 排序按cell的x从小到大
        var cellArray : Array<UICollectionViewCell> = Array()
        for cell in self.visibleCells {
            cellArray.append(cell)
        }
        cellArray.sort { (cell1, cell2) -> Bool in
            return cell1.x < cell2.x
        }
        self.cellArray = cellArray
        
        // 重新设置frame
        self.resetCellFrame(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 重新设置frame
        self.resetCellFrame(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIView.animate(withDuration: 0.2, delay: 0.5, options: [], animations: { () -> Void in
            for i in 0..<self.cellArray.count {
                let cell = self.cellArray[i]
                if cell != self.indexCell {
                    cell.y = 50
                } else {
                    cell.y = 15
                }
            }
            }, completion: nil)
        if self.indexCell == nil || self.lastCell == self.indexCell {
            return
        }
        self.lastCell = indexCell
        let indexPath : IndexPath? = self.indexPath(for: self.indexCell!)
        self.bottomViewDelegate?.homeBottomCollectView(self, touchIndexDidChangeWithIndexPath: indexPath, cellArrayCount: self.cellArray.count)
    }
    
    // 重新设置cell的frame
    fileprivate func resetCellFrame(_ touches : Set<UITouch>) {
        // 获取点击的位置
        let touch : UITouch = (touches as NSSet).anyObject() as! UITouch
        let clickPoint : CGPoint = touch.location(in: self)
        // 判断点在哪个cell
        for index in 0..<self.cellArray.count {
            let cell = self.cellArray[index]
            if CGRect(x: cell.x, y: 0, width: cell.width, height: cell.height).contains(clickPoint) {
                if self.indexCell == cell {
                    return
                }
                self.indexCell = cell
                // 重新设置cellframe
                UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: [], animations: { () -> Void in
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: { () -> Void in
                        for i in 0..<self.cellArray.count {
                            let cell = self.cellArray[i]
                            let gap = abs(CGFloat(i-index)*5)
                            cell.y = self.maxItemY+gap
                        }
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4, animations: { () -> Void in
                        for i in 0..<self.cellArray.count {
                            let cell = self.cellArray[i]
                            cell.y += 5
                        }
                    })
                    
                    }, completion: nil)
            }
        }
    }
    
    fileprivate var cellArray : Array<UICollectionViewCell>! ;
    fileprivate var maxItemY : CGFloat = 10;
    // 保存当前index
    fileprivate var indexCell : UICollectionViewCell?
    // 上一个index
    fileprivate var lastCell : UICollectionViewCell?
    var bottomViewDelegate : XMHomeBottomCollectViewDelegate?
}
