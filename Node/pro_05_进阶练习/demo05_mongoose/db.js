var mongoose = require('mongoose');

//首先需要连接到MongoDB服务器，无论这个服务器是安装在本地还是在互联网上订阅的外部服务。
//为此，需要制定一个纸箱MongoDB数据库的URL：
var DBURL_ = 'mongodb://username:password&hostname:port/database'

//如果是连接的是本地计算机的MongoDB，而服务器不需要密码，这时只需要如下URL：
var DBURL = 'mongodb://localhost/database'

//然后再就可以用Mongoose连接数据库了
var db = mongoose.connect(DBURL);