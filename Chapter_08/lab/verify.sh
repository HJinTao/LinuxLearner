#!/bin/bash

# 验证脚本
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASS=0
TOTAL=3

echo -e "=============================="
echo -e "    Chapter 08 通关验证"
echo -e "=============================="

# 任务 1: nohup 后台运行
# 预期: long_task.py 正在运行，且当前目录下有 nohup.out
if pgrep -f "long_task.py" > /dev/null; then
    if [ -f "nohup.out" ]; then
        echo -e "${GREEN}[PASS] 任务1: 任务已在后台运行且日志重定向正确${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务1: 进程在运行，但未找到 nohup.out${NC}"
        echo "       提示: 使用 nohup python3 long_task.py &"
    fi
else
    echo -e "${RED}[FAIL] 任务1: 未找到 long_task.py 进程${NC}"
    echo "       提示: 进程可能已经退出，或者没有正确放入后台。"
fi

# 任务 2: Systemd 服务配置
# 预期: my_web.service 文件内容被修正 (包含绝对路径)
# 这里我们不检查服务是否真的运行，因为在 Docker 容器中 systemd 可能不可用。
# 我们只检查配置文件的逻辑正确性。
if grep -q "ExecStart=/" my_web.service && grep -q "WorkingDirectory=/" my_web.service; then
    echo -e "${GREEN}[PASS] 任务2: Systemd 配置文件修复正确${NC}"
    ((PASS++))
else
    echo -e "${RED}[FAIL] 任务2: 配置文件仍有错误${NC}"
    echo "       提示: ExecStart 和 WorkingDirectory 必须使用绝对路径 (例如 /root/Chapter_08/lab/web_server.py)。"
    echo "             你可以用 pwd 命令查看当前路径。"
fi

# 任务 3: 模拟服务管理
# 预期: 能够用 curl 访问 8088 端口 (如果用户真的把服务跑起来了)
# 或者，如果 systemd 不可用，只要任务 2 通过了，我们就算通过，并给出提示。
if command -v systemctl >/dev/null 2>&1; then
    # 如果有 systemd，检查服务状态
    if systemctl is-active my_web >/dev/null 2>&1 || pgrep -f "web_server.py" > /dev/null; then
         echo -e "${GREEN}[PASS] 任务3: Web 服务正在运行${NC}"
         ((PASS++))
    else
         echo -e "${RED}[FAIL] 任务3: 服务未运行${NC}"
         echo "       提示: 尝试启动服务 (systemctl start my_web 或手动 python3 web_server.py &)"
    fi
else
    # 如果没有 systemd (例如在某些 Docker 容器中)，只要配置文件对了就算过
    echo -e "${GREEN}[PASS] 任务3: (环境无 systemd，跳过运行检查)${NC}"
    ((PASS++))
fi

echo -e "=============================="
if [ $PASS -eq $TOTAL ]; then
    echo -e "${GREEN}恭喜！你已经掌握了守护进程的奥秘！(3/3)${NC}"
    # 清理后台进程
    pkill -f "long_task.py"
else
    echo -e "${RED}还有任务未完成，请继续加油！($PASS/$TOTAL)${NC}"
fi
