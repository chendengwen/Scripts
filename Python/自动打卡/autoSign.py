import subprocess
import pyautogui
import time
import schedule

def punchCard():
    # 启动模拟器
    run_application = subprocess.call(["/usr/bin/open", "/Applications/NemuPlayer.app"])
    time.sleep(12)


    #打开app
    pyautogui.moveTo(x=560, y=352, duration=1, tween=pyautogui.linear)
    pyautogui.mouseDown(button='left')
    pyautogui.mouseUp()
    time.sleep(5)

    #点击签到
    pyautogui.moveTo(x=1058, y=859, duration=1, tween=pyautogui.linear)
    pyautogui.mouseDown(button='left')
    pyautogui.mouseUp()
    time.sleep(5)

    pyautogui.moveTo(x=1053, y=613, duration=1, tween=pyautogui.linear)
    pyautogui.mouseDown(button='left')
    pyautogui.mouseUp()

    #关闭程序
    try:
        run_application.terminate()
        pass
    except:
        print('退出程序错误')


def main():
#    punchCard()
    schedule.every().day.at("11:30").do(punchCard)
    schedule.every().day.at("18:00").do(punchCard)
    while True:
        schedule.run_pending()
        time.sleep(10)


if __name__ == "__main__":
    main()
