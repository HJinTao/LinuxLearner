#!/bin/bash

# 验证脚本
# 检查用户是否完成了挑战任务

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASS=0
TOTAL=3

echo -e "=============================="
echo -e "    Chapter 02 通关验证"
echo -e "=============================="

# 任务 1: 清理编译垃圾
# 预期：project_build 目录下不应存在 .o 或 .tmp 文件，但 .c 文件必须保留
if [ -d "project_build" ]; then
    O_COUNT=$(find project_build -name "*.o" | wc -l)
    TMP_COUNT=$(find project_build -name "*.tmp" | wc -l)
    C_COUNT=$(find project_build -name "*.c" | wc -l)
    
    if [ "$O_COUNT" -eq 0 ] && [ "$TMP_COUNT" -eq 0 ] && [ "$C_COUNT" -ge 3 ]; then
        echo -e "${GREEN}[PASS] 任务1: 编译垃圾清理完成${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务1: 清理不彻底或误删文件${NC}"
        echo "       剩余 .o 文件数: $O_COUNT (应为 0)"
        echo "       剩余 .tmp 文件数: $TMP_COUNT (应为 0)"
        echo "       剩余 .c 文件数: $C_COUNT (应 >= 3)"
    fi
else
    echo -e "${RED}[FAIL] 任务1: project_build 目录不存在${NC}"
fi

# 任务 2: 批量重命名
# 预期：submissions 目录下不应存在 .TEXT 文件，应全部变为 .txt
if [ -d "submissions" ]; then
    TEXT_COUNT=$(find submissions -name "*.TEXT" | wc -l)
    TXT_COUNT=$(find submissions -name "*.txt" | wc -l)
    
    if [ "$TEXT_COUNT" -eq 0 ] && [ "$TXT_COUNT" -ge 22 ]; then
        echo -e "${GREEN}[PASS] 任务2: 批量重命名完成${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务2: 重命名未完成${NC}"
        echo "       剩余 .TEXT 文件数: $TEXT_COUNT (应为 0)"
        echo "       当前 .txt 文件数: $TXT_COUNT (应 >= 22)"
    fi
else
    echo -e "${RED}[FAIL] 任务2: submissions 目录不存在${NC}"
fi

# 任务 3: 找到并删除大文件
# 预期：logs 目录下那个最大的 debug_trace.log 应该被删除
if [ -d "logs" ]; then
    if [ ! -f "logs/archive/2023/11/debug_trace.log" ]; then
        echo -e "${GREEN}[PASS] 任务3: 大文件清理完成${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务3: 大文件 debug_trace.log 仍然存在${NC}"
        echo "       提示: 请使用 find 或 du 定位并删除它。"
    fi
else
    echo -e "${RED}[FAIL] 任务3: logs 目录不存在${NC}"
fi

echo -e "=============================="
if [ $PASS -eq $TOTAL ]; then
    echo -e "${GREEN}恭喜！所有任务已完成！(3/3)${NC}"
    echo -e "你已经是空间治理大师了！"
else
    echo -e "${RED}还有任务未完成，请继续加油！($PASS/$TOTAL)${NC}"
fi
