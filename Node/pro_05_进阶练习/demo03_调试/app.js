var a= 0;

function init() {
	a = 1;
}

function incr() {
	var a = a + 1;
}

init();
console.log('a before: %d', a);

incr();
console.log('a after: %d', a);

//启动调试  node debug app.js
// `node debug` is deprecated. Please use `node inspect` instead.

//常用命令
/*
	next 执行同一作用域的下一条指令,已经到作用域最后一条时作用相当于out
	step 进入下一个函数调用
	backtrace 查看堆栈状态
	watch('a') 监视变量a
	watchers 查看监视列表
	out 调到父作用域的下一条指令
	sb('app.js', 8) 插入断点，在app.js文件第8行
	cont 继续执行代码，知道遇到下一个断点处停下

	Ctrl+D 退出调试器
*/

/*
	Chrome 开发工具 55+
	在基于 Chromium 内核的浏览器下打开 chrome://inspect
*/
