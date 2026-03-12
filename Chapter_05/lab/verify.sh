#!/bin/bash

# 验证脚本
# 检查用户是否编写了正确的自动化脚本

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASS=0
TOTAL=3

echo -e "=============================="
echo -e "    Chapter 05 通关验证"
echo -e "=============================="

# 任务 1: 检查 hello.sh
# 预期：存在 hello.sh，且执行后输出 "Hello, [你的名字]"
if [ -f "hello.sh" ]; then
    # 尝试运行并捕获输出
    OUTPUT=$(bash hello.sh "Tester" 2>/dev/null)
    if [[ "$OUTPUT" == *"Hello, Tester"* ]]; then
        echo -e "${GREEN}[PASS] 任务1: Hello 脚本编写正确${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务1: hello.sh 输出不正确${NC}"
        echo "       预期输出包含: 'Hello, Tester'"
        echo "       实际输出: '$OUTPUT'"
    fi
else
    echo -e "${RED}[FAIL] 任务1: 未找到 hello.sh${NC}"
fi

# 任务 2: 检查备份文件
# 预期：backup/ 目录下应该有一个带日期的 tar.gz 文件
if [ -d "backup" ]; then
    # 查找 backup 目录下是否有 .tar.gz 文件
    BACKUP_FILE=$(find backup -name "my_project_*.tar.gz" | head -n 1)
    if [ -n "$BACKUP_FILE" ]; then
        echo -e "${GREEN}[PASS] 任务2: 自动备份脚本运行成功${NC}"
        echo "       发现备份文件: $BACKUP_FILE"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务2: 未在 backup/ 目录下发现符合格式的备份文件${NC}"
        echo "       提示：文件名应包含日期，如 my_project_20231001.tar.gz"
    fi
else
    echo -e "${RED}[FAIL] 任务2: backup 目录不存在${NC}"
fi

# 任务 3: 检查部署脚本 deploy.sh
# 预期：deploy.sh 应该能把 src 下的文件复制到 deploy_env
if [ -f "deploy.sh" ]; then
    # 模拟运行一下 (为了安全，我们在沙盒里检查内容)
    if grep -q "cp -r" deploy.sh || grep -q "rsync" deploy.sh; then
         # 检查 deploy_env 是否有文件
         if [ -f "deploy_env/main.py" ]; then
            echo -e "${GREEN}[PASS] 任务3: 部署脚本逻辑正确${NC}"
            ((PASS++))
         else
            echo -e "${RED}[FAIL] 任务3: deploy_env 目录是空的${NC}"
            echo "       提示: 请运行你的 deploy.sh 试试。"
         fi
    else
        echo -e "${RED}[FAIL] 任务3: deploy.sh 似乎没有复制命令${NC}"
    fi
else
    echo -e "${RED}[FAIL] 任务3: 未找到 deploy.sh${NC}"
fi

echo -e "=============================="
if [ $PASS -eq $TOTAL ]; then
    echo -e "${GREEN}恭喜！你已经站在自动化金字塔顶端了！(3/3)${NC}"
    echo -e "Shell 脚本将是你最忠实的仆人。"
else
    echo -e "${RED}还有任务未完成，请继续加油！($PASS/$TOTAL)${NC}"
fi
