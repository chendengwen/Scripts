//声明3个状态
var PENDING = 0;
var FULFILLED = 1;
var REJECTED = 2;

//Promise构造函数接收一个回调函数
function Promise (callback) {
	this.status = PENDING;
	this.value = null;

	//defferd字面意思就是推迟，是个数组，存放这个promise以后要执行的事件
	//类比发布订阅模式（观察者模式）。存放观察者在被观察者身上订阅的事件列表
	//defferd内的事件是日后观察者要执行的事件
	this.defferd = [];

	//setTimeout异步地执行new一个promise实例内执行的任务，不去阻塞主线程
	//bind函数的作用。callback的参数如何指定？通过bind方法将函数柯里化，并且绑定函数的this
	//指定函数执行的参数，将resolve和reject方法强制作为callback的参数
	//所以我们写的回调函数，参数怎么命名都可以执行到对应的resolve和reject方法
	setTimeout(callback.bind(this, this.resolve.bind(this), this.reject.bind(this)), 0);
	//通过bind函数将callback柯里化，使callback执行时调用对应的resolve与reject方法，并执行callback
}

Promise.prototype = {
	constructor: Promise,
	resolve: function (result) {
		this.status = FULFILLED;
		this.value = result;
		this.done();
	},
	reject: function (error) {
		this.status = REJECTED;
		this.value = error;
	},
	handle: function (fn) {
		if (!fn) {
			return;
		}

		var value = this.value;
		var t = this.status;
		var p;
		if (t == PENDING) {
			this.defferd.push(fn);
		}else {
			if (t == FULFILLED && typeof fn.onfulfield == 'function') {
				p = fn.onfulfiled(value);
			}
			if (t == REJECTED && typeof fn.onrejected == 'function') {
				p = fn.onrejected(value);
			}

			var promise = fn.promise;
			if (promise) {
				if (p && p.constructor == Promise) {
					p.defferd = promise.defferd;
				} else  {
					p = this;
					p.defferd = promise.defferd;
					this.done();	
				}
			}
		}
	},
	done: function () {
		var status = this.status;
		if (status == PENDING) {
			return;
		}
		var defferd = this.defferd;
		for (var i = 0; i < defferd.length; i++) {
			this.handle(defferd[i]);
		}
	},
	then: function (success, fail) {
		var o = {
			onfulfield: success,
			onrejected: fail
		};

		var status = this.status;
		o.promise = new this.constructor(function(){});
		if (status == PENDING) {
			this.defferd.push(o);
		}else if (status == FULFILLED || status == REJECTED) {
			this.handle(o);
		}
		return o.promise;
	}
};