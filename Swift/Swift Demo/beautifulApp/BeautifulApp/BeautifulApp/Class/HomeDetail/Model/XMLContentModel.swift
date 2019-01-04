//
//  XMLContentModel.swift
//  BeautifulApp
//
//  Created by 梁亦明 on 15/12/6.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit
enum XMLContentType {
    case xmlContentTypeP
    case xmlContentTypeH2
    case xmlContentTypeA
    case xmlContentTypeImg
    case xmlContentTypeUnknow
}

class XMLContentModel: NSObject {
    var contentType : XMLContentType!
    var content : String!
}
