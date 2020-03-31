import subprocess
import pyautogui
import time

# 启动模拟器
# run_application = subprocess.call(["/usr/bin/open", "/Applications/NemuPlayer.app"])
# time.sleep(12)

# 获取当前屏幕分辨率
screenWidth, screenHeight = pyautogui.size()

# 获取当前鼠标位置
currentMouseX, currentMouseY = pyautogui.position()

#鼠标移到屏幕中央。
# pyautogui.moveTo(screenWidth / 2, screenHeight / 2)

# 2秒钟鼠标移动坐标为100,100位置  绝对移动
#pyautogui.moveTo(100, 100,2)
pyautogui.moveTo(x=340, y=247, duration=2, tween=pyautogui.linear)

#点击鼠标左键
# pyautogui.click() -- 不能使用，会报错

#点击鼠标左键
# pyautogui.mouseDown(button='left')
# pyautogui.mouseUp()
# time.sleep(5)

#解锁手势  x= 511, 639 ; y= 325, 452, 579
# pyautogui.moveTo(x=511, y=325)
# pyautogui.dragRel(128, 0, duration=0.5, button='left')
# pyautogui.dragRel(-128, 127, duration=0.5, button='left')
# pyautogui.dragRel(128, 0, duration=0.5, button='left')
# pyautogui.dragRel(-128, 127, duration=0.5, button='left')
# pyautogui.dragRel(128, 0, duration=0.5, button='left')
# pyautogui.mouseUp()

pyautogui.moveTo(x=511, y=325)
pyautogui.mouseDown(button='left')
pyautogui.moveTo(x=639, y = 325, duration=0.5)
pyautogui.moveTo(x=511, y = 452, duration=0.5)
pyautogui.moveTo(x=639, y = 452, duration=0.5)
pyautogui.moveTo(x=511, y = 579, duration=0.5)
pyautogui.moveTo(x=639, y = 579, duration=0.5)
pyautogui.mouseUp()

# move to 100, 200, then click the left mouse button.
# pyautogui.click(x=100, y=200)

#下面代码让鼠标顺时针移动，并划5次方框
'''
for i in range(5):
      pyautogui.moveTo(300, 300, duration=0.25)
      pyautogui.moveTo(400, 300, duration=0.25)
      pyautogui.moveTo(400, 400, duration=0.25)
      pyautogui.moveTo(300, 400, duration=0.25)
'''

#划圆
'''
import math
 
width, height = pyautogui.size()
 
r = 250  # 圆的半径
# 圆心
o_x = width/2
o_y = height/2
 
pi = 3.1415926
 
for i in range(10):   # 转10圈
    for angle in range(0, 360, 5):  # 利用圆的参数方程
        X = o_x + r * math.sin(angle*pi/180)
        Y = o_y + r * math.cos(angle*pi/180)
 
        pyautogui.moveTo(X, Y, duration=0.1)
'''

#moveRel()函数，相对坐标。以当前鼠标所在位置为基点
'''
for i in range(10):
    pyautogui.moveRel(100, 0, duration=0.25)
    pyautogui.moveRel(0, 100, duration=0.25)
    pyautogui.moveRel(-100, 0, duration=0.25)
    pyautogui.moveRel(0, -100, duration=0.25)
'''