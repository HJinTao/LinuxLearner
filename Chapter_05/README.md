# Chapter 05: 自动化金字塔 (Scripting)

## 1. 实战背景 (The Pain Point)

**场景一（重复劳动）**：每天下班前，你都要手动打包代码，重命名为“项目名+日期.zip”，然后复制到备份服务器。这不仅无聊，而且容易忘。

**场景二（环境差异）**：你的代码在本地运行完美，但部署到测试环境就报错，因为你忘了复制配置文件。

**场景三（复杂的构建）**：编译一个项目需要执行 10 条命令，少一条都不行。新人入职第一天就卡在环境搭建上。

本章我们将学习如何编写 Shell 脚本，把这些繁琐的步骤变成“一键执行”。

## 2. 核心语法详解 (The Toolkit)

### 2.1 脚本起手式
每个脚本的第一行必须是 Shebang：
```bash
#!/bin/bash
```
告诉系统用哪个解释器来执行。

### 2.2 变量 (Variables)
*   **定义**: `NAME="Linux"` (注意：等号两边**不能有空格**！这是新手最容易犯的错)。
*   **使用**: `echo "Hello, $NAME"`。
*   **命令替换**: `DATE=$(date +%Y%m%d)` (把命令的输出结果赋值给变量)。

### 2.3 流程控制 (Flow Control)
**条件判断 (if)**:
```bash
if [ -d "backup" ]; then
    echo "Directory exists."
else
    mkdir "backup"
fi
```
*(注意：`[` 和 `]` 内部必须有空格)*

**循环 (Loop)**:
```bash
for file in *.txt; do
    echo "Processing $file..."
done
```

### 2.4 参数传递 (Arguments)
*   `$1`: 脚本的第一个参数。
*   `$2`: 第二个参数。
*   `$#`: 参数的总个数。

## 3. 实验手册 (Hands-on Lab)

请先在当前目录下运行初始化脚本：
```bash
bash lab/init.sh
```
这将生成 `my_project/` 目录和一个充满错误的 `bad_backup.sh`。

### 任务 1: Hello World 进阶版
**目标**: 编写一个名为 `hello.sh` 的脚本。
**需求**:
1.  接收一个参数（名字）。
2.  如果没有提供参数，输出 "Please provide a name." 并退出。
3.  如果提供了参数，输出 "Hello, [名字]!"。
**测试**:
`bash hello.sh` -> 报错提示
`bash hello.sh Alice` -> 输出 Hello, Alice!

### 任务 2: 修复备份脚本 (Debug & Fix)
**目标**: 修复 `bad_backup.sh`，并将其重命名为 `good_backup.sh`。
**需求**:
1.  修复变量定义的空格错误。
2.  修复 `mkdir` 逻辑（如果目录已存在，`mkdir` 会报错，可以用 `mkdir -p`）。
3.  修改打包命令：生成的压缩包名字应该是 `my_project_YYYYMMDD.tar.gz` (使用 `date` 命令)。
4.  运行修复后的脚本，确保 `backup/` 目录下生成了正确的文件。

### 任务 3: 一键部署 (Deployment)
**目标**: 编写 `deploy.sh`。
**需求**:
1.  将 `my_project/src` 下的所有 `.py` 文件复制到 `deploy_env/` 目录。
2.  复制完成后，输出 "Deployment success: [文件数量] files copied."。
*   *提示*: 可以结合 `cp`, `wc -l` 等命令。

## 4. 通关验证 (Verification)

运行验证脚本：

```bash
bash verify.sh
```

## 5. 避坑与原理 (Deep Dive)

1.  **空格陷阱**: 在 Bash 中，空格是分隔符。`A = B` 会被解析为：运行命令 `A`，参数是 `=` 和 `B`。所以赋值必须写成 `A=B`。
2.  **权限**: 脚本写完后，通常需要 `chmod +x script.sh` 赋予执行权限，然后用 `./script.sh` 运行。或者直接用 `bash script.sh` 运行。
3.  **set -e**: 在脚本开头加上 `set -e`，表示“一旦任何一行命令报错，脚本立即停止”。这是写健壮脚本的好习惯，防止错误滚雪球。
4.  **引号**: 引用变量时尽量加双引号 `"$VAR"`，防止变量内容包含空格导致解析错误。
