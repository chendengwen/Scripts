#!/bin/bash

#读取IP列表文件iplist，然后再对这个文件fping(调用fping.sh)批量执行的结果写进result文件
rm -f result.txt
cat ipmi_ping.txt | fping > result.txt
