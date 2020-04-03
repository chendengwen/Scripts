<?php

// echo "__FILE__:  ===>  ".__FILE__; //获取当前文件的绝对路径
// echo basename(__FILE__); //获取当前文件的名称
// echo "__DIR__:  ===>  ".__DIR__; //获取当前脚本的目录
// echo "dirname(__FILE__):  ===>  ".dirname(__FILE__); //dirname返回路径的目录部分, dirname(__FILE__)相当于__DIR__ 

echo "<html><head><title>文件导航</title></head><body>";//输出html相关代码

$i=0;//记录当前文件夹内文件数量
$path='./';//初始路径
if ($tmp=$_GET['path']) {
    $path=$tmp;//获取当前路径
}

if (is_dir($path)) {
    $handle = opendir($path); //打开当前目录
    while (false !== ($file = readdir($handle))) { //遍历该php文件所在目录
        $fullPath=$path.$file;
        if (is_dir($fullPath)) { //文件夹过滤
            if (strstr($fullPath.'/', '/../')) {
                $array[]='-1';
            } elseif (strstr($fullPath.'/', '/./')) {
                $array[]='./';
            } else {
                $array[]=$fullPath.'/';//把文件夹的路径存入数组
            }
        }else {
            $array[]=$fullPath;//把文件的路径存入数组
        }
        $i++;//记录文件总数
    }
} else {
    $filesname = array_pop(explode("/",$path));//截取文件名称
    list($name,$kzm)=explode(".",$filesname);//获取扩展名
    
    if ($kzm=='gif' or $kzm=='jpg' or $kzm =='JPG') {
        echo $name;
        echo "<br><img src=\"$path\"><br>";//输出图片
    }

    if ($kzm=='MP4' or $kzm=='mp4' or $kzm=='mkv' or $kzm=='wmv' or $kzm=='avi' or $kzm=='rmvb' or $kzm=='mov') {
        echo "<p>".$filesname."</p>";
        echo "<br><p></p><video src=\"$path\" controls=\"controls\"></video>";//输出视频
    }

    echo "</center>";
}

for ($j=0; $j<$i; $j++) {//循环条件控制显示文件列表
    if ($array[$j]=='-1') {
        echo "<a href=\"javascript:history.back(-1)\">返回</a></br>";//输出图片数组
        continue;
    }
    echo "<a href=\"?path=$array[$j]\">$array[$j]</a></br>";//输出图片数组
}

echo "</body></html>";
?>