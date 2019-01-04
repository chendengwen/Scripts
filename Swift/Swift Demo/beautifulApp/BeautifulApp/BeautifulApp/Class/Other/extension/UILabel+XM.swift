//
//  UILabel+XM.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/11/8.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

extension UILabel  {

    func textLeftTopAlign(_ width : CGFloat, font : UIFont) {
        let style : NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let attributes = [NSFontAttributeName : font, NSParagraphStyleAttributeName : style.copy()]
        let labelSize = (self.text! as NSString).boundingRect(with: CGSize(width: width, height: CGFloat(999)), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        let rect = CGRect(x: self.x, y: self.y, width: labelSize.width, height: labelSize.height)
        self.frame = rect
    }

}
//- (void) textLeftTopAlign
//7
//    {
//        8
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//        9
//        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//        10
//        
//        11
//        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.f], NSParagraphStyleAttributeName:paragraphStyle.copy};
//        12
//        
//        13
//        CGSize labelSize = [self.text boundingRectWithSize:CGSizeMake(207, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//        14
//        
//        15
//        CGRect dateFrame =CGRectMake(2, 140, CGRectGetWidth(self.frame)-5, labelSize.height);
//        16
//        self.frame = dateFrame;
//        17
//}
