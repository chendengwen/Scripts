package main

import (
	"io"
	"log"
	"net"
	"time"
)

func main() {
	listener, err := net.Listen("tcp", "localhost:8001")
	if err != nil {
		log.Print(err)
	}

	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Print(err)
			continue
		}
		handleConn(conn) //一次处理一个连接
		// go handleConn(conn) //并发处理多个连接
	}
}

func handleConn(c net.Conn) {
	defer c.Close()
	for {
		_, err := io.WriteString(c, time.Now().Format("15:04:05\n"))
		if err != nil {
			return
		}
		time.Sleep(1 * time.Second)
	}
}

//客户端发起与服务的连接
//指令：
//netcat localhost 8001
//输出:
//16:39:30
//16:39:31
//16:39:32
//16:39:33
