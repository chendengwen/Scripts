<?php

echo "<html><head><title>文件导航</title></head><body bgcolor=ffffff>";//输出html相关代码
echo "<p>文件列表</p>";

// echo "__FILE__:  ===>  ".__FILE__; //获取当前文件的绝对路径
// echo basename(__FILE__); //获取当前文件的名称
// echo "__DIR__:  ===>  ".__DIR__; //获取当前脚本的目录
// echo "dirname(__FILE__):  ===>  ".dirname(__FILE__); //dirname返回路径的目录部分, dirname(__FILE__)相当于__DIR__ 


$page=$_GET['page'];//获取当前页数
$max=20;//设置每页显示文件最大数

$i=0;
$handle = opendir('./'); //当前目录
while (false !== ($file = readdir($handle))) { //遍历该php文件所在目录
    list($filesname,$kzm)=explode(".",$file);//获取扩展名
    $array[]=$file;//把符合条件的文件名存入数组
    $i++;//记录文件总数
}

for ($j=$max*$page;$j<($max*$page+$max)&&$j<$i;++$j) {//循环条件控制显示文件列表
    echo "<a href=\"$array[$j]\">$array[$j]</a></br>";//输出图片数组
}

echo "</body></html>";
?>