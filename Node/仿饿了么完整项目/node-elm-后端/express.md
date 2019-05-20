#### app.use()

app.use([path,]function[,function...])

app.use是用来给path注册中间函数的，这个path默认是’/’，也就是处理用户的任何url请求，
同时会处理path下的子路径： 
比如设置path为’/hello’，那么当请求路径为’/hello/’、’/hello/nihao’、’/hello/nihao/1’等等这样的请求也都会交给中间函数处理的。

于是我们现在知道了app.use(express.static(__dirname + ‘/public’))是将所有请求，先交给express.static(__dirname + ‘/public’)来处理一下，虽然我们暂时不知道express.static()的处理细节，但是这不影响我们做出一些推测，最起码我们可以知道，express.static()的返回值肯定是一个函数。


#### express.static()

为了提供对静态资源文件(图片、csss文件、javascript文件)的服务，请使用Express内置的中间函数 express.static 。 
传递一个包含静态资源的目录给 express.static 中间件用于立刻开始提供文件。比如用以下代码来提供public目录下的图片、css文件和javascript文件：

```
app.use(express.static('public'));
```

express 会在静态资源目录下查找文件，所以不需要把静态目录public作为url的一部分。现在，你可以加载 public目录下的文件了：

```
http://localhost:3000/hello.html
http://localhost:3000/images/1.jpg
http://localhost:3000/css/style.css
http://localhost:3000/js/index.js
```

可以多次使用 express.static 中间件来添加多个静态资源目录，这时express 将会按照你设置静态资源目录的顺序来查找静态资源文件：

```
app.use(express.static('public'));
app.use(express.static('files'));
```

为了给静态资源文件创建一个虚拟的文件前缀(实际上文件系统中并不存在) ，可以使用 express.static 函数指定一个虚拟的静态目录，就像下面这样：

```
app.use('/static', express.static('public'));
```

现在你可以使用 /static 作为前缀来加载 public 文件夹下的文件了：

```
http://localhost:3000/static/hello.html
http://localhost:3000/static/images/1.jpg
http://localhost:3000/static/css/style.css
http://localhost:3000/static/js/index.js
```

然而，你提供给 express.static 函数的路径是一个相对node进程启动位置的相对路径。如果你在其他的文件夹中启动express app，更稳妥的方式是使用静态资源文件夹的绝对路径：

```
app.use('/static', express.static(__dirname + '/public'));
```

#### express.Router();
[详细参考](http://expressjs.com/zh-cn/guide/routing.html)

const router = express.Router();


#### app.set 
设置express内部的一些参数（options）