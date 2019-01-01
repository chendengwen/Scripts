#!/usr/bin/env python
# coding: utf-8


import os
from scapy.all import sniff,wrpcap,Raw,IP,TCP

# 标准格式：sniff(filter="",iface="any",prn=function,count=N)
# filter 对scapy嗅探的数据包 指定一个 BPF（wireshark类型）的过滤器，留空表示嗅探所有数据包
# iface  设置所需要嗅探的网卡，留空嗅探所有网卡
# prn    指定嗅探到符合过滤器条件的数据包时所调用的回调函数,这个回调函数以接受到的数据包对象作为唯一的参数。
# count  指定嗅探的数据包的个数，留空则默认为嗅探无限个


def get_pcap(ifs,ip=None,size=100):
    ''' 获取指定 ifs(网卡), 指定数量size 的数据包;
        如果有指定ip，则这里只接收tcp，80端口，指定ip的包 '''
    filter = ""
    if ip:
        filter += "ip src %s and tcp and tcp port 80"%ip
        #加了过滤以后程序堵塞，不输出                             #lambda x:x.summary()
#        dpkt = sniff(iface=ifs,filter=filter,count=size,prn=lambda x:x.sprintf("8888888888"))

        dpkt = sniff(iface=ifs,count=size)
    else:
        dpkt = sniff(iface=ifs,count=size)
    # wrpcap("pc1.pcap",dpkt) # 保存数据包到文件
    return dpkt


def get_ip_pcap(ifs,sender,size=100):
    ''' 获取指定 ifs(网卡), 指定发送方 sender(域名或ip) 的数据包
        size：(一次获取数据包的数量） '''
    if 'www.' in sender:
        #os.popen可以实现一个管道,用来执行shell指令
        #ping指令要指定次数，不然无限执行会阻塞
        with os.popen('ping %s -c 1'%sender) as readPing:
        # v = os.popen('ping %s'%sender).read()
            v = readPing.read()
            ip = v.split()[2]
            print("准备接收IP为 %s 的数据包..."%ip)
    else:
        ip = sender
        print("准备接收IP为 %s 的数据包..."%ip)
    count = 0
    while count<10:
        d = get_pcap(ifs,ip=sender,size=size)
        for i in d:
            try:
                if i[IP].src==ip: # 发送方的IP为：ip  接收方的IP：i[IP].dst==ip
                    print(i[Raw].load)
            except:
                pass
        count+=1



def main():
    ifs = 'en0' # eth0 eth0:1 和eth0.1三者的关系对应于物理网卡、子网卡、虚拟VLAN网卡
    ip = "www.baidu.com"  # ip地址，也可写域名，如：www.baidu.com
    get_ip_pcap(ifs,ip,size=1)  # 一次接收一个包

if __name__ =='__main__':
    main()

