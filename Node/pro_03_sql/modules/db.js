/**
 数据库端处理
 */
 
var mmysql = require('mysql');
//打开数据库连接
function openCon(){
    var con= mmysql.createConnection({
        host:'127.0.0.1',
        user:'root',
        password:'Chendeng56',
        database:'test'
    });
    return con;
}
 
/**********************查询数据**********************************/
exports.searchDb = function(sInfo, res){
    var sql = 'select name from users where name like ?';
    // var sql = 'SELECT * FROM users WHERE id = ?';
    openCon().query(sql, ['%'+sInfo+'%'], function(error, results){
        if(error){
            console.log(error);
            res.end();
        }
        else{
            openCon().end();
            //===将jSon转换为字符串传输
            var strJson = JSON.stringify(results);
            res.write(strJson);
            res.end();
        }
    });
};