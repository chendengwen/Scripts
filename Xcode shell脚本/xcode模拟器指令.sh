#!/bin/sh

#  xcrun simctl 模拟器命令.sh
#  Open
#
#  Created by Cary on 2018/12/8.
#  Copyright © 2018年 Afer. All rights reserved.

{
XCode6 之后提供了xctool这个工具，可以做到这些事情：

启动一个模拟器
把app安装到启动好的模拟器上面
从模拟器上卸载指定的app
}

#1.启动运行模拟器：
xcrun instruments -w 'iPhone X'

#2.在已经启动好的模拟器中安装应用：
#2.1 如果某台设备正在运行，那么他的状态，就是booted
xcrun simctl install booted Calculator.app
#（这里要特别注意，是app，不是ipa 安装时需要提供的是APP的文件路径）
#2.2 真机安装：
#fruitstrap  -b  Calculator.app

#3.卸载APP的命令：
xcrun simctl uninstall booted com.yuchang.calculator
#（卸载时需要写的是bundle identifier）

{ simctl 常用命令
xcrun simctl list #列出所有可用的模拟器
xcrun simctl list devices ##列出正在运行的模拟器
xcrun simctl erase #清除模拟器的所有数据和设置

xcrun simctl boot #启动一个模拟器
xcrun simctl shutdown #关闭一个模拟器
xcrun simctl launch #打开一个应用
#xcrun simctl launch booted "com.kingsword.TuGeLe2016"
xcrun simctl terminate #关闭一个应用
#$ xcrun simctl terminate booted "com.kingsword.TuGeLe2016"
xcrun simctl appinfo booted "com.kingsword.TuGeLe2016" #获取应用信息

xcrun simctl openurl booted "https://www.sogou.com" #浏览网页(启动safiri)
xcrun simctl openurl booted "com.kingsword.tugele:" #同样可以通过URL Scheme方式打开一个app

xcrun simctl io booted screenshot "screen.png" #Xcode 8.2中增加了模拟器截图以及录制视频的功能
xcrun simctl io booted recordVideo "news.mov" #视频长度最长为30秒，录制过程通过Ctrl+C来提前结束录制

}


# idevice_id -l  获取已连接 Mac 的 iPhone 的 udid
