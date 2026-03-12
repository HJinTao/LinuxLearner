#!/bin/bash

# 设置颜色变量
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[*] 初始化 Chapter 03 实验环境...${NC}"

# 1. 生成 CPU 满载脚本
echo -e "${GREEN}[+] 生成 high_cpu.py (模拟 CPU 占用 100%)...${NC}"
cat > high_cpu.py << EOF
import time
import os
import sys

print(f"Process started with PID: {os.getpid()}")
print("I am going to eat your CPU now...")

try:
    while True:
        # 简单的数学运算死循环
        _ = 2 ** 1000
except KeyboardInterrupt:
    print("Stopping...")
EOF

# 2. 生成 假死/睡眠 脚本 (模拟卡死的服务)
echo -e "${GREEN}[+] 生成 frozen_service.py (模拟卡死的服务)...${NC}"
cat > frozen_service.py << EOF
import time
import os

print(f"Service started with PID: {os.getpid()}")
print("I am just sleeping forever... zzz...")

while True:
    time.sleep(10)
EOF

# 3. 生成 内存泄漏脚本 (可选，为了简单起见，本章重点在 CPU 和 kill)
# 但我们可以生成一个名字很奇怪的脚本，练习 ps筛选
echo -e "${GREEN}[+] 生成 sneaky_process.sh (模拟伪装进程)...${NC}"
cat > sneaky_process.sh << EOF
#!/bin/bash
echo "I am hiding..."
sleep 3600
EOF
chmod +x sneaky_process.sh

echo -e "${GREEN}[✔] 实验脚本生成完成！${NC}"
echo -e "当前目录下已生成: high_cpu.py, frozen_service.py, sneaky_process.sh"
echo -e "${GREEN}注意：请务必阅读 README.md 中的实验步骤来运行这些脚本！${NC}"
