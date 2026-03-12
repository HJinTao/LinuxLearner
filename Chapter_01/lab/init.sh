#!/bin/bash

# 设置颜色变量
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[*] 初始化实验环境...${NC}"

# 1. 生成服务器日志 server.log
echo -e "${GREEN}[+] 生成 server.log (模拟服务器日志)...${NC}"
cat > server.log << EOF
[2023-10-01 08:00:01] INFO  Server starting up...
[2023-10-01 08:00:02] INFO  Loaded config file.
[2023-10-01 08:00:03] WARN  Memory usage is slightly high (65%).
[2023-10-01 08:00:05] INFO  Connection established with database.
EOF

# 生成一些重复的日志
for i in {1..50}; do
    echo "[2023-10-01 08:01:$i] INFO  Processing request #$i" >> server.log
done

# 插入错误信息
echo "[2023-10-01 08:02:10] ERROR Connection timed out (Error Code: 504)" >> server.log
echo "[2023-10-01 08:02:11] INFO  Retrying connection..." >> server.log
echo "[2023-10-01 08:02:15] ERROR Database connection failed (Error Code: 500)" >> server.log

for i in {51..100}; do
    echo "[2023-10-01 08:03:$i] INFO  Processing request #$i" >> server.log
done

echo "[2023-10-01 08:04:00] CRITICAL System overheating!" >> server.log

# 2. 生成成绩单 grades.csv
echo -e "${GREEN}[+] 生成 grades.csv (模拟学生成绩单)...${NC}"
cat > grades.csv << EOF
ID,Name,Department,Score
1001,Alice,ComputerScience,85
1002,Bob,Mathematics,92
1003,Charlie,CyberSecurity,78
1004,David,ComputerScience,58
1005,Eve,CyberSecurity,88
1006,Frank,Mathematics,65
1007,Grace,ComputerScience,95
1008,Heidi,CyberSecurity,90
1009,Ivan,ComputerScience,45
1010,Judy,Mathematics,82
EOF

# 3. 生成源代码文件 main.c
echo -e "${GREEN}[+] 生成 main.c (模拟源代码)...${NC}"
cat > main.c << EOF
#include <stdio.h>
#include <stdlib.h>

// TODO: Fix memory leak in this function
void process_data() {
    char *buffer = malloc(1024);
    // ... processing ...
}

int main() {
    printf("Server is running...\n");
    process_data();
    return 0;
}
EOF

echo -e "${GREEN}[✔] 环境初始化完成！${NC}"
echo -e "当前目录下已生成: server.log, grades.csv, main.c"
