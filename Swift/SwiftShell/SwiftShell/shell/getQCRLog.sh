#!/bin/sh

#  getQCRLog.sh
#  SwiftScript
#
#  Created by Cary on 2018/12/23.
#  Copyright © 2018年 Cary. All rights reserved.

########################################
######## 从服务器批量下载log ##############

echo "开始批量下载脚本"

if [ $# -ne 3 ]; then
    echo "Usage:"
    echo "e.g. :./getQCRLog_1117 Log_Out_Put SN_File Targit_log"
    exit
fi

WOSID=""
USER_NAME="＊＊＊"
PASS_WORD="＊＊＊"
Original_ip="http://10.172.5.131"
Father_url="http://10.172.5.131/cgi-bin/WebObjects/QCR"
Referer_url="${Father_url}"
new_ip=""
temp_file="/tmp/1.txt"
User_Agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:45.0) Gecko/20100101 Firefox/45.0"
Accept_type="text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
Accept_lang="zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3"
Log_file="/tmp/result.csv"
Log_Out_Put=$1
echo "Log_Out_Put = ${Log_Out_Put}"
SN_File=$2
echo "SN_File = ${SN_File}"
## Log_Out_Put="./QCR_LOG"
Targit_log=$3

echo "Targit_log = ${Targit_log}"

if [ -e ${temp_file} ]; then
rm "${temp_file}"
echo "rm temp file"
fi

##### to get wosid / version / username / password
#### input username and password
#curl命令通过-H '...' -H '...'这样增加多个头
curl "${Father_url}" -H 'Host: 10.172.5.131' -H "User-Agent: ${User_Agent}" -H "Accept: ${Accept_type}" -H "Accept-Language: ${Accept_lang}" --compressed -H 'Connection: keep-alive' > ${temp_file}

#### 解析上面获取的temp_file文件内的信息，读取出button_name、new_ip、WOSID 三个参数
# `` 倒引号。命令替换。在倒引号内部的shell命令首先被执行，其结果输出代替用倒引号括起来的文本，不过特殊字符会被shell解释。
button_name="`cat "${temp_file}" | grep -i "input name" | awk -F'"' '{printf $10}'`"
new_ip="`cat "${temp_file}" | grep -i 'method="post"' | awk -F'"' '{printf $6}'`"
WOSID="`cat "${temp_file}" | grep -i 'method="post"' | awk -F'"' '{printf $6}' | awk -F'/' '{printf $7}'`"

#### 带上上面获取的三个参数获取一个新的路径上的数据，相当于是获取指定用户的数据
curl "${Original_ip}${new_ip}" -H 'Host: 10.172.5.131' -H "User-Agent: ${User_Agent}" -H "Accept: ${Accept_type}" -H "Accept-Language: ${Accept_lang}" --compressed -H "Referer: ${Referer_url}" -H 'Connection: keep-alive' --data "UserName=${USER_NAME}&Password=${PASS_WORD}&${button_name}.x=37&${button_name}.y=7&wosid=${WOSID}" > ${temp_file}

# tr命令(translate缩写)主要用于删除文件中的控制字符,或进行字符转换。语法:tr [–c/d/s/t] [SET1] [SET2] SET1: 字符集1 SET2:字符集2
Search_url="`cat ${temp_file} | grep "search_links" -B1 | awk -F'"' '{print $6}' | tr -d '[:cntrl:]'`"

cat "${SN_File}" | while read Serial_Number
do
    #echo "Serial_Number=$Serial_Number"
    #echo "Search_url=$Search_url"
    curl -q "${Original_ip}${Search_url}" -H 'Host: 10.172.5.131' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:45.0) Gecko/20100101 Firefox/45.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3' --compressed -H "Referer: ${Referer_url}" -H 'Connection: keep-alive' --data "1.5.5.29.1=${Serial_Number}&1.5.5.29.3=Search&wosid=${WOSID}" > ${temp_file}

    #exit 0
    View_Log_Url="`cat ${temp_file} | grep "View Process Logs" | awk -F'"' '{print $4}' | head -1 | tr -d '[:cntrl:]'`"

    curl -q "${Original_ip}${View_Log_Url}" -H 'Host: 10.172.5.131' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:45.0) Gecko/20100101 Firefox/45.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3' --compressed -H "Referer: ${Referer_url}" -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' > ${temp_file}

    cat ${temp_file} | grep "${Targit_log}" | awk -F'"' '{print $3}' | awk -F'<' '{print $1}' | sed 's/>//g' | while read SS_LOG_Name
    do
        SS_LOG_Url="`cat ${temp_file} | grep "${SS_LOG_Name}" -A9 | tail -1 | awk -F'"' '{print $4}' | tr -d '[:cntrl:]'`"
        echo $SS_LOG_Name:$SS_LOG_Url
        echo "logname=$Log_Out_Put/$SS_LOG_Name"
        curl -s --create-dirs "${Original_ip}${SS_LOG_Url}?$(($RANDOM%8+1)),$(($RANDOM%8+1))" -H 'Host: 10.172.5.131' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:45.0) Gecko/20100101 Firefox/45.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3' --compressed -H "Referer: ${Referer_url}" -H 'Connection: keep-alive' -o "${Log_Out_Put}/${SS_LOG_Name}"
        echo "****get sn:${Serial_Number} log return[$?]"
    done
done
