#!/bin/bash

# 设置颜色变量
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[*] 初始化 Chapter 05 实验环境...${NC}"

# 1. 创建模拟的源代码项目
echo -e "${GREEN}[+] 生成 my_project/ 源代码目录...${NC}"
mkdir -p my_project/src
mkdir -p my_project/config
mkdir -p my_project/docs

# 生成一些源文件
echo "print('Hello World')" > my_project/src/main.py
echo "def add(a, b): return a + b" > my_project/src/utils.py
echo "DB_HOST=localhost" > my_project/config/db.env
echo "# Documentation" > my_project/docs/README.md

# 2. 生成一个充满 Bug 的备份脚本 (Bad Script)
echo -e "${GREEN}[+] 生成需要修复的脚本 bad_backup.sh...${NC}"
cat > bad_backup.sh << 'EOF'
#!/bin/bash

# 这是一个有问题的备份脚本
# 你的任务是修复它，使其能够正确备份 my_project 目录

# 错误1: 变量赋值不能有空格
SOURCE_DIR = "./my_project"
BACKUP_DIR = "./backups"

# 错误2: 没有检查目录是否存在，直接创建可能会报错
mkdir $BACKUP_DIR

# 错误3: 生成的文件名是固定的，每次运行都会覆盖旧备份。应该加上时间戳。
ARCHIVE_NAME="project_backup.tar.gz"

echo "Starting backup..."

# 错误4: tar 命令参数不对，且没有压缩 (gzip)
# 这里的 cvf 只是打包，没有压缩
tar -cvf $ARCHIVE_NAME $SOURCE_DIR

# 错误5: 移动文件时，如果目标目录不存在怎么办？且变量引用未加引号
mv $ARCHIVE_NAME $BACKUP_DIR

echo "Backup completed successfully!"
EOF
chmod +x bad_backup.sh

# 3. 生成一个用于练习循环和条件的目录
echo -e "${GREEN}[+] 生成 logs/ 目录 (用于批量重命名练习)...${NC}"
mkdir -p logs
touch logs/app_2023_01_01.log
touch logs/app_2023_01_02.log
touch logs/app_2023_01_03.log
touch logs/error_2023_01_01.log
# 混入一个不需要处理的文件
touch logs/readme.txt

echo -e "${GREEN}[✔] 实验环境初始化完成！${NC}"
echo -e "当前目录下已生成: my_project/, bad_backup.sh, logs/"
