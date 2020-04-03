<?php
    echo "1212121212 ";


    echo "<html><head><title>图片</title></head><body bgcolor=000000><center><font size=10 color=red>";//输出html相关代码
 $page=$_GET['page'];//获取当前页数
 $i=0;
$max=1;//设置每页显示图片最大张数
$handle = opendir('./'); //当前目录
while (false !== ($file = readdir($handle))) { //遍历该php文件所在目录
     list($filesname,$kzm)=explode(".",$file);//获取扩展名
     if($kzm=="gif" or $kzm=="jpg" or $kzm=="JPG") { //文件过滤
         if (!is_dir('./'.$file)) { //文件夹过滤
             $array[]=$file;//把符合条件的文件名存入数组
             $i++;//记录图片总张数
         }
     }
}
 
$Previous_page=$page-1;
$next_page=$page+1;
$last=$i-1;
if ($Previous_page<0){
    echo "最开始页 ";
    echo "上一页 ";
    echo "<a href=?page=$next_page>下一页 </a>";
    echo "<a href=?page=$last>最后一页</a>";
}
else if ($page<$i/$max-1){
    echo "<a href=?page=0>最开始页 </a>";
    echo "<a href=?page=$Previous_page>上一页 </a>";
    echo "<a href=?page=$next_page>下一页 </a>";
    echo "<a href=?page=$last>最后一页</a>";
}else{
       echo "<a href=?page=0>最开始页 </a>";
        echo " <a href=?page=$Previous_page>上一页 </a>";
       echo "下一页 ";
       echo "最后一个";
}
for ($j=$max*$page;$j<($max*$page+$max)&&$j<$i;++$j){//循环条件控制显示图片张数
    echo "<br><img widht=800 height=600 src=\"$array[$j]\"><br>";//输出图片数组
}
echo "</center></body></html>";

?>