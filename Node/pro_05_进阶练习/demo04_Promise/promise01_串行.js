//常规写法，不使用Promise
listen("click", function handler (event) {
	setTimeout(function request () {
		ajax("http://some.url.abc", function response (text) {
			if (text == "Hello") {
				handler();
			}else if (text == "world") {
				request();
			}
		})
	}, 500);
})

/*  流程梳理

首先执行 listern()
其次 doSomething()
500ms（或者更远）后执行ajax()

ajax完成后
如果text === hello 执行handler()
如果text === world 执行request()

*/


/*
在《你不知道的javascript》一书中，对于回调的信任问题做了阐述，
当你使用第三方的库的方法处理回调时很有可能遇到以下信任内容：
1、调用回调过早
2、调用回调过晚或不调
3、调用回调太少或太多
4、没能向你的回调传递必要的参数
5、吞掉可能发生的错误/异常

怎么解决这种信任问题？？？？

当你把一件事情交给别人去做（可能马上就能完成的也可能是需要一段时间的）,
这个人在任务完成或者失败后都会给你一个回应，这样的人你是不是特别放心的把事情交给他.
他没回应你那么他是正在办事、回应你了就是成功了或者失败了。

在javascript中这样的人就是Promise。

Promise的实例有三个状态:
	Pending（进行中）
	Resolved（已完成）
	Rejected（已拒绝）

把一件事情交给promise时，它的状态就是Pending，
任务完成了状态就变成了Resolved、没有完成失败了就变成了Rejected
*/

//一个简单的promise
let promise = new Promise((resolve, reject)=>{
	//接收一个callback，参数是成功和失败函数
	setTimeout(()=>{
		let num = parseInt(Math.random()*100);

		if (num > 50) {
			//数字大于50就调用成功函数，并将状态变为Resolved
			resolve(num);
		}else{
			//否则就调用失败函数，将状态变为Rejectd
			reject(num);
		}
	}, 2000);
});

//使用承诺完成后的结果
promise.then(result=>{
	//在构造函数中如果执行了resolve函数就会到这一步
	console.log(result);
}, error=>{
	//执行了reject函数就回到这一步
	console.log(error);
});

/*
then方法接收两个函数：
第一个是承诺成功（状态为resolved）的回调函数，
第二个是承诺失败（状态为rejected）的回调函数

then方法的返回值不是一个promise对象就会被包装成一个promise对象，所以then方法支持链式调用：
promise.then(result=>{ return 88 }).then(result=>{ console.log(result) })

then方法的链式调用可以帮我们串行的解决一些逻辑，当我们平时书写有顺序的异步时间，比如：
*/

ajax('first')
ajax('second')
ajax('third')
//需要按顺序串行执行怎么办？？？
ajax('first').success(res=>{
	ajax('second').success(res=>{
		ajax('third').success(res=>{
			//串行任务执行完毕
			//....
		})
	})
})

//如果使用then的链式调用呢？
let promise = new Promise((resolve, reject)=>{
	ajax('first').success(res=>{
		resolve(res);	
	})
})
promise.then(res=>{
	return new Promise((resolve, reject)=>{
		ajax('second').success(res=>{
			resolve(res);	
		})
}).then(res=>{
	return new Promise((resolve, reject)=>{
		ajax('third').success(res=>{
			resolve(res);	
		})
}).then(res=>{
	//串行任务执行完毕
	//....
});
//1.清晰简单明了
//2.每次执行resolve的时候，都可以把每次ajax的回调数据进行传递到下一个then函数





