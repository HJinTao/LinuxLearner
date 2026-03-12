#!/bin/bash

# 设置颜色变量
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[*] 初始化 Chapter 08 实验环境...${NC}"

# 1. 模拟一个需要长期运行的脚本 (nohup/screen 练习)
echo -e "${GREEN}[+] 生成 long_task.py (模拟数据处理)...${NC}"
cat > long_task.py << 'EOF'
import time
import sys

print("Task started. Processing data...")
sys.stdout.flush()

# 模拟长时间运行
for i in range(1, 1000):
    print(f"Processed batch #{i}")
    sys.stdout.flush()
    time.sleep(2)

print("Task completed!")
EOF
chmod +x long_task.py

# 2. 模拟一个 Web 服务 (Systemd 练习)
echo -e "${GREEN}[+] 生成 web_server.py (模拟后端服务)...${NC}"
cat > web_server.py << 'EOF'
from http.server import BaseHTTPRequestHandler, HTTPServer
import time

class MyHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b"Hello from Systemd managed service!")

def run(port=8088):
    server_address = ('', port)
    httpd = HTTPServer(server_address, MyHandler)
    print(f"Server running on port {port}...")
    httpd.serve_forever()

if __name__ == '__main__':
    run()
EOF
chmod +x web_server.py

# 3. 生成一个错误的 Systemd 配置文件模板 (供用户修复)
echo -e "${GREEN}[+] 生成 my_web.service 模板 (含错误)...${NC}"
# 获取当前目录的绝对路径，因为 systemd 需要绝对路径
CURRENT_DIR=$(pwd)

cat > my_web.service << EOF
[Unit]
Description=My Web Server Service
After=network.target

[Service]
# 错误1: ExecStart 必须是绝对路径。这里故意写错或者写成相对路径
ExecStart=python3 web_server.py

# 错误2: 工作目录未设置，Python 可能找不到依赖或文件
# WorkingDirectory=$CURRENT_DIR

# 错误3: 缺少 Restart 策略，挂了不会自动重启
# Restart=always

User=$(whoami)

[Install]
WantedBy=multi-user.target
EOF

echo -e "${GREEN}[✔] 实验环境初始化完成！${NC}"
echo -e "当前目录下已生成: long_task.py, web_server.py, my_web.service"
echo -e "注意: 本章涉及到系统服务管理，可能需要 sudo 权限 (在 Docker 内通常是 root)。"
