import express from 'express';
import session from 'express-session';
import connectMongo from 'connect-mongo';
import config from 'config-lite';
import cookieParser from 'cookie-parser'
import winston from 'winston';
import expressWinston from 'express-winston';
// import path from 'path';
import history from 'connect-history-api-fallback';
import chalk from 'chalk';

import db from './mongodb/db.js';
import router from './routes/index.js';
// import Statistic from './middlewares/statistic'

const app = express();

app.all('*', (req, res, next) => {
	const { origin, Origin, referer, Referer } = req.headers;
  	const allowOrigin = origin || Origin || referer || Referer || '*';
	res.header("Access-Control-Allow-Origin", allowOrigin);
	res.header("Access-Control-Allow-Headers", "Content-Type, Authorization, X-Requested-With");
	res.header("Access-Control-Allow-Methods", "PUT,POST,GET,DELETE,OPTIONS");
  	res.header("Access-Control-Allow-Credentials", true); //可以带cookies
	res.header("X-Powered-By", 'Express');
	if (req.method == 'OPTIONS') {
  		res.sendStatus(200);
	} else {
    	next();
	}
});

// app.use(Statistic.apiRecord)

//负载均衡配置 Session，把 Session 保存到数据库里面（session入库）
const MongoStore = connectMongo(session);
app.use(cookieParser());
app.use(session({
  	name: config.session.name,
	secret: config.session.secret,
	resave: true,
	saveUninitialized: false,
	cookie: config.session.cookie,
	store: new MongoStore({
  		url: config.url
	})
}))

//将正常请求的日志打印到终端并写入了 logs/success.log，
//将错误请求的日志打印到终端并写入了 logs/error.log。
//需要注意的是：记录正常请求日志的中间件要放到 routes(app) 之前，记录错误请求日志的中间件要放到 routes(app) 之后。
// app.use(expressWinston.logger({
//     transports: [
//         new (winston.transports.Console)({
//           json: true,
//           colorize: true
//         }),
//         new winston.transports.File({
//           filename: 'logs/success.log'
//         })
//     ]
// }));

router(app);

app.use(expressWinston.errorLogger({
    transports: [
        new winston.transports.Console({
          json: true,
          colorize: true
        }),
        new winston.transports.File({
          filename: 'logs/error.log'
        })
    ]
}));

app.use(history());

//设置静态文件目录（网站访问路径）
app.use(express.static('./public'));
//这样可以通过带有 /static 前缀地址来访问 public 目录中的文件了。
//app.use('/static', express.static('public'))

app.listen(config.port, () => {
	console.log(
		chalk.green(`成功监听端口：${config.port}`)
	)
});