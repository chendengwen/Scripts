#!/bin/sh

#  xcrun simctl 模拟器命令.sh
#  Open
#
#  Created by Cary on 2018/12/8.
#  Copyright © 2018年 Afer. All rights reserved.

#工程路径
${PROJECT_DIR}

#build成功后的，最终产品路径
$(BUILT_PRODUCTS_DIR)

#目标工程名称
$(TARGET_NAME)

#工程文件（比如Nuno.xcodeproj）的路径
$(SRCROOT)

#当前工程版本号
$(CURRENT_PROJECT_VERSION)

#build成功后的，最终产品路径
$(BUILT_PRODUCTS_DIR)


