获取秘钥和证书(服务器):
openssl genrsa -out server_key.pem 1024
openssl req -new -key server_key.pem -out server_csr.pem
openssl x509 -req -in server_csr.pem -signkey server_key.pem -out server_cert.pem

证书请求csr信息设置 info:
{
	subject=/
	C=CN/
	ST=hubei/
	L=shenzhen/
	O=kangmei/
	OU=jkgl/
	CN=localhost/
	emailAddress=596765672@qq.com
	A challenge password []:123456
}



获取秘钥和证书(客户端):
openssl genrsa -out client_key.pem 1024
openssl req -new -key client_key.pem -out client_csr.pem
openssl x509 -req -in client_csr.pem -signkey client_key.pem -out client_cert.pem

证书请求csr信息设置 info:
{
	subject=/
	C=CN/
	ST=hubei/
	L=shenzhen/
	O=kangmei/
	OU=jkgl/
	CN=localhost/
	emailAddress=596765672@qq.com
	A challenge password []:123456
}