package main

import (
	_ "MysqlDemo/routers"

	"github.com/astaxie/beego"

	//测试数据库连接
	_ "MysqlDemo/models"
)

func main() {
	beego.Run()
}
