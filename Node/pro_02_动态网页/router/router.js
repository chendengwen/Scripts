'use strict';

var fs = require('fs');
var url = require('url');
var querystring = require('querystring');

module.exports = {
    login: function(req, res){
        var post ='';
        req.on('data', function(chunk){
            post += chunk;
        });
        req.on('end', function(){
            post = querystring.parse(post);
            var array = ['username', 'password'];
            fs.readFile('./login.html', function(err, data){
                if( err){
                    console.log(err);
                    res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'})
                    res.write(err.toString());
                    res.end();
                } else {
                    res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'})
                    data = data.toString();
                    for(var i = 0; i < array.length; i++){
                        var reg = new RegExp("{{"+array[i]+"}}", 'g');
                        console.log(reg);
                        post[array[i]] = post[array[i]] == undefined ? '':post[array[i]];
                        data = data.replace(reg, post[array[i]]);
                        console.log(post[array[i]]);
                    }
                    res.write(data);
                    res.end();
                }
            })
        })
    },
    register:function(req, res){
        fs.readFile('.register.html', function(err, data){
            if(err) {
                console.log(err);
                res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'})
                res.write(err.toString());
                res.end();
                return;
            } else{
                res.writeHead(200, {'Content-Type': 'text/html;charset=utf-8'});
                res.write(data);
                res.end();
            }
        })
    },
    showImage:function(req, res){
        fs.readFile('./test.png',function(err, data){
            if (err) {
                console.log(err);
                return;
            } else{
                console.log("开始读取图片");
                res.writeHead(200, {'Content-Type':'image/jpeg'});
                res.write(data);
                res.end();//写在互调函数外面会报错的哟
            }
        })
    }

}