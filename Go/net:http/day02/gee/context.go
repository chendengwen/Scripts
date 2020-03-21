// 给map[string]interface{}起了一个别名gee.H，构建JSON数据时，显得更简洁
type H map[string]interface{}

type Context struct {
	// origin objects
	Writer http.ResponseWriter
	Req *http.Request
	//
}