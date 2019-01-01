
# coding: utf-8
"""
#subprocess这个模块来产生子进程,并连接到子进程的标准输入/输出/错误中去，还可以得到子进程的返回值。

subprocess.Popen(["cat","test.txt"])
subprocess.Popen("cat test.txt")
这两个之中，后者将不会工作。因为如果是一个字符串的话，必须是程序的路径才可以。
但是下面的可以工作
subprocess.Popen("cat test.txt", shell=True)
这是因为它相当于
subprocess.Popen(["/bin/sh", "-c", "cat test.txt"])

stdin stdout和stderr，分别表示子程序的标准输入、标准输出和标准错误。
subprocess.PIPE 是一个可以被用于Popen的stdin、stdout和stderr 3个参数的特殊值，表示需要创建一个新的管道。
"""
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
    # r表示run吗？？
    p = subprocess.Popen(r'../Shell/fping.sh',stdout=subprocess.PIPE)
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
