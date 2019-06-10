#!/bin/bash

#  autoSign.sh
#  
#
#  Created by mac on 2018/12/11.
#

result=$(netstat -na | grep 4723 | wc -l)
if [ $result -gt 0 ];then
    echo '关闭堵塞关机的程序。。。'
    #关闭iTunes应用，它会阻止关机
    killall iTunes
    #关闭Appium应用
    lsof -i  | grep 4723 | grep -v grep | awk '{print $2}' | xargs kill -2

fi


