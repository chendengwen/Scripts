var http = require("http");
var url = require("url");

function start (route,handle) {
	function onRequest (request,response) {
		var postData = "";
		var pathname = url.parse(request.url).pathname;
		console.log('Request for ' + pathname + ' received.');

		// ---- 简易版接收post请求 ---- 
		// //设置接收数据的编码格式为UTF-8
		// request.setEncoding("utf8");

		// //注册“data”事件的监听器，用于收集每次接收到的新数据块
		// request.addListener("data", function (postDataChunk) {
		// 	postData += postDataChunk;
		// 	console.log('Recieved POST data chunk ' + postDataChunk + ".");
		// });

		// //所有数据接收完毕后(只触发一次)调用路由
		// request.addListener("end",function () {
		// 	route(handle,pathname,response,postData);
		// });

		route(handle,pathname,response,request);
	}

	http.createServer(onRequest).listen(8888);
	console.log('Server has start at port 8888');
}

function start02 (route,handle) {
	function onRequest (request,response) {
		var pathname = url.parse(request.url).pathname;
		console.log('Request for' + pathname + 'received.');

		route(handle,pathname,response);
	}

	http.createServer(onRequest).listen(8888);
	console.log('Server has start at port 8888');
}

exports.start = start;