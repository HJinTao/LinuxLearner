#!/bin/bash

# 验证脚本
# 检查用户是否完成了挑战任务

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASS=0
TOTAL=3

echo -e "=============================="
echo -e "    Chapter 01 通关验证"
echo -e "=============================="

# 任务 1: 检查 error_report.txt
# 预期：包含 "ERROR" 或 "CRITICAL" 的行
if [ -f "error_report.txt" ]; then
    if grep -q "ERROR" error_report.txt && grep -q "CRITICAL" error_report.txt; then
        echo -e "${GREEN}[PASS] 任务1: 错误日志提取正确${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务1: error_report.txt 内容不完整或不正确${NC}"
        echo "       提示: 应该包含所有 ERROR 和 CRITICAL 级别的日志。"
    fi
else
    echo -e "${RED}[FAIL] 任务1: 未找到 error_report.txt 文件${NC}"
fi

# 任务 2: 检查 main_head.txt
# 预期：main.c 的前 5 行
if [ -f "main_head.txt" ]; then
    if grep -q "#include" main_head.txt && [ $(wc -l < main_head.txt) -eq 5 ]; then
        echo -e "${GREEN}[PASS] 任务2: 源码头部提取正确${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务2: main_head.txt 内容不正确${NC}"
        echo "       提示: 应该是 main.c 的前 5 行。"
    fi
else
    echo -e "${RED}[FAIL] 任务2: 未找到 main_head.txt 文件${NC}"
fi

# 任务 3: 检查 security_students.txt
# 预期：CyberSecurity 专业的学生
if [ -f "security_students.txt" ]; then
    if grep -q "Charlie" security_students.txt && grep -q "Eve" security_students.txt && grep -q "Heidi" security_students.txt && ! grep -q "Alice" security_students.txt; then
        echo -e "${GREEN}[PASS] 任务3: 学生筛选正确${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务3: security_students.txt 内容不正确${NC}"
        echo "       提示: 应该只包含 CyberSecurity 专业的学生。"
    fi
else
    echo -e "${RED}[FAIL] 任务3: 未找到 security_students.txt 文件${NC}"
fi

echo -e "=============================="
if [ $PASS -eq $TOTAL ]; then
    echo -e "${GREEN}恭喜！所有任务已完成！(3/3)${NC}"
    echo -e "你已经掌握了 Linux 文本处理的基本功！"
else
    echo -e "${RED}还有任务未完成，请继续加油！($PASS/$TOTAL)${NC}"
fi
