#!/bin/bash

# 设置颜色变量
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[*] 初始化实验环境 (Chapter 01)...${NC}"

# 1. 生成 auth.log (模拟 SSH 登录日志)
echo -e "${GREEN}[+] 生成 auth.log (模拟 SSH 登录尝试)...${NC}"
cat > auth.log << EOF
Oct 10 08:00:01 server sshd[1234]: Server listening on 0.0.0.0 port 22.
Oct 10 08:00:05 server sshd[1235]: Accepted password for root from 192.168.1.5 port 54321 ssh2
EOF

# 生成大量失败登录尝试
for i in {1..50}; do
    echo "Oct 10 08:01:$i server sshd[1236]: Failed password for invalid user admin from 192.168.1.100 port $i ssh2" >> auth.log
done

# 插入一些干扰项
echo "Oct 10 08:02:00 server sshd[1237]: Accepted password for user1 from 192.168.1.10 port 44321 ssh2" >> auth.log
echo "Oct 10 08:02:05 server sshd[1238]: Failed password for user2 from 10.0.0.5 port 3321 ssh2" >> auth.log

# 2. 生成 server.log (模拟应用日志，含堆栈信息)
echo -e "${GREEN}[+] 生成 server.log (模拟应用崩溃日志)...${NC}"
cat > server.log << EOF
[2023-10-01 10:00:00] INFO  Starting application...
[2023-10-01 10:00:01] INFO  Loading modules...
[2023-10-01 10:00:02] WARN  Module 'Legacy' is deprecated.
EOF

# 生成正常日志
for i in {1..100}; do
    echo "[2023-10-01 10:01:$i] INFO  Processing request #$i" >> server.log
done

# 插入关键错误及其上下文 (这是任务重点)
echo "[2023-10-01 10:05:00] INFO  User initiated payment." >> server.log
echo "[2023-10-01 10:05:01] DEBUG Validating token..." >> server.log
echo "[2023-10-01 10:05:02] INFO  Token valid." >> server.log
echo "[2023-10-01 10:05:03] DEBUG Connecting to payment gateway..." >> server.log
echo "[2023-10-01 10:05:04] WARN  Gateway response slow (500ms)." >> server.log
echo "[2023-10-01 10:05:05] CRITICAL Payment Gateway Connection Refused!" >> server.log
echo "    at com.payment.Gateway.connect(Gateway.java:42)" >> server.log
echo "    at com.payment.Service.process(Service.java:108)" >> server.log
echo "    at com.core.Worker.run(Worker.java:55)" >> server.log

# 继续生成日志
for i in {101..150}; do
    echo "[2023-10-01 10:06:$i] INFO  Processing request #$i" >> server.log
done

# 3. 生成代码项目 (模拟 grep -r 场景)
echo -e "${GREEN}[+] 生成 project/ 目录 (模拟源代码)...${NC}"
mkdir -p project/src/backend
mkdir -p project/src/frontend
mkdir -p project/docs

# 生成一些包含 TODO 和 FIXME 的文件
echo "// TODO: Refactor this function later" > project/src/backend/main.c
echo "print('Hello World')" > project/src/backend/utils.py
echo "# FIXME: This is a security vulnerability" >> project/src/backend/utils.py
echo "<!-- TODO: Add specific CSS class -->" > project/src/frontend/index.html
echo "body { color: black; }" > project/src/frontend/style.css
echo "This is the documentation." > project/docs/readme.txt

echo -e "${GREEN}[✔] 环境初始化完成！${NC}"
echo -e "当前目录下已生成: auth.log, server.log, project/"
