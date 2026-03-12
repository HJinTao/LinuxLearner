#!/bin/bash

# 设置颜色变量
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[*] 初始化 Chapter 09 综合实战环境...${NC}"

# 1. 创建 Web 应用源代码 (Python Flask 模拟)
echo -e "${GREEN}[+] 生成 webapp 源码...${NC}"
mkdir -p webapp/src
mkdir -p webapp/config
mkdir -p webapp/logs

# 主程序
cat > webapp/src/app.py << 'EOF'
from http.server import BaseHTTPRequestHandler, HTTPServer
import os
import json

CONFIG_FILE = '../config/app.conf'
PORT = 8080

# 简单的配置加载
if os.path.exists(CONFIG_FILE):
    with open(CONFIG_FILE, 'r') as f:
        for line in f:
            if 'PORT' in line:
                PORT = int(line.split('=')[1].strip())

class MyHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(b"<h1>Welcome to LinuxLearner Capstone!</h1>")
        elif self.path == '/api/health':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps({"status": "ok", "port": PORT}).encode())
        else:
            self.send_response(404)
            self.end_headers()

def run():
    server_address = ('', PORT)
    httpd = HTTPServer(server_address, MyHandler)
    print(f"Starting server on port {PORT}...")
    httpd.serve_forever()

if __name__ == '__main__':
    run()
EOF

# 配置文件
echo "PORT=8080" > webapp/config/app.conf

# 2. 打包源码
echo -e "${GREEN}[+] 打包源码为 release_v1.0.tar.gz...${NC}"
tar -czf release_v1.0.tar.gz webapp
rm -rf webapp

# 3. 模拟一个残留的旧进程 (Port Conflict)
echo -e "${GREEN}[+] 启动一个占用 8080 端口的干扰进程...${NC}"
# 使用 python 启动一个简单的 http server 占用端口
python3 -m http.server 8080 > /dev/null 2>&1 &
OLD_PID=$!
echo "$OLD_PID" > .conflict_pid
echo "Old process started with PID $OLD_PID"

echo -e "${GREEN}[✔] 实验环境初始化完成！${NC}"
echo -e "你的任务：部署 release_v1.0.tar.gz，解决端口冲突，配置服务自启。"
