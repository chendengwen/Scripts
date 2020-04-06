package main

import (
	"io"
	"log"
	"net"
	"os"
)

//使用net.Dial实现telnet的功能
func main() {
	conn, err := net.Dial("tcp", "localhost:8001")
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()
	//同步场景
	// mustCopy(os.Stdout, conn)//输出conn服务端返回的数据

	//异步场景
	go mustCopy(os.Stdout, conn)
	mustCopy(conn, os.Stdin) //输入内容发送到conn服务端
}

func mustCopy(dst io.Writer, src io.Reader) {
	//io.Copy(dst, src)是阻塞的，src接收到数据才执行
	if _, err := io.Copy(dst, src); err != nil {
		log.Fatal(err)
	}
}
