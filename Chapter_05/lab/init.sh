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

# 2. 生成一个需要修复的烂脚本 (Bad Script)
echo -e "${GREEN}[+] 生成需要修复的脚本 bad_backup.sh...${NC}"
cat > bad_backup.sh << 'EOF'
#!/bin/bash
# 这是一个有问题的备份脚本
# 任务：修复它，使其能够正确备份 my_project 目录

# 1. 变量定义 (这里有错，变量赋值不能有空格)
BACKUP_DIR = "./backup"
SOURCE_DIR="./my_project"

# 2. 创建目录 (这里没有检查目录是否存在)
mkdir $BACKUP_DIR

# 3. 执行备份 (这里使用了错误的压缩命令参数，且没有时间戳)
tar -cvf backup.tar $SOURCE_DIR

# 4. 移动文件 (这里变量引用没加引号，如果目录有空格会挂)
mv backup.tar $BACKUP_DIR/

echo "Backup done!"
EOF
chmod +x bad_backup.sh

# 3. 创建一个模拟的部署环境
mkdir -p deploy_env

echo -e "${GREEN}[✔] 实验环境初始化完成！${NC}"
echo -e "当前目录下已生成: my_project/, bad_backup.sh"
