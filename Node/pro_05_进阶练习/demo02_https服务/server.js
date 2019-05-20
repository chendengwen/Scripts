const https = require('https');
const fs = require('fs');

var options = {
	key: fs.readFileSync('openssl/server_key.pem'),
	cert: fs.readFileSync('openssl/server_cert.pem'),
};

var server = https.createServer(options, (request, response)=>{
	console.log('authorized: ', request.socket.authorized);
	console.log('client certificate: ', request.socket.getPeerCertificate());

	response.writeHead(200,{'Content-Type': 'text/plain'});
	response.end('hello world');
});

const port = 4001;
server.listen(port, ()=>{
	console.log('listening on port: ' + server.address().port);
})

//测试  浏览器输入地址 https://localhost:4001