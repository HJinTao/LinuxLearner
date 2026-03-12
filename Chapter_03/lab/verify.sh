#!/bin/bash

# 验证脚本
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASS=0
TOTAL=2

echo -e "=============================="
echo -e "    Chapter 03 通关验证"
echo -e "=============================="

# 检查是否运行了 init.sh
if [ ! -f ".miner_pid" ] || [ ! -f ".service_pid" ]; then
    echo -e "${RED}[ERROR] 未找到进程记录文件。请先运行 lab/init.sh 启动实验环境。${NC}"
    exit 1
fi

MINER_PID=$(cat .miner_pid)
SERVICE_PID=$(cat .service_pid)

# 任务 1: 终结矿工进程
# 预期: crypto_miner.sh 进程不应该存在
if ps -p "$MINER_PID" > /dev/null 2>&1; then
    echo -e "${RED}[FAIL] 任务1: crypto_miner (PID $MINER_PID) 仍在运行！${NC}"
    echo "       提示: 使用 kill 命令终结它。"
else
    echo -e "${GREEN}[PASS] 任务1: 恶意矿工已被终结${NC}"
    ((PASS++))
fi

# 任务 2: 强制终结顽固进程
# 预期: invincible_service.sh 进程不应该存在
if ps -p "$SERVICE_PID" > /dev/null 2>&1; then
    echo -e "${RED}[FAIL] 任务2: invincible_service (PID $SERVICE_PID) 仍在运行！${NC}"
    echo "       提示: 普通的 kill 对它无效，因为它捕获了 SIGTERM 信号。试试更强硬的手段 (-9)。"
else
    echo -e "${GREEN}[PASS] 任务2: 顽固进程已被强制终结${NC}"
    ((PASS++))
fi

echo -e "=============================="
if [ $PASS -eq $TOTAL ]; then
    echo -e "${GREEN}恭喜！所有恶意进程已被清除！(2/2)${NC}"
    echo -e "系统负载已恢复正常。"
else
    echo -e "${RED}还有进程在潜伏，请继续排查！($PASS/$TOTAL)${NC}"
fi
