<?php
/**
 * 使用 $argc $argv 接受参数
 */
if (preg_match('/\/api\/comments(\?.*)?/', $argv[1])) {
    $comments = file_get_contents('comments.json');
    echo $comments;
}


