####Session、cookie简单介绍

session 是一种记录客户状态的机制，不同的是 Cookie 保存在客户端浏览器中，而 session 保存在服务器上。

cookie 不是很安全，别人可以分析存放在本地的 COOKIE 并进行 COOKIE 欺骗 考虑到安全应当使用 session。

Session的用途： 
session运行在服务器端，当客户端第一次访问服务器时，可以将客户的登录信息保存。 
当客户访问其他页面时，可以判断客户的登录状态，做出提示，相当于登录拦截。

session 会在一定时间内保存在服务器上。当访问增多，会比较占用你服务器的性能 考虑到减轻服务器性能方面，应当使用 COOKIE。

session可以和Redis或者数据库等结合做持久化操作，当服务器挂掉时也不会导致某些客户信息（购物车）丢失。

单个 cookie 保存的数据不能超过 4K，很多浏览器都限制一个站点最多保存 20 个 cookie。

####Session的工作流程

当浏览器访问服务器并发送第一次请求时，服务器端会创建一个session对象，生成一个类似于 
key,value的键值对，然后将key(cookie)返回到浏览器(客户)端，浏览器下次再访问时，携带key(cookie)， 找到对应的session(value)。 客户的信息都保存在session中

####express-session的使用

1.引入

```
var express = require("express");
var session = require("express-session");
```

2.设置官方文档提供的中间件

```
const app = express();
app.use(session({
	secret: 'keyboard cat',
 	resave: false,
 	saveUninitialized: true
}))
```

3.使用

	~设置值 req.session.username = "张三";
    ~获取值 req.session.username

    ~销毁 session

    ```
    req.session.destroy(function(err){

    })
    ```
    
    ~重新设置 cookie 的过期时间 req.session.cookie.maxAge=0;

4.示例

```
app.get("/",function(req,res){

	//获取sesssion
    if(req.session.userinfo){  /*获取*/
        res.send('你好'+req.session.userinfo+'欢迎回来');
    }else{
        res.send('未登录');
    }
});

app.get("/login",function(req,res){
    req.session.userinfo="zhangsan111"; /*设置session*/
    res.send('登录成功');
});

app.get("/loginOut",function(req,res){

    //req.session.cookie.maxAge=0;  /*改变cookie的过期时间*/

    //销毁
    req.session.destroy(function(err){
        console.log(err);
    })
    res.send('退出登录成功');
});


app.get("/news",function(req,res){
    //获取sesssion
    if(req.session.userinfo){  /*获取*/
        res.send('你好'+req.session.userinfo+'欢迎回来 news');
    }else{
        res.send('未登录 news');
    }
});
```

--------------------- 

####负载均衡配置Session，把Session保存到数据库里面

1.需要安装 express-session 和 connect-mongo 模块
2.引入模块
```
var session = require("express-session");
const MongoStore = require('connect-mongo')(session);
```
3.配置中间件
```
app.use(session({
    secret: 'keyboard cat',
    resave: false,
    saveUninitialized: true,
    rolling:true,
    cookie:{
        maxAge:100000
    },
    store: new MongoStore({
        url: 'mongodb://127.0.0.1:27017/student', //数据库的地址
        touchAfter: 24 * 3600
        //通过设置touchAfter:24 * 3600，使得在24小时内只更新一次会话，不管有多少请求(除了在会话数据上更改某些内容的除外)
    })
}))
```



