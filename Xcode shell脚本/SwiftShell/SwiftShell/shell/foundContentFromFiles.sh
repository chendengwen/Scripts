#!/bin/sh

#  foundContentFromFiles.sh
#  SwiftScript
#
#  Created by Cary on 2018/12/23.
#  Copyright © 2018年 Cary. All rights reserved.

########################################################################
######## 检索 指定目录 下 指定文件名 内容是否包含 关键字 ，并返回当前行内容 ########

if [ $# -ne 4 ]
then
    echo "Usage:"
    echo "e.g. :./foundContentFromFiles searchFileDir searchFileName searchContent resultFile"
    exit
fi

searchFileDir = $1
searchFileName = $2
searchContent = $3
resultFile = $4

find $1 -iname $2 | xargs grep $3 >> $4
