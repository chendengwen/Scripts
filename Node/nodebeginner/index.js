var server = require("./server.js");
var router = require("./router.js");
var requestHandlers = require("./requestHandlers.js");

var handle = {};
handle["/"] = requestHandlers.start;
handle["/start"] = requestHandlers.start;
handle["/upload"] = requestHandlers.upload;
handle["/show"] = requestHandlers.show;

server.start(router.route,handle);

//测试上传文件时需要安装插件 formidable，该模块做的就是将通过HTTP POST请求提交的表单，在Node.js中可以被解析
//指令 npm install formidable
//引用 var formidable = require("formidable");

//学习地址：https://www.nodebeginner.org/index-zh-cn.html