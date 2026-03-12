#!/bin/bash

# 验证脚本
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASS=0
TOTAL=3

echo -e "=============================="
echo -e "    Chapter 02 通关验证"
echo -e "=============================="

# 任务 1: 日志轮转策略
# 预期: 删除 var/log 中超过 7 天的文件，但保留 auth.log (即使它很旧)
if [ ! -f "var/log/app.log.1" ] && [ ! -f "var/log/app.log.2" ]; then
    if [ -f "var/log/auth.log.old" ] && [ -f "var/log/current.log" ]; then
        echo -e "${GREEN}[PASS] 任务1: 日志清理策略正确${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务1: 误删了重要文件 (auth.log.old 或 current.log)${NC}"
    fi
else
    echo -e "${RED}[FAIL] 任务1: 旧日志未被清理${NC}"
    echo "       提示: 检查 find 的 -mtime 参数和 -name 排除逻辑。"
fi

# 任务 2: 磁盘空间分析
# 预期: 生成 space_report.txt，列出 home/user 下各个子目录的大小，并排序。
# 必须包含 .cache 且它应该是最大的 (或接近最大)
if [ -f "space_report.txt" ]; then
    if grep -q ".cache" space_report.txt; then
        echo -e "${GREEN}[PASS] 任务2: 空间分析报告已生成${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务2: 报告中未发现 .cache 目录${NC}"
    fi
else
    echo -e "${RED}[FAIL] 任务2: 未找到 space_report.txt${NC}"
fi

# 任务 3: 空格文件处理
# 预期: 将 downloads/ 下的所有 .pdf 移动到 documents/ 下
if [ -f "documents/Tax Return 2023.pdf" ] && [ -f "documents/Project Spec v2.pdf" ] && [ -f "documents/My Resume.pdf" ]; then
    if [ ! -f "downloads/Tax Return 2023.pdf" ]; then
        echo -e "${GREEN}[PASS] 任务3: PDF 归档成功${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务3: 文件是复制过去了，但源文件未删除 (应该是移动)${NC}"
    fi
else
    echo -e "${RED}[FAIL] 任务3: documents 目录中缺少 PDF 文件${NC}"
    echo "       提示: 文件名包含空格，xargs 需要 -0 参数，find 需要 -print0。"
fi

echo -e "=============================="
if [ $PASS -eq $TOTAL ]; then
    echo -e "${GREEN}恭喜！所有任务已完成！(3/3)${NC}"
    echo -e "你已经是空间治理大师了！"
else
    echo -e "${RED}还有任务未完成，请继续加油！($PASS/$TOTAL)${NC}"
fi
