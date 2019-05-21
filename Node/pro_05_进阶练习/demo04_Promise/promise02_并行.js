//promise01.js介绍了Promise串行用法，
//那么并行怎么办？？？
//当有多个异步事件，之间并无联系而且没有先后顺序，只需要全部完成就可以开始工作了。
//那么并行的话该怎么确定全部完成呢？

///// Promise.all 与 Promise.race ////////
/*
Promise.all 接收一个数组，数组的每一项都是一个promise对象。
当数组中所有的promise的状态都达到resolved的时候，Promise.all的状态就会变成resolved，
如果有一个状态变成了rejected，那么Promise.all的状态就会变成rejected（任意一个失败就算是失败），这就可以解决我们并行的问题。
调用then方法时的结果成功的时候是回调函数的参数也是一个数组，按顺序保存着每一个promise对象resolve执行时的值
*/
let promise1 = new Promise((resolve, reject)=>{
	setTimeout(()=>{
		resolve(1);
	},10000)
});

let promise2 = new Promise((resolve, reject)=>{
	setTimeout(()=>{
		resolve(2);
	},9000)
});

let promise3 = new Promise((resolve, reject)=>{
	setTimeout(()=>{
		resolve(3);
	},11000)
});

Promise.all([promise1,promise2,promise3]).then(res=>{
	console.log(res);
	//[1,2,3] 证明与哪个promise的状态先变成resolved无关
})

let promiseAll = Promise.all([promise1,promise2,promise3]);
promiseAll.then(res=>{
	console.log(res);
}, err=>{
	console.log(err);
})

/*
Promise.race 竞速模式 也是接受一个每一项都是promise的数组。
但是与all不同的是，第一个promise对象状态变成resolved时自身的状态变成了resolved，
第一个promise变成rejected自身状态就会变成rejected。
第一个变成resolved的promsie的值就会被使用
*/
Promise.race([promise1,promise2,promise3]).then(res=>{
	console.log(res);
	//打印出2，为什么不是别的？ 因为promise2先完成了其余的被忽略
}, rej=>{
	console.log('rejected');
	console.log(rej);
})

/*
Promsie.race还有一个很重要的实际用处就是，有时候我们要去做一件事，但是超过三秒钟左右我们就不做了那怎么办？
这个时候可以使用Promise.race方法
*/
Promise.race([promise1,timeOutPromise(3000)]).then(res=>{})
//timeOutPromise延时3s左右
//由于是用setTimeout来实现的并不一定准确3s（一般主线程在开发中不会阻塞3s以上的所以不会有太大问题）