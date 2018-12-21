#!/bin/bash

#ping 3个包，只要ping通，上述返回的结果就不是0。$1是传入的第一个参数，即IP
PING=`ping -c 3 $1 | grep '0 received' | wc -l`
echo $PING
