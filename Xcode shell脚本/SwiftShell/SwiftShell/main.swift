//
//  main.swift
//  SwiftScript
//
//  Created by Cary on 2018/12/23.
//  Copyright © 2018年 Cary. All rights reserved.
//

import Foundation
import Cocoa

// 要调用shell脚本只能使用绝对路径
class GetQCRLog: NSObject {
    let homePath = NSHomeDirectory() + "/shell/"  // "/Users/dengwenchen/shell/"
    // 命令行工程获取的路径都是在电脑上的绝对路径
//    let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] // "/Users/dengwenchen/Document"
    
    override init() {
        super.init()
        
//        searchAndDownLogsFromQCR()
//        unzipDownFiles()
//        foundContentFromFiles()
        
        test()
    }
    
    /** 从QCR上批量下载指定 SNs 的logs */
    func searchAndDownLogsFromQCR() {
        let scriptPath = homePath + "/getQCRLog"
        let logPath = homePath + "/QCR_LOG"
        let snPath = homePath + "/sn.txt"
        let logPartName:String = "123.zip"
        execShellScript(scriptPath, logPath, snPath, logPartName)
    }
    
    /** 解压已下载的文件 */
    func unzipDownFiles(){
        let scriptPath = homePath + "/unzipFiles"
        let logPath = homePath + "/QCR_LOG"
        execShellScript(scriptPath, logPath)
    }
    
    /** 批量查找DCSD文件中内容 “STATION_IP”，并将结果保存在STATION_IP.txt */
    func foundContentFromFiles(){
        let scriptPath = homePath + "/foundContentFromFiles"
        let searchFileDir = homePath + "/QCR_LOG"
        let searchFileName = "DCSD.log"
        let searchContent = "STATION_IP"
        let resultFile = homePath + "STATION_IP.txt"
        execShellScript(scriptPath, searchFileDir, searchFileName, searchContent, resultFile)
    }
    
    /** Swift 调用任意参数个数Shell脚本
     *  arg0 : scriptPath // 第一个参数是脚本路径
     *  arg1 : ${1}     // 第二个参数是脚本参数1 （log存放路径）
     *  arg2 : ${2}     // 第三个参数是脚本参数2 （sn.txt 路径）
     *  arg3 : ${3}     // 第四个参数是脚本参数3 （log名称，如：SW-DOWNLOAD.zip）
     *  ...
     *  argn : ${n}
     */
    func execShellScript(_ members: String...){
        var index = 0
        var scriptPath:String!
        //  var logPath:String!
        
        var args:Array = [String]()
        for i in members{
            if index == 0{ // 第一个参数是脚本路径
                scriptPath = i
                index += 1
                continue
            }
            args.append(i)
            index += 1
        }
        print(args)
        
        let task = Process()
        task.launchPath = scriptPath
        task.arguments = args
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = String(data: data, encoding: String.Encoding.utf8)!
        
        print(output)
    }
    
    func test() {
//        let scriptPath = homePath + "shell/test/test01"
        let scriptPath = "/bin/pwd"
        execShellScript(scriptPath)
    }
    
}

print("Hello, World!")
GetQCRLog()
