
# coding: utf-8

#检查ip能否ping通
#0:正常，1：ping不通
def check_ip_ping():
    ip = mysql('select * from ip_check')
    #将IP写进一个文件
    if os.path.exists('iplist.txt'):
        os.remove('iplist.txt')
    iplist= 'iplist.txt'
    for i in range(0,len(ip)):
        with open(iplist, 'a') as f:
            f.write(ip[i][0]+'\n')
    #对文件中的IP进行fping
    p = subprocess.Popen(r'./fping.sh',stdout=subprocess.PIPE)
    p.stdout.read()
    #读result.txt文件，将IP is unreachable的行提取更新mysql状态为1
    result = open('result.txt','r')
    content = result.read().split('\n')
    for i in range(0,len(content)-1):
        tmp = content[i]
        ip = tmp[:tmp.index('is')-1]
        Status = 0
        if 'unreachable' in tmp:
            Status = 1
        #print i,ip
        mysql('update  ip_check set Status=%d where IP="%s"'%(Status,ip))
    print 'check all ipconnectness over!'
