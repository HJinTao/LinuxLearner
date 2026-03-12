#!/bin/bash

# 设置颜色变量
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[*] 初始化 Chapter 02 实验环境...${NC}"

# 1. 创建模拟的项目构建目录 (Project Build) - 用于 find & delete
echo -e "${GREEN}[+] 生成构建目录与临时文件...${NC}"
mkdir -p project_build/src/module_a
mkdir -p project_build/src/module_b
mkdir -p project_build/lib
mkdir -p project_build/tests

# 在不同深度生成 .o (object) 和 .tmp (temporary) 文件
touch project_build/main.o
touch project_build/src/module_a/utils.o
touch project_build/src/module_a/config.tmp
touch project_build/src/module_b/network.o
touch project_build/src/module_b/cache.tmp
touch project_build/lib/math.o
touch project_build/tests/test_main.o
touch project_build/tests/test_data.tmp

# 生成一些正常文件，确保不被误删
touch project_build/main.c
touch project_build/src/module_a/utils.c
touch project_build/src/module_b/network.c
touch project_build/README.md

# 2. 创建作业提交目录 (Submissions) - 用于批量重命名
echo -e "${GREEN}[+] 生成作业提交目录...${NC}"
mkdir -p submissions
# 模拟 20 个学生提交了错误的后缀名 (.TEXT 而不是 .txt)
for i in {1001..1020}; do
    echo "Homework content for student $i" > "submissions/student_${i}.TEXT"
done
# 混入几个正确的文件
echo "Homework content" > submissions/student_1021.txt
echo "Homework content" > submissions/student_1022.txt

# 3. 创建隐藏的垃圾大文件 (Hidden Space Eater)
echo -e "${GREEN}[+] 生成隐藏的大文件...${NC}"
mkdir -p logs/archive/2023/11
# 创建一个 50MB 的大文件 (在 Linux/Mac 下用 dd，Windows git bash 也支持)
# 为了兼容性，我们写入大量文本
echo "Generating large log file..."
for i in {1..50000}; do
    echo "This is a very long log line that takes up space on the disk to simulate a large log file caused by an error loop." >> logs/archive/2023/11/debug_trace.log
done
# 复制几次以增大体积
cp logs/archive/2023/11/debug_trace.log logs/archive/2023/11/debug_trace.log.bak
cat logs/archive/2023/11/debug_trace.log.bak >> logs/archive/2023/11/debug_trace.log
cat logs/archive/2023/11/debug_trace.log.bak >> logs/archive/2023/11/debug_trace.log
rm logs/archive/2023/11/debug_trace.log.bak

# 创建一些小日志文件作为干扰
touch logs/access.log
touch logs/error.log
touch logs/archive/2023/10/old.log

echo -e "${GREEN}[✔] 环境初始化完成！${NC}"
echo -e "当前目录下已生成: project_build/, submissions/, logs/"
