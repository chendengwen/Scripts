'use strict';

import mongoose from 'mongoose';
import config from 'config-lite';
import chalk from 'chalk';

/*////////mongoose入门 //////////
地址：https://segmentfault.com/a/1190000012095054

mongoose.connect(url(s), [options], [callback])
//url(s):数据库地址,可以是多个,以`,`隔开
//options:可选,配置参数
//callback:可选,回调
mongoose.connect('mongodb://数据库地址(包括端口号)/数据库名称')

指定用户连接
mongoose.connect('mongodb://用户名:密码@127.0.0.1:27017/数据库名称')
*/
mongoose.connect(config.url, {useMongoClient:true});
mongoose.Promise = global.Promise;

const db = mongoose.connection;

db.once('open' ,() => {
	console.log(
    chalk.green('连接数据库成功')
  );
})

db.on('error', function(error) {
    console.error(
      chalk.red('Error in MongoDb connection: ' + error)
    );
    mongoose.disconnect();
});

db.on('close', function() {
    console.log(
      chalk.red('数据库断开，重新连接数据库')
    );
    mongoose.connect(config.url, {server:{auto_reconnect:true}});
});

export default db;
