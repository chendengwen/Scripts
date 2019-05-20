var tls = require('tls');
var fs = require('fs');

var port = 9001;
var host = '0.0.0.0';

var options = {
	key: fs.readFileSync('openssl/client_key.pem'),
	cert: fs.readFileSync('openssl/client_cert.pem'),

	//服务端使用自签名证书时才必须要设置
  	// ca: [ fs.readFileSync('openssl/server_cert.pem')],
	//收到安全警告报错时解决办法
	rejectUnauthorized: false, //忽略安全警告，继续访问
};

process.stdin.resume();

//tls.connect() 返回一个 tls.TLSSocket 对象
var clientSocket = tls.connect(port, host, options, function() {
	console.log('connected');
	process.stdin.pipe(clientSocket, {end: false});
	clientSocket.pipe(process.stdout);
});
