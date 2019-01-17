require('babel-core/register');
require('./app.js');
// babel-register字面意思能看出来，这是babel的一个注册器，
//它在底层改写了node的require方法，
//引入babel-register之后所有require并以.es6, .es, .jsx 和 .js为后缀的模块
//都会经过babel的转译。