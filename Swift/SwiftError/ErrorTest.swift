//
//  testfile.swift
//  UnitTestDemoTests
//
//  Created by Cary on 16/12/10.
//  Copyright © 2016年 rason. All rights reserved.
//

import Foundation


enum BookShelfError:Error {

    case NoEnoughSpace(required:Int)
    case OutOfBooks
}

class BookShelf: CustomStringConvertible {
    
    // 有一个好大的书架
    private let maximumBooks = 1000
    private(set) var books: Int = 0
    
    var description: String {
        return "书柜当前还有\(books)本书"
    }
    
    // 2
//    func purchaseBooks(count: Int) {
//        books += count
//        
//        if books > maximumBooks {
//            fatalError("你的书太多了，书柜已经放不下了")
//        }
//    }
    
    func purchaseBooks(count: Int) throws {
        if books + count > maximumBooks {
            let required = (books + count) - maximumBooks
            throw BookShelfError.NoEnoughSpace(required: required)
        }
        
        books += count
    }
    
    // 3
//    func lendBooks(count: Int) {
//        books -= count
//        
//        if books < 0 {
//            fatalError("你都没书了，还要借给谁?")
//        }
//    }
    
    func lendBooks(count: Int) throws {
        if count > books {
            throw BookShelfError.OutOfBooks
        }
        
        books -= count
    }
    
    
    
    // 对于一个可能抛出错误的方法，需要使用 try 关键字来调用它,由于要将错误再次抛出，所以同时使用了 throws 关键字来表明我们不准备处理这个错误。
    func starterShelf() throws -> BookShelf {
        let myShelf = BookShelf()
        try myShelf.purchaseBooks(count: 100)
        
        // 但是，由于我们知道书架最多能放 1000 本书，这里的调用是绝对不会出现异常的。对于这种情况，我们可以用 forced-try 表达式，语法形式是在 try 后面加上感叹号，即 try!，表明我们知道方法调用不会出现异常，可以对其进行强制调用，同时也就不再需要指定 throws 关键字
        // try! myShelf.purchaseBooks(100)
        
        return myShelf
    }
    
    func starterShelf2() throws {
        
        
        let shelf = try! starterShelf()
    
        do {
            try shelf.purchaseBooks(count: 5000)
        } catch BookShelfError.NoEnoughSpace(let required) {
            print("书柜满啦，新买的书放不下了。还差\(required)个空位，赶紧买个新书柜吧")
        }
    }
    
}
