#! /bin/sh
if which oclint 2>/dev/null; the
    echo 'oclint exist'
else
    brew tap oclint/formulae
    brew install oclint
fi
if which xcpretty 2>/dev/null; then
    echo 'xcpretty exist'
else
    gem install xcpretty
fi

cd test

xcodebuild clean

xcodebuild | xcpretty -r json-compilation-database

cp build/reports/compilation_db.json compile_commands.json

oclint-json-compilation-database -e Pods   -- -rc=LONG_LINE=200 -rc=NCSS_METHOD=100  -o=report.html


#使用xctool的方式  ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

# 清理以前的编译信息
#rm -f compile_commands.json
#xctool -project test.xcodeproj -scheme test clean

# 编译 Project
#xctool build -project SuperLoggerDemo.xcodeproj -scheme SuperLoggerDemo -reporter json-compilation-database:compile_commands.json

# Analyze Project
#oclint-json-compilation-database -e Pods -- \
#-max-priority-1=100000 \
#-max-priority-2=100000 -max-priority-3=100000 \
#-disable-rule=InvertedLogic \
#-disable-rule=CollapsibleIfStatements \
#-disable-rule=UnusedMethodParameter \
#-disable-rule=LongLine \
#-disable-rule=LongVariableName \
#-disable-rule=ShortVariableName \
#-disable-rule=UselessParentheses \
#-disable-rule=IvarAssignmentOutsideAccessorsOrInit | sed 's/\(.*\.\m\{1,2\}:[0-9]*:[0-9]*:\)/\1 warning:/'

# Final cleanup
#rm -f compile_commands.json

#使用xctool的方式  ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝