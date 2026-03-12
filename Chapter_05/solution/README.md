# 参考答案

## 任务 1: hello.sh
```bash
#!/bin/bash

if [ -z "$1" ]; then
    echo "Please provide a name."
    exit 1
fi

echo "Hello, $1!"
```

## 任务 2: good_backup.sh (修复后的脚本)
```bash
#!/bin/bash

# 1. 变量定义 (去掉了空格)
BACKUP_DIR="./backup"
SOURCE_DIR="./my_project"
# 获取当前日期
DATE=$(date +%Y%m%d)
ARCHIVE_NAME="my_project_$DATE.tar.gz"

# 2. 创建目录 (-p 避免报错)
mkdir -p "$BACKUP_DIR"

# 3. 执行备份 (使用 tar -czf 创建 gzip 压缩包)
echo "Backing up to $BACKUP_DIR/$ARCHIVE_NAME..."
tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" "$SOURCE_DIR"

echo "Backup done!"
```

## 任务 3: deploy.sh
```bash
#!/bin/bash

SRC_DIR="my_project/src"
DEST_DIR="deploy_env"

# 确保目标目录存在
mkdir -p "$DEST_DIR"

# 复制文件
cp "$SRC_DIR"/*.py "$DEST_DIR"

# 统计数量
COUNT=$(ls "$SRC_DIR"/*.py | wc -l)

echo "Deployment success: $COUNT files copied."
```
