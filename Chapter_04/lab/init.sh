#!/bin/bash

# 设置颜色变量
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[*] 初始化 Chapter 04 实验环境...${NC}"

# 1. 启动 HTTP 服务 (Port 8080)
echo -e "${GREEN}[+] 启动 Web Server (Port 8080)...${NC}"
python3 -m http.server 8080 > /dev/null 2>&1 &
WEB_PID=$!
echo "Web Server PID: $WEB_PID"

# 2. 启动 API 服务 (Port 9000)
echo -e "${GREEN}[+] 启动 API Service (Port 9000)...${NC}"
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
            self.wfile.write(json.dumps(response).encode('utf-8'))
        else:
            self.send_response(404)
            self.end_headers()

def run(server_class=HTTPServer, handler_class=APIHandler, port=9000):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    httpd.serve_forever()

if __name__ == '__main__':
    run()
EOF
python3 api_service.py > /dev/null 2>&1 &
API_PID=$!
echo "API Service PID: $API_PID"

# 3. 启动后门服务 (Port 55555)
echo -e "${GREEN}[+] 启动 Hidden Backdoor (Port 55555)...${NC}"
cat > backdoor.py << EOF
import socket

HOST = '0.0.0.0'
PORT = 55555

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    while True:
        conn, addr = s.accept()
        with conn:
            conn.sendall(b"FLAG{Network_Ninja_2024}\n")
EOF
python3 backdoor.py > /dev/null 2>&1 &
BACKDOOR_PID=$!
echo "Backdoor PID: $BACKDOOR_PID"

# 保存 PIDs
echo "$WEB_PID" > .web_pid
echo "$API_PID" > .api_pid
echo "$BACKDOOR_PID" > .backdoor_pid

echo -e "${GREEN}[✔] 所有网络服务已在后台启动！${NC}"
echo -e "请根据 README.md 的指示，找出并连接这些服务。"
