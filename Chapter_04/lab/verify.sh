#!/bin/bash

# 验证脚本
# 检查用户是否完成了网络相关的挑战

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASS=0
TOTAL=3

echo -e "=============================="
echo -e "    Chapter 04 通关验证"
echo -e "=============================="

# 任务 1: 检查 8080 端口是否被清理
# 预期：web_server.py 应该被杀死，8080 端口不再被占用
if ss -tuln | grep -q ":8080 "; then
    echo -e "${RED}[FAIL] 任务1: 端口 8080 仍然被占用！${NC}"
    echo "       提示: 使用 ss -lptn 找到占用 8080 的 PID，然后 kill 它。"
else
    echo -e "${GREEN}[PASS] 任务1: 端口冲突已解决 (8080 现已空闲)${NC}"
    ((PASS++))
fi

# 任务 2: 检查 api_response.json
# 预期：用户应该使用 curl 保存了 api 的响应
if [ -f "api_response.json" ]; then
    if grep -q "uptime" api_response.json; then
        echo -e "${GREEN}[PASS] 任务2: API 响应获取成功${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务2: api_response.json 内容不正确${NC}"
    fi
else
    echo -e "${RED}[FAIL] 任务2: 未找到 api_response.json 文件${NC}"
    echo "       提示: 启动 api_service.py 后，使用 curl 访问并保存结果。"
fi

# 任务 3: 检查 headers.txt
# 预期：用户获取了响应头
if [ -f "headers.txt" ]; then
    if grep -q "Content-type" headers.txt || grep -q "Server" headers.txt; then
        echo -e "${GREEN}[PASS] 任务3: 响应头信息获取成功${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务3: headers.txt 内容似乎不是 HTTP 头信息${NC}"
    fi
else
    echo -e "${RED}[FAIL] 任务3: 未找到 headers.txt 文件${NC}"
    echo "       提示: 使用 curl -I 保存头信息。"
fi

echo -e "=============================="
if [ $PASS -eq $TOTAL ]; then
    echo -e "${GREEN}恭喜！网络通畅！(3/3)${NC}"
    echo -e "你已经掌握了网络排查的核心技能！"
else
    echo -e "${RED}还有任务未完成，请继续加油！($PASS/$TOTAL)${NC}"
fi
