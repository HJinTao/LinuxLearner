#!/bin/bash

# 设置颜色变量
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[*] 初始化 Chapter 04 实验环境...${NC}"

# 1. 创建模拟的 Web 服务脚本
echo -e "${GREEN}[+] 生成 web_server.py (模拟占用端口的服务)...${NC}"
cat > web_server.py << EOF
import http.server
import socketserver
import sys
import time

PORT = 8080

class MyHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.send_header('X-Secret-Header', 'LinuxIsCool')
        self.end_headers()
        self.wfile.write(b"Hello! I am a zombie web server blocking port 8080.")

try:
    with socketserver.TCPServer(("", PORT), MyHandler) as httpd:
        print(f"Serving at port {PORT}")
        httpd.serve_forever()
except OSError as e:
    print(f"Error: {e}")
    # 如果端口被占用，我们不退出，而是死循环，模拟一个顽固的进程
    while True:
        time.sleep(10)
EOF

# 2. 生成 API 模拟脚本 (需要在实验时手动启动)
echo -e "${GREEN}[+] 生成 api_service.py (模拟后端接口)...${NC}"
cat > api_service.py << EOF
from http.server import BaseHTTPRequestHandler, HTTPServer
import json

class APIHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/api/status':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            response = {"status": "ok", "uptime": "99.9%"}
            self.wfile.write(json.dumps(response).encode())
        else:
            self.send_response(404)
            self.end_headers()

def run(server_class=HTTPServer, handler_class=APIHandler, port=9000):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print(f"API Server running on port {port}...")
    httpd.serve_forever()

if __name__ == '__main__':
    run()
EOF

# 3. 提示信息
echo -e "${GREEN}[✔] 实验脚本生成完成！${NC}"
echo -e "当前目录下已生成: web_server.py, api_service.py"
echo -e "${GREEN}注意：请务必阅读 README.md，本章需要你手动启动这些服务来进行测试。${NC}"
