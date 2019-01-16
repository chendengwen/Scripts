'use strict';

var http = require('http');
var url = require('url');
var control = require('./modules/controller.js');
var fs = require('fs');

var server = http.createServer(function (request, response) {
	console.log('url == ' + request.url) ;
	var pathname = url.parse(request.url).pathname;
	if (pathname == '/search') {
		control.operSearch(request,response);
	}else if (pathname == '/index.html') {
		fs.readFile('.'+pathname, function(err, data){
            if( err){
                console.log(err);
                response.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'})
                response.write(err.toString());
                response.end();
            } else {
                response.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'})
                response.write(data);
                response.end();
            }
        })
	}else {
		// 将HTTP响应200写入response, 同时设置Content-Type: text/html:
    	response.writeHead(200, {'Content-Type': 'text/html'});
    	// 将HTTP响应的HTML内容写入response:
    	response.end('<h1>Hello world!</h1>');
	}
});

server.listen(8090);

console.log('Server is running at http://127.0.0.1:8090/');