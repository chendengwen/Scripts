#!/bin/sh

#--------------------------------------------
# 功能：实现Release版本的打包
# 作者：Panda
# 使用教程： 1. cd 脚本所在的目录
#           2. chmod 777 build_release.sh (仅第一次的时候需要)
#           3. ./build_release.sh
# 注：这边生成的release.ipa 相当于发布到iTunes connect上的IPA,证书须为对应的distribution证书
# 创建日期：2016/02/22
#--------------------------------------------

profile_name='WM Team'
echo "======Release Profile name：${profile_name}======"

# 获取工程根目录
xCodeBuild_GetDocumentDirPath(){
project_Path=$(pwd)
echo ${project_Path}
}

cd ..

# 获取ipa文件导出路径
build_outputPath(){
#cd ..
scheme=$(ls | grep xcodeproj | awk -F.xcodeproj '{print $1}')
cd ~/Desktop

SYSTEM_TIME=`date '+%Y-%m-%d-%T'`
outputPath=$(pwd)/${scheme}_${SYSTEM_TIME}
mkdir ${outputPath}
#cd ${projectPath}
echo ${outputPath}
}

buildExportPath=$(build_outputPath)
echo "======输出路径：${buildExportPath}======"

build_Mode='Release'

# 工程名称
project_name=$(ls | grep xcodeproj | awk -F.xcodeproj '{print $1}')

# 获取工程绝对路径
project_path=$(xCodeBuild_GetDocumentDirPath)

# 获取xcworkSpace的路径
workspacePath=${project_path}/${project_name}.xcworkspace

# build文件夹路径
build_path=${project_path}/build

# 工程配置文件路径
project_infoplist_path=${project_path}/${project_name}/${project_name}-Info.plist

# 取版本号
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" ${project_infoplist_path})

# 取build值
bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" ${project_infoplist_path})

# 取bundle Identifier前缀
bundlePrefix=$(/usr/libexec/PlistBuddy -c "print CFBundleIdentifier" `find . -name "*-Info.plist"` | awk -F$ '{print $1}')

# 进入工程路径下
cd $project_path
echo 开始清理工程~

# 删除bulid目录
if [ -d ${build_path} ];
then
rm -rf ${build_path}
echo 清理build文件成功
fi

# 清理工程
xcodebuild clean  -configuration ${build_Mode} || exit

if  [ -d ${workspacePath} ];
then
echo  当前工程使用cocoapods
#xcodebuild  -configuration ${build_Mode}  -workspace ${project_path}/${project_name}.xcworkspace \
#-scheme ${project_name} \
#ONLY_ACTIVE_ARCH=NO \
#TARGETED_DEVICE_FAMILY=1 \
#DEPLOYMENT_LOCATION=YES CONFIGURATION_BUILD_DIR=${project_path}/build/Release-iphoneos  || exit

# 编译
xctool -workspace ${project_path}/${project_name}.xcworkspace -scheme ${project_name} archive -archivePath ${project_path}/build/Release-iphoneos/${project_name}_Release.xcarchive -configuration ${build_Mode} || exit
# 打包
xcodebuild -exportArchive -archivePath ${project_path}/build/Release-iphoneos/${project_name}_Release.xcarchive -exportPath ${buildExportPath}/release.ipa -exportFormat ipa \
-exportProvisioningProfile "${buildExportPath}" || exit

else

echo  当前工程没有使用cocoapods
#xcodebuild  -configuration ${build_Mode}  -project ${project_path}/${project_name}.xcodeproj \
#-scheme ${project_name} \
#ONLY_ACTIVE_ARCH=NO \
#TARGETED_DEVICE_FAMILY=1 \
#DEPLOYMENT_LOCATION=YES CONFIGURATION_BUILD_DIR=${project_path}/build/Release-iphoneos  || exit

# 编译
xctool -workspace ${project_path}/${project_name}.xcworkspace -scheme ${project_name} archive -archivePath ${project_path}/build/Release-iphoneos/${project_name}_Release.xcarchive -configuration ${build_Mode} || exit
# 打包
xcodebuild -exportArchive -archivePath ${project_path}/build/Release-iphoneos/${project_name}_Release.xcarchive -exportPath ${buildExportPath}/release.ipa -exportFormat ipa \
-exportProvisioningProfile "${buildExportPath}" || exit
fi

# 将归档文件移动到输出目录下
mv -v ${project_path}/build/Release-iphoneos/${project_name}_Release.xcarchive  ${buildExportPath}/Release.xcarchive
if [ -d ./ipa-build ];then
rm -rf ipa-build
fi
if [ -d ./build/Debug-iphoneos ];then
rm -rf Debug-iphoneos
fi
