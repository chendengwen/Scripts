'use strict';

var http = require("http");
var url = require('url');
var router = require('./router/router.js');

var server = http.createServer(function(req, res){
    if ( req.url !== '/favicon.ico'){
        var pathname = url.parse(req.url).pathname.replace(/\//,'');
        console.log(pathname);
        try {
            router[pathname](req, res);
        } catch(e) {
            console.log('error:'+e);
            res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'});
            res.write(e.toString());
            res.end();
        };
    }
});

server.listen(8099);

console.log("server running at http://127.0.0.1:8099");

//调用示例：http://127.0.0.1:8099/login