#!/bin/bash

# 设置颜色变量
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[*] 初始化 Chapter 03 实验环境...${NC}"

# 1. 创建模拟的恶意进程脚本 (Crypto Miner)
# 虽然名字叫 crypto_miner，但实际上只是 sleep，不占用 CPU，避免卡死机器
cat > crypto_miner.sh << EOF
#!/bin/bash
# 模拟恶意挖矿进程，伪装成系统服务
while true; do
    sleep 1
done
EOF
chmod +x crypto_miner.sh

# 2. 创建模拟的僵尸/顽固进程 (Invincible Service)
# 这个脚本会捕获 SIGTERM (15) 信号，导致普通的 kill 无法杀死它
cat > invincible_service.sh << EOF
#!/bin/bash
# 捕获 SIGTERM 信号
trap "echo 'Ha! I refuse to die! (Try kill -9)'" SIGTERM

echo "Service started. I am invincible against normal kill commands."
while true; do
    sleep 1
done
EOF
chmod +x invincible_service.sh

# 3. 启动进程 (后台运行)
echo -e "${GREEN}[+] 启动模拟进程...${NC}"
./crypto_miner.sh > /dev/null 2>&1 &
MINER_PID=$!
echo "Crypto Miner PID: $MINER_PID"

./invincible_service.sh > /dev/null 2>&1 &
SERVICE_PID=$!
echo "Invincible Service PID: $SERVICE_PID"

# 将 PID 保存到隐藏文件，供验证脚本使用
echo "$MINER_PID" > .miner_pid
echo "$SERVICE_PID" > .service_pid

echo -e "${GREEN}[✔] 恶意进程已在后台启动！${NC}"
echo -e "请按照 README.md 的指示，找到并终结它们。"
