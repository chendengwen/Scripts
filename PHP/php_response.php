<?php

    if (preg_match('/\/api\/comments(\?.*)?/', $uri)) {
        $comments = file_get_contents('comments.json');
        if($_SERVER['REQUEST_METHOD'] === 'POST') {
            $commentsDecoded = json_decode($comments, true);
            $commentsDecoded[] = [
                'id'      => round(microtime(true) * 1000),
                'author'  => $_POST['author'],
                'text'    => $_POST['text']
            ];

            $comments = json_encode($commentsDecoded, JSON_PRETTY_PRINT);
            file_put_contents('../../comments.json', $comments);
        }
        header('Content-Type: application/json');
        header('Cache-Control: no-cache');
        header('Access-Control-Allow-Origin: *');
        echo $comments;
    }

?>
