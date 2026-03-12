#!/bin/bash

# 验证脚本
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASS=0
TOTAL=3

echo -e "=============================="
echo -e "    Chapter 05 通关验证"
echo -e "=============================="

# 任务 1: 修复 bad_backup.sh
# 预期: backups/ 目录下应该有一个带日期的 .tar.gz 文件，且解压后包含 my_project
if [ -d "backups" ]; then
    BACKUP_FILE=$(find backups -name "project_backup_*.tar.gz" | head -n 1)
    if [ -n "$BACKUP_FILE" ]; then
        # 验证文件类型
        if file "$BACKUP_FILE" | grep -q "gzip compressed data"; then
             echo -e "${GREEN}[PASS] 任务1: 备份脚本修复成功${NC}"
             ((PASS++))
        else
             echo -e "${RED}[FAIL] 任务1: 备份文件不是 gzip 格式${NC}"
             echo "       提示: tar 命令需要加 -z 参数。"
        fi
    else
        echo -e "${RED}[FAIL] 任务1: 未找到符合格式的备份文件${NC}"
        echo "       提示: 文件名应包含日期 (date +%Y%m%d)，且在 backups 目录下。"
    fi
else
    echo -e "${RED}[FAIL] 任务1: backups 目录不存在${NC}"
fi

# 任务 2: 批量重命名日志
# 预期: logs 目录下不应存在 .log 文件，应全部变为 .log.bak (除了 readme.txt)
if [ -d "logs" ]; then
    LOG_COUNT=$(find logs -name "*.log" | wc -l)
    BAK_COUNT=$(find logs -name "*.log.bak" | wc -l)
    
    if [ "$LOG_COUNT" -eq 0 ] && [ "$BAK_COUNT" -ge 4 ]; then
        echo -e "${GREEN}[PASS] 任务2: 批量重命名成功${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务2: 重命名未完成${NC}"
        echo "       剩余 .log 文件数: $LOG_COUNT (应为 0)"
        echo "       .log.bak 文件数: $BAK_COUNT (应 >= 4)"
    fi
else
    echo -e "${RED}[FAIL] 任务2: logs 目录不存在${NC}"
fi

# 任务 3: 编写检查脚本 check_status.sh
# 预期: 脚本存在，且能正确检测 HTTP 状态
if [ -f "check_status.sh" ]; then
    # 赋予执行权限以防万一
    chmod +x check_status.sh
    # 模拟测试: 访问百度 (通常是 200 或 302)
    OUTPUT=$(./check_status.sh "www.baidu.com")
    if [[ "$OUTPUT" == *"UP"* ]] || [[ "$OUTPUT" == *"200"* ]] || [[ "$OUTPUT" == *"302"* ]]; then
        echo -e "${GREEN}[PASS] 任务3: 状态检查脚本工作正常${NC}"
        ((PASS++))
    else
        echo -e "${RED}[FAIL] 任务3: 脚本输出不符合预期${NC}"
        echo "       输入: www.baidu.com"
        echo "       输出: $OUTPUT"
        echo "       提示: 使用 curl -I -s -o /dev/null -w \"%{http_code}\" 获取状态码。"
    fi
else
    echo -e "${RED}[FAIL] 任务3: 未找到 check_status.sh${NC}"
fi

echo -e "=============================="
if [ $PASS -eq $TOTAL ]; then
    echo -e "${GREEN}恭喜！你已经掌握了 Shell 脚本的魔法！(3/3)${NC}"
    echo -e "现在你可以让服务器自己照顾自己了。"
else
    echo -e "${RED}还有任务未完成，请继续加油！($PASS/$TOTAL)${NC}"
fi
