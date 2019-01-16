/**
 *控制端这里用 MVC模式
 */
var db = require("./db.js");
var url = require("url");
var qs = require("querystring");
 
/****************************查询数据******************************/

exports.operSearch = function(req, res){
	
	// var p = url.parse(req.url);
   	// console.log(p.href); //取到的值是：http://localhost:8888/select?aa=001&bb=002
	// console.log(p.protocol); //取到的值是：http: 
	// console.log( p.hostname);//取到的值是：locahost
	// console.log(p.host);//取到的值是：localhost:8888
	// console.log(p.port);//取到的值是：8888
	// console.log(p.path);//取到的值是：/select?aa=001&bb=002
	// console.log(p.hash);//取到的值是：null 
	// console.log(p.query);// 取到的值是：aa=001

	var sInfo = qs.parse(url.parse(req.url).query).name;
   	db.searchDb(sInfo, res);
}