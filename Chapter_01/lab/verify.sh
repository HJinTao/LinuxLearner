#!/bin/bash

# 验证脚本
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASS=0
TOTAL=3

echo -e "=============================="
echo -e "    Chapter 01 通关验证"
echo -e "=============================="

# 任务 1: 统计攻击次数
# 预期: 统计 auth.log 中 IP 192.168.1.100 的 "Failed password" 次数，保存到 attack_count.txt
if [ -f "attack_count.txt" ]; then
    COUNT=$(cat attack_count.txt | tr -d ' \n\r')
    if [ "$COUNT" -eq 50 ]; then
        echo -e "${GREEN}[PASS] 任务1: 攻击统计正确 (50次)${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务1: 统计结果不正确 (你的结果: $COUNT, 预期: 50)${NC}"
    fi
else
    echo -e "${RED}[FAIL] 任务1: 未找到 attack_count.txt${NC}"
fi

# 任务 2: 提取崩溃上下文
# 预期: 提取 server.log 中 "CRITICAL" 及其前 5 行，保存到 crash_context.txt
if [ -f "crash_context.txt" ]; then
    if grep -q "CRITICAL Payment Gateway Connection Refused!" crash_context.txt && grep -q "User initiated payment" crash_context.txt; then
        echo -e "${GREEN}[PASS] 任务2: 上下文提取正确${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务2: 内容不完整${NC}"
        echo "       提示: 应该包含 CRITICAL 错误行以及它之前的 5 行日志。"
    fi
else
    echo -e "${RED}[FAIL] 任务2: 未找到 crash_context.txt${NC}"
fi

# 任务 3: 扫描代码债务
# 预期: 递归搜索 project 目录下的 "TODO" 或 "FIXME"，只保存文件名到 code_debt.txt
if [ -f "code_debt.txt" ]; then
    if grep -q "main.c" code_debt.txt && grep -q "utils.py" code_debt.txt && grep -q "index.html" code_debt.txt; then
        # 检查是否包含不该有的内容 (如具体代码行，任务要求只保存文件名)
        if grep -q "Refactor" code_debt.txt; then
             echo -e "${RED}[FAIL] 任务3: 格式错误${NC}"
             echo "       提示: 应该只保存文件名 (使用 grep -l)"
        else
            echo -e "${GREEN}[PASS] 任务3: 代码扫描正确${NC}"
            ((PASS++))
        fi
    else
        echo -e "${RED}[FAIL] 任务3: 遗漏了部分文件${NC}"
    fi
else
    echo -e "${RED}[FAIL] 任务3: 未找到 code_debt.txt${NC}"
fi

echo -e "=============================="
if [ $PASS -eq $TOTAL ]; then
    echo -e "${GREEN}恭喜！所有任务已完成！(3/3)${NC}"
else
    echo -e "${RED}还有任务未完成，请继续加油！($PASS/$TOTAL)${NC}"
fi
