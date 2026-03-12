#!/bin/bash

# 设置颜色变量
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[*] 初始化 Chapter 02 实验环境...${NC}"

# 1. 模拟日志目录 (Log Rotation Policy)
echo -e "${GREEN}[+] 生成 /var/log 模拟目录...${NC}"
mkdir -p var/log
# 生成一些"旧"日志 (通过 touch -d 修改时间戳)
# 注意: Mac 和 Linux 的 touch -d 语法不同，这里尝试兼容或使用 python
if [[ "$OSTYPE" == "darwin"* ]]; then
    # MacOS
    touch -d "$(date -v-10d +%Y-%m-%dT%H:%M:%S)" var/log/app.log.1
    touch -d "$(date -v-20d +%Y-%m-%dT%H:%M:%S)" var/log/app.log.2
    touch -d "$(date -v-30d +%Y-%m-%dT%H:%M:%S)" var/log/auth.log.old  # 这个是受保护的，虽然旧但不能删
    touch -d "$(date -v-2d +%Y-%m-%dT%H:%M:%S)" var/log/current.log
else
    # Linux
    touch -d "10 days ago" var/log/app.log.1
    touch -d "20 days ago" var/log/app.log.2
    touch -d "30 days ago" var/log/auth.log.old
    touch -d "2 days ago" var/log/current.log
fi

# 2. 模拟用户目录 (Disk Usage Analysis)
echo -e "${GREEN}[+] 生成 home/user 目录...${NC}"
mkdir -p home/user/videos
mkdir -p home/user/docs
mkdir -p home/user/projects
mkdir -p home/user/.cache

# 生成不同大小的文件 (使用 dd)
# Videos: 50MB total
dd if=/dev/zero of=home/user/videos/movie.mp4 bs=1M count=20 2>/dev/null
dd if=/dev/zero of=home/user/videos/show.mkv bs=1M count=30 2>/dev/null

# Projects: 10MB total
dd if=/dev/zero of=home/user/projects/code.tar.gz bs=1M count=10 2>/dev/null

# Docs: 1MB total
dd if=/dev/zero of=home/user/docs/thesis.pdf bs=1M count=1 2>/dev/null

# Cache: 100MB (垃圾文件，占用最多)
dd if=/dev/zero of=home/user/.cache/temp.dat bs=1M count=100 2>/dev/null

# 3. 模拟带空格的文件名 (Whitespace Hell)
echo -e "${GREEN}[+] 生成 downloads/ 目录 (含空格文件名)...${NC}"
mkdir -p downloads
mkdir -p documents # 目标目录

touch "downloads/Holiday Photo.jpg"
touch "downloads/Tax Return 2023.pdf"
touch "downloads/Project Spec v2.pdf"
touch "downloads/funny meme.png"
touch "downloads/My Resume.pdf"

echo -e "${GREEN}[✔] 环境初始化完成！${NC}"
echo -e "当前目录下已生成: var/, home/, downloads/, documents/"
