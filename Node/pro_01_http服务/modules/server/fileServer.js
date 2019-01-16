'use strict';

/*////////////////////////////////////////
//////////////// 文件服务器 ////////////////
*/////////////////////////////////////////

//1.http
var http = require('http');

//2.解析URL需要用到Node.js提供的url模块，通过parse()将一个字符串解析为一个Url对象
var url = require('url');
// console.log(url.parse('http://user:pass@host.com:8080/path/to/file?query=string#hash'));

//3.处理本地文件目录需要使用Node.js提供的path模块，它可以方便地构造目录：
var path = require('path');
// // 解析当前目录:
// var workDir = path.resolve('.');
// // 组合完整的文件路径:当前目录+'pub'+'index.html':
// var filePath = path.join(workDir, 'pub', 'index.html');

//4.文件管理
var fs = require('fs');


// 从命令行参数获取root目录，默认是当前目录:
// 指令为：node fileServer.js ~/Desktop/github/Script/Node
var root = path.resolve(process.argv[2] || '.');
console.log('Static root dir: ' + root);

// 创建服务器
var server = http.createServer(function (request, response) {
	// 获得URL的path，类似 '/css/bootstrap.css':
    var pathname = url.parse(request.url).pathname;
    // 获得对应的本地文件路径，类似 '/srv/www/css/bootstrap.css':
    var filepath = path.join(root, pathname);
    // 获取文件状态:
    fs.stat(filepath, function (err, stats) {
        if (!err && stats.isFile()) {
            // 没有出错并且文件存在:
            console.log('200 ' + request.url);
            // 发送200响应:
            response.writeHead(200);
            // 将文件流导向response:
            // 没有必要手动读取文件内容。由于response对象本身是一个Writable Stream，
            // 直接用pipe()方法就实现了自动读取文件内容并输出到HTTP响应。
            fs.createReadStream(filepath).pipe(response);
        } else {
            // 出错了或者文件不存在:
            console.log('404 ' + request.url);
            // 发送404响应:
            response.writeHead(404);
            response.end('404 Not Found');
        }
    });
});

server.listen(8090);

console.log('Server is running at http://127.0.0.1:8090/');