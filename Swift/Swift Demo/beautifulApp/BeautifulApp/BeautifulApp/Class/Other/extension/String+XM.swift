//
//  String+XM.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/11/10.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import Foundation

extension String {
    var length : Int {
        return self.characters.count
    }
    
    func getImageSizeWithURL() -> CGSize {
        // 获取 _ 的位置
        let firstIndex : NSRange = (self as NSString).range(of: "_")
        let imgType : [String] = [".JPG",".jpg",".JPEG",".jpeg",".PNG",".png",""]
        
        var currType = imgType.last
        var typeRange : NSRange!
        for type in imgType {
            typeRange = (self as NSString).range(of: type)
            if typeRange.location < 100 {
                currType = type
                break;
            }
        }
        var sizeString = self
        guard currType != "" else {
            print ("图片类型错误:\(self)")
            return CGSize.zero
        }
        
        sizeString = (self as NSString).substring(with: NSMakeRange(firstIndex.location+1, typeRange.location - firstIndex.location-1))
        
        let size = sizeString.components(separatedBy: "x")
        let widthFormatter = NumberFormatter().number(from: size.first!)
        let heightFormatter = NumberFormatter().number(from: size.last!)
        
        guard let _ = widthFormatter else {
            return CGSize.zero
        }
        guard let _ = heightFormatter else {
            return CGSize.zero
        }
        
        var width = CGFloat(widthFormatter!)
        var height = CGFloat(heightFormatter!)
        if width > SCREEN_WIDTH - 20 {
            width = SCREEN_WIDTH - 20
            height = width * height / CGFloat(widthFormatter!)
        }
        
        return CGSize(width: CGFloat(width), height: CGFloat(height))
        
    }
}
