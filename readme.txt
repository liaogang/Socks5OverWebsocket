## Socks5 Over Websocket

使用Websocket承载socks5协议,使内网设备成为Socks5服务器

      +-----+-----+-----+------+------+------+
 NAME | CMD | PORT| socks5                  |
      +-----+-----+-----+------+------+------+
 SIZE |  1  |  2  |                          |
      +-----+-----+-----+------+------+------+

 Note: Size is in bytes

CMD:  
	 0x00: 关闭
	 0x01: 打开端口
	 0x10: 转发数据

PORT:
	会话端口,用于区别不同的SOCKS连接会话。
