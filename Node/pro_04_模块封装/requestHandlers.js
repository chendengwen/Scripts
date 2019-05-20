var exec = require("child_process").exec;
var querystring = require("querystring");
var fs = require("fs");
var formidable = require("formidable");

/*
child_process小解 
js是一种单进程单线程的语言，但现行的cpu都是多核的，
为了解决单进程单线程对多核使用不足的问题，child_process应运而生，理想情况下每个进程各自利用一个内核。

主要有四种方法来创建子进程:
exec  execFile  spawn  fork ;
每个子进程带有3个流对象child.stdin, child.stdout, child.stderr
*/

/*
child_process.exec(command[, options], callback)
解析:
command 将要运行的命令
options 可以是
 cwd 当前子进程的目录
 env  环境变量键值对
 encoding 编码方式，默认‘utf-8’
 shell 将要执行命令的shell
 timeout 超时时间，默认0
 maxBuffer 数字，stdout与stderr中允许的最大缓存（二进制），超过此值子进程会被杀死，默认200k
 killSignal 字符串，结束信号
 uid 数字，设置用户进程id
 gid 数字，设置进程组id
*/

//文件上传表单
function start (response,postData) {
	console.log("Request handler 'start' was called.");
	var body = '<html>'+
    '<head>'+
    '<meta http-equiv="Content-Type" content="text/html; '+
    'charset=UTF-8" />'+
    '</head>'+
    '<body>'+
    '<form action="/upload" enctype="multipart/form-data" method="post">'+
    '<input type="file" name="upload" multiple="multiple">'+
    '<input type="submit" value="Upload file" />'+
    '</form>'+
    '</form>'+
    '</body>'+
    '</html>';

    response.writeHead(200, {"Content-Type": "text/html"});
    response.write(body);
    response.end();
}

//将response传递到数据处理程序中以实现非阻塞响应
function start_text (response,postData) {
	console.log("Request handler 'start' was called.");
	var body = '<html>'+
    '<head>'+
    '<meta http-equiv="Content-Type" content="text/html; '+
    'charset=UTF-8" />'+
    '</head>'+
    '<body>'+
    '<form action="/upload" method="post">'+
    '<textarea name="text" rows="20" cols="60"></textarea>'+
    '<input type="submit" value="Submit text" />'+
    '</form>'+
    '</body>'+
    '</html>';

    response.writeHead(200, {"Content-Type": "text/html"});
    response.write(body);
    response.end();
}

function start_process (response) {
	console.log("Request handler 'start' was called.");
	exec("ls -ls",function (error,stdout,stderr) {
		if (error) throw error;
		response.writeHead(200, {"content-Type":"text/plain"});
		response.write(stdout);
		response.end();
	});
}

//错误示范01 -- 实现了非阻塞响应，但响应的内容为空
function start_error_01 () {
	console.log("Request handler 'start' was called.");
	var content = 'empty';
	exec("ls -lah",function (error,stdout,stderr) {
		content = stdout;
	})

	return content;
}

//错误示范02 -- 模拟好使操作阻塞响应
function start_error_02 (response) {
	console.log("Request handler 'start' was called.");
	exec("find /",{timeout: 10000, maxBuffer: 20000*1024},
		function (error,stdout,stderr) {
			response.writeHead(200,{"content-Type":"text/plain"});
			response.write(stdout);
			response.end();
		}
	);
}



//上传文件
function upload(response, request) {
  console.log("Request handler 'upload' was called.");

  var form = new formidable.IncomingForm();
  console.log('about to parse');
  form.parse(request,function (error,fields,files) {
  	console.log('parsing done');
  	fs.renameSync(files.upload.path, "/tmp/test.png");
  	response.writeHead(200,{"Content-Type":"text/html"});
  	response.write("received image:<br/>");
  	response.write("<img src='/show' />");
  	response.end();
  });
}

//上传字符串参数
function upload01(response, postData) {
  console.log("Request handler 'upload' was called.");
  response.writeHead(200, {"Content-Type": "text/plain"});

  // 读取包含所有参数的对象
  response.write("You've sent: " + postData);

  //使用querystring解析请求数据获取指定字段
  response.write("You've sent the text: " + querystring.parse(postData).text);

  response.end();
}

//无脊椎demo
function upload02(response) {
  console.log("Request handler 'upload' was called.");
  response.writeHead(200, {"Content-Type": "text/plain"});
  response.write("Hello Upload");
  response.end();
}


//显示图片
function show (response,postData) {
	console.log("Request handler 'show' was called.");
	fs.readFile("/tmp/test.png","binary",function (error,file) {
		if (error) {
			response.writeHead(500, {"Content-Type": "text/plain"});
      		response.write(error + "\n");
      		response.end();
		}else {
			response.writeHead(200, {"Content-Type": "image/png"});
      		response.write(file, "binary");
      		response.end();
		}
	});
}

exports.start = start;
exports.upload = upload;
exports.show = show;