#!/bin/sh

#  unzipFiles.sh
#  SwiftScript
#
#  Created by Cary on 2018/12/23.
#  Copyright © 2018年 Cary. All rights reserved.

########################################
######## 批量解压指定目录下的zip文件 ########

if [ $# -ne 1]; then
    echho "please input:./unzipFiles filedir"
    exit
fi

#加上双引号才能支持文件路径中带有空格的路径名(/tmp/test 2/),使用./changefile.sh /tmp/test\ 2
file_path="$1"

if [ -d "$file_path" ] && cd "$file_path"
then
    for filename in `ls *.zip`
        do
            #解压文件
            unzip -o $file_path -d ${file_path}/${filename%.*}
        done
fi

#显示执行时间
echo "finished---spend time:$SECONDS"
