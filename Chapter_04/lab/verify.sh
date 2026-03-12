#!/bin/bash

# 验证脚本
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASS=0
TOTAL=3

echo -e "=============================="
echo -e "    Chapter 04 通关验证"
echo -e "=============================="

# 任务 1: Web 服务连通性
# 预期: web_response.txt 包含 HTML 目录列表或 index.html 内容
if [ -f "web_response.txt" ]; then
    if grep -q "Directory listing" web_response.txt || grep -q "html" web_response.txt; then
        echo -e "${GREEN}[PASS] 任务1: Web 服务访问成功${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务1: web_response.txt 内容不正确${NC}"
        echo "       提示: 应该是 curl localhost:8080 的输出。"
    fi
else
    echo -e "${RED}[FAIL] 任务1: 未找到 web_response.txt${NC}"
fi

# 任务 2: API 接口测试
# 预期: api_status.json 包含 "status": "ok"
if [ -f "api_status.json" ]; then
    if grep -q '"status": "ok"' api_status.json; then
        echo -e "${GREEN}[PASS] 任务2: API 接口调用成功${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务2: API 响应内容不正确${NC}"
        echo "       提示: 请检查 curl 的 URL 是否正确 (/api/status)。"
    fi
else
    echo -e "${RED}[FAIL] 任务2: 未找到 api_status.json${NC}"
fi

# 任务 3: 寻找后门 Flag
# 预期: flag.txt 包含 FLAG{...}
if [ -f "flag.txt" ]; then
    if grep -q "FLAG{Network_Ninja_2024}" flag.txt; then
        echo -e "${GREEN}[PASS] 任务3: 成功获取后门 Flag${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务3: Flag 不正确${NC}"
        echo "       提示: 使用 ss -lntp 找出 50000-60000 之间的端口，然后用 nc 连接。"
    fi
else
    echo -e "${RED}[FAIL] 任务3: 未找到 flag.txt${NC}"
fi

echo -e "=============================="
if [ $PASS -eq $TOTAL ]; then
    echo -e "${GREEN}恭喜！你已经精通了网络侦探技能！(3/3)${NC}"
    # 自动清理
    if [ -f ".web_pid" ]; then
        kill $(cat .web_pid) 2>/dev/null
        kill $(cat .api_pid) 2>/dev/null
        kill $(cat .backdoor_pid) 2>/dev/null
        rm .web_pid .api_pid .backdoor_pid
        echo -e "已自动清理后台测试服务。"
    fi
else
    echo -e "${RED}还有任务未完成，请继续加油！($PASS/$TOTAL)${NC}"
fi
