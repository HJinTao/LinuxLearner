#!/bin/bash

# 验证脚本
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASS=0
TOTAL=3

echo -e "=============================="
echo -e "    Chapter 07 通关验证"
echo -e "=============================="

# 任务 1: 源码编译安装
# 预期: redis-5.0.0 目录存在，且生成了 src/redis-server
if [ -d "redis-5.0.0" ]; then
    if [ -f "redis-5.0.0/src/redis-server" ]; then
        echo -e "${GREEN}[PASS] 任务1: Redis 源码编译成功${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务1: 未找到 src/redis-server${NC}"
        echo "       提示: 你是否执行了 ./configure 和 make？"
    fi
else
    echo -e "${RED}[FAIL] 任务1: 未解压源码包${NC}"
    echo "       提示: 使用 tar -xzf 解压 redis-5.0.0.tar.gz"
fi

# 任务 2: 网站数据备份
# 预期: web_backup.tar.gz 存在，且包含 var/www/html 目录
if [ -f "web_backup.tar.gz" ]; then
    # 使用 tar -tf 查看包内容，不解压
    if tar -tf web_backup.tar.gz | grep -q "var/www/html"; then
        echo -e "${GREEN}[PASS] 任务2: 网站备份包创建成功${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务2: 备份包内容不正确${NC}"
        echo "       提示: 应该包含 var/www/html 目录。"
    fi
else
    echo -e "${RED}[FAIL] 任务2: 未找到 web_backup.tar.gz${NC}"
fi

# 任务 3: 事故日志解压
# 预期: logs_analysis 目录存在，且包含 auth.log
if [ -d "logs_analysis" ]; then
    if [ -f "logs_analysis/auth.log" ]; then
        echo -e "${GREEN}[PASS] 任务3: 日志包解压成功${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务3: 目录存在但文件缺失${NC}"
    fi
else
    echo -e "${RED}[FAIL] 任务3: 未找到 logs_analysis 目录${NC}"
    echo "       提示: 使用 unzip 解压 incident_logs.zip。"
fi

echo -e "=============================="
if [ $PASS -eq $TOTAL ]; then
    echo -e "${GREEN}恭喜！你已经掌握了 Linux 软件打包与分发的奥义！(3/3)${NC}"
else
    echo -e "${RED}还有任务未完成，请继续加油！($PASS/$TOTAL)${NC}"
fi
