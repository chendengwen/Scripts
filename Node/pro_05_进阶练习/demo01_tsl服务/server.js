const tls = require('tls');
const fs = require('fs');

//存储连接到服务器的客户端
var clients = [];
let port = 9001;

var options = {
	key: fs.readFileSync('openssl/server_key.pem'),
	cert: fs.readFileSync('openssl/server_cert.pem'),

	//把客户端证书添加到受信列表，只有客户端使用自签名证书时需要设置
	ca: [fs.readFileSync('openssl/client_cert.pem'),],
	//如果设为 true，服务器会要求连接的客户端发送证书，并尝试验证证书，只有客户端使用自签名证书时需要设置
	requestCert: true, 

	// rejectUnauthorized: true //不接受任何未经授权的客户端
};

function distribute (fromSocket, data) {
	// console.log(fromSocket.address());
	clients.forEach(function (client) {
		if (client !== fromSocket) {
			client.write("用户地址-" + fromSocket.remoteAddress + " 端口: " + fromSocket.remotePort + " 发送: " + data);
		}
	});
}

var server = tls.createServer(options, (client)=>{
	console.log('服务器已连接', client.authorized ? '已授权' : '未授权');

	clients.push(client);

	client.on('data', (data) => {
		//收到的某个客户端发送的消息后发布广播
		distribute(client, data);
		console.log('got data from client :' + data);
	});

	client.on('close', () => {
		console.log('closed connnection');
		clients.splice(clients.indexOf(client), 1);
	})
});

server.listen(port, ()=>{
	console.log('listening on port: ' + server.address().port);
})

//测试  echo hello | nc -u 0.0.0.0 9001