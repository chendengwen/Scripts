## Mac系统下将python程序打包成mac应用程序

#### 1、安装py2app，打开终端，执行
- pip install py2app

#### 2、在桌面新建一个文件夹，取名xxx，打包的程序baba.py放在里面

#### 3、进入终端，切路径至该文件夹下，执行
- py2applet --make-setup baba.py

#### 4、开始打包应用，执行
- python setup.py py2app

#### 5、xxx文件下出现dist文件夹，打开后里面有个app，双击即可运行
