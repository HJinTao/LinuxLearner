#!/bin/bash

# 验证脚本
# 检查用户是否杀死了指定的恶意进程

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASS=0
TOTAL=3

echo -e "=============================="
echo -e "    Chapter 03 通关验证"
echo -e "=============================="

# 任务 1: 检查 high_cpu.py 是否被杀死
# pgrep -f "pattern" 可以匹配命令行参数
if pgrep -f "high_cpu.py" > /dev/null; then
    echo -e "${RED}[FAIL] 任务1: high_cpu.py 仍在运行！${NC}"
    echo "       提示: 使用 top 找到 PID，然后 kill 它。"
else
    echo -e "${GREEN}[PASS] 任务1: CPU 占用进程已被消灭${NC}"
    ((PASS++))
fi

# 任务 2: 检查 frozen_service.py 是否被杀死
if pgrep -f "frozen_service.py" > /dev/null; then
    echo -e "${RED}[FAIL] 任务2: frozen_service.py 仍在运行！${NC}"
    echo "       提示: 使用 ps aux | grep frozen 找到它。"
else
    echo -e "${GREEN}[PASS] 任务2: 卡死服务已被终止${NC}"
    ((PASS++))
fi

# 任务 3: 检查 sneaky_process.sh 是否被杀死
if pgrep -f "bash.*sneaky_process.sh" > /dev/null; then
    echo -e "${RED}[FAIL] 任务3: sneaky_process.sh 仍在运行！${NC}"
    echo "       提示: 这个进程可能在后台，使用 kill 9 强制结束它。"
else
    echo -e "${GREEN}[PASS] 任务3: 伪装进程已被清理${NC}"
    ((PASS++))
fi

echo -e "=============================="
if [ $PASS -eq $TOTAL ]; then
    echo -e "${GREEN}恭喜！服务器恢复平静了！(3/3)${NC}"
    echo -e "你是真正的运维救火队员！"
else
    echo -e "${RED}服务器负载仍然很高，请继续排查！($PASS/$TOTAL)${NC}"
    echo -e "提示：如果你已经 kill 了进程但这里显示 FAIL，请确认是否误杀了其他进程或者脚本没运行。"
fi
