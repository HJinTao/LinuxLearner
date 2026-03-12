#!/bin/bash

# 验证脚本
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASS=0
TOTAL=3

echo -e "=============================="
echo -e "    Chapter 09 通关验证"
echo -e "=============================="

# 任务 1: 解压与部署
# 预期: webapp 目录存在，且包含 src/app.py
if [ -d "webapp" ] && [ -f "webapp/src/app.py" ]; then
    echo -e "${GREEN}[PASS] 任务1: 应用源码部署到位${NC}"
    ((PASS++))
else
    echo -e "${RED}[FAIL] 任务1: 未找到部署的源码${NC}"
    echo "       提示: 请解压 release_v1.0.tar.gz。"
fi

# 任务 2: 解决端口冲突
# 预期: .conflict_pid 中记录的进程已被杀掉，且 8080 端口被新应用占用
# 检查旧进程是否还在
if [ -f ".conflict_pid" ]; then
    OLD_PID=$(cat .conflict_pid)
    if ps -p "$OLD_PID" > /dev/null 2>&1; then
        echo -e "${RED}[FAIL] 任务2: 旧的干扰进程 (PID $OLD_PID) 仍在运行${NC}"
        echo "       提示: 使用 kill 终止它，释放 8080 端口。"
    else
        # 检查新应用是否在运行 (app.py)
        if pgrep -f "app.py" > /dev/null; then
             echo -e "${GREEN}[PASS] 任务2: 端口冲突已解决，新应用正在运行${NC}"
             ((PASS++))
        else
             echo -e "${RED}[FAIL] 任务2: 旧进程已杀，但新应用未启动${NC}"
             echo "       提示: 请运行 python3 webapp/src/app.py。"
        fi
    fi
else
    echo -e "${RED}[FAIL] 任务2: 环境文件丢失 (.conflict_pid)${NC}"
fi

# 任务 3: 服务验证
# 预期: curl localhost:8080 返回包含 Welcome 的内容
if curl -s localhost:8080 | grep -q "Welcome"; then
    echo -e "${GREEN}[PASS] 任务3: Web 服务访问正常${NC}"
    ((PASS++))
else
    echo -e "${RED}[FAIL] 任务3: Web 服务无法访问${NC}"
    echo "       提示: 检查端口 8080 是否通，或者应用是否崩溃。"
fi

echo -e "=============================="
if [ $PASS -eq $TOTAL ]; then
    echo -e "${GREEN}恭喜！你已经完成了 Linux Learner 的所有挑战！(3/3)${NC}"
    echo -e "你现在是一名合格的 Linux 工程师了！🎓"
    
    # 清理残留进程
    pkill -f "app.py"
    if [ -f ".conflict_pid" ]; then
        kill $(cat .conflict_pid) 2>/dev/null
    fi
else
    echo -e "${RED}只差最后一步了，加油！($PASS/$TOTAL)${NC}"
fi
