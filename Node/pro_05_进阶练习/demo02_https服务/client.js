var fs = require('fs'); 
var https = require('https');

/*
var options = {
	host: 'localhost', // www.baidu.com  localhost
	port: 4001,
	method: 'GET',
	path: '/',
	rejectUnauthorized: false, //忽略安全警告，继续访问
};

var request = https.request(options, (response)=>{
	console.log('response.statusCode: ',response.statusCode);

	response.on('data', (data)=>{
		console.log('got some data back from server: ',data);
	})
});

request.write('Hey!\n');
request.end();
*/

var options = {
	host: 'www.baidu.com',
	method: 'GET',
	path: '/',
};

var request = https.request(options, (response)=>{
	console.log('response.socket.authorized: ',response.socket.authorized);
	console.log('peer certificate: ');
	console.log(response.socket.getPeerCertificate());
})

request.end();