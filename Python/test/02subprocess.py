import subprocess

# 以下两种方式都报错：[Errno 13] Permission denied: '/Applications/Facetime.app'
# subprocess.Popen(['/Applications/NemuPlayer.app'])
# subprocess.call('/Applications/Facetime.app')

run_application = subprocess.call(["/usr/bin/open", "/Applications/NemuPlayer.app"])

print(run_application)