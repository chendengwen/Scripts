'use strict';

var mysql = require('mysql');

var connection = mysql.createConnection({ 
	host : '127.0.0.1', 
	user : 'root', 
	password : 'Chendeng56', 
	port: '3306', 
	database: 'test', 
});

connection.connect();

var userGetSql = 'SELECT * FROM users';
// var userAddSql = 'INSERT INTO users(id,name,age) VALUES(0,?,?)';
// var userModSql = 'UPDATE users SET name = ?,age = ? WHERE id = ?';
// var userDelSql = 'DELETE FROM users';
//设置参数
var userAddSql_Params = ['Wilson', 8];

//执行操作指令
connection.query(userGetSql,userAddSql_Params,function (err, result) {
	if(err){
		console.log('[INSERT ERROR] - ',err.message);
		return;
	}

	console.log('--------------------------INSERT----------------------------');
	//console.log('INSERT ID:',result.insertId); 
	console.log('INSERT ID:',result); 
	console.log('-----------------------------------------------------------------\n\n'); 
});

// connection.end();