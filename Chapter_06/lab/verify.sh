#!/bin/bash

# 验证脚本
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASS=0
TOTAL=4

echo -e "=============================="
echo -e "    Chapter 06 通关验证"
echo -e "=============================="

# 任务 1: deploy.sh 可执行
# 预期: 文件有 x 权限
if [ -x "deploy.sh" ]; then
    echo -e "${GREEN}[PASS] 任务1: deploy.sh 已变身可执行文件${NC}"
    ((PASS++))
else
    echo -e "${RED}[FAIL] 任务1: deploy.sh 仍然不可执行${NC}"
    echo "       提示: chmod +x deploy.sh"
fi

# 任务 2: id_rsa 权限收紧
# 预期: 权限必须是 600 (rw-------)
# 注意: Mac stat 和 Linux stat 语法不同
if [[ "$OSTYPE" == "darwin"* ]]; then
    PERM=$(stat -f "%OLp" id_rsa)
else
    PERM=$(stat -c "%a" id_rsa)
fi

if [ "$PERM" == "600" ]; then
    echo -e "${GREEN}[PASS] 任务2: id_rsa 私钥已加密保护 (600)${NC}"
    ((PASS++))
else
    echo -e "${RED}[FAIL] 任务2: id_rsa 权限不正确 ($PERM)${NC}"
    echo "       提示: SSH 私钥要求只有拥有者能读写 (chmod 600)。"
fi

# 任务 3: Web 目录权限开放
# 预期: 目录 755, 文件 644
if [[ "$OSTYPE" == "darwin"* ]]; then
    DIR_PERM=$(stat -f "%OLp" var/www/html)
    FILE_PERM=$(stat -f "%OLp" var/www/html/index.html)
else
    DIR_PERM=$(stat -c "%a" var/www/html)
    FILE_PERM=$(stat -c "%a" var/www/html/index.html)
fi

if [ "$DIR_PERM" == "755" ] && [ "$FILE_PERM" == "644" ]; then
    echo -e "${GREEN}[PASS] 任务3: Web 目录权限设置完美 (755/644)${NC}"
    ((PASS++))
else
    echo -e "${RED}[FAIL] 任务3: Web 权限不正确 (目录:$DIR_PERM, 文件:$FILE_PERM)${NC}"
    echo "       提示: 目录需要别人能进入(x)和读取(r) -> 755"
    echo "             文件需要别人能读取(r) -> 644"
fi

# 任务 4: Python 脚本可执行
if [ -x "run.py" ]; then
    echo -e "${GREEN}[PASS] 任务4: run.py 也可以跑了${NC}"
    ((PASS++))
else
    echo -e "${RED}[FAIL] 任务4: run.py 还是跑不动${NC}"
fi

echo -e "=============================="
if [ $PASS -eq $TOTAL ]; then
    echo -e "${GREEN}恭喜！你已经构建了坚固的权限堡垒！(4/4)${NC}"
    echo -e "Permission denied 再也拦不住你了。"
else
    echo -e "${RED}还有任务未完成，请继续加油！($PASS/$TOTAL)${NC}"
fi
