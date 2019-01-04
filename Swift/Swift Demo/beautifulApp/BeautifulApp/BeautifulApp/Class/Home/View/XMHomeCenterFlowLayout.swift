//
//  XMHomeCenterFlowLayout.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/11/17.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

class XMHomeCenterFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        self.itemSize = CGSize(width: SCREEN_WIDTH-2*UI_MARGIN_5, height: SCREEN_HEIGHT*420/IPHONE5_HEIGHT)
        self.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    }
}
