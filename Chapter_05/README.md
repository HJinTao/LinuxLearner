# Chapter 05: 自动化金字塔 (Scripting)

## 1. 实战背景 (The Pain Point)

懒惰是程序员的美德。如果你需要重复做某件事超过 3 次，就应该写个脚本来自动完成。

*   **场景一 (The Broken Backup)**: 你的前任留下了一个备份脚本，但经常报错。你需要修复它的语法错误，并给备份文件加上时间戳。
*   **场景二 (Log Rotation)**: `logs/` 目录下有一堆过期的日志文件，你需要批量把它们的后缀从 `.log` 改为 `.log.bak`。
*   **场景三 (Health Check)**: 你需要每分钟检查一次 Web 服务器是否存活。如果挂了，自动发送报警（这里模拟为打印错误信息）。

本章我们将学习 Shell 脚本编程的基础：变量、循环、条件判断和函数。

## 2. 核心语法 (The Syntax)

Shell 脚本本质上就是把我们在终端输入的命令，写到一个文件里，加上逻辑控制。

### 2.1 变量 (Variables)
**注意**: 等号两边**不能有空格**！

*   **定义**: `NAME="Linux"` (正确) | `NAME = "Linux"` (错误！)
*   **引用**: `echo "Hello, $NAME"` 或 `echo "Hello, ${NAME}"` (推荐后者，更安全)。
*   **命令替换**: `DATE=$(date +%Y-%m-%d)` (把 date 命令的输出赋值给 DATE 变量)。

### 2.2 条件判断 (If-Else)
**注意**: `[` 和 `]` 内部必须有**空格**！

```bash
if [ -f "file.txt" ]; then
    echo "File exists."
else
    echo "File not found."
fi
```

**常用判断参数**:
| 参数 | 含义 | 示例 |
| :--- | :--- | :--- |
| `-f` | **f**ile | 文件存在且是普通文件。 | `[ -f "config.ini" ]` |
| `-d` | **d**irectory | 目录存在。 | `[ -d "/var/log" ]` |
| `-z` | **z**ero | 字符串长度为 0 (空)。 | `[ -z "$VAR" ]` |
| `-n` | **n**on-zero | 字符串长度不为 0 (非空)。 | `[ -n "$VAR" ]` |
| `-eq` | **eq**ual | 数值相等。 | `[ "$COUNT" -eq 10 ]` |
| `==` | equal | 字符串相等。 | `[ "$STR" == "yes" ]` |

### 2.3 循环 (Loops)
**For 循环**:
```bash
# 遍历当前目录下的所有 .txt 文件
for file in *.txt; do
    echo "Processing $file..."
done
```

### 2.4 特殊变量
*   `$1`, `$2`: 脚本接收到的第 1 个、第 2 个参数。
*   `$#`: 参数的总个数。
*   `$?`: 上一个命令的退出状态码 (0 表示成功，非 0 表示失败)。

## 3. 实验任务 (Hands-on Lab)

请先在 `Chapter_05` 目录下运行初始化脚本：
```bash
bash lab/init.sh
```

### 任务 1: 脚本医生 (Fix the Script)
**目标**: 目录下有一个 `bad_backup.sh`，它充满了语法错误和逻辑漏洞。
*   **要求**: 修复该脚本，使其满足以下要求：
    1.  变量赋值正确（去除空格）。
    2.  在创建目录前检查目录是否存在 (`if [ ! -d ... ]`)。
    3.  备份文件名必须包含当前日期 (格式: `project_backup_YYYYMMDD.tar.gz`)。
    4.  使用 `tar -czf` 创建压缩包 (gzip)。
    5.  运行脚本，确保在 `backups/` 目录下生成了正确的备份文件。

### 任务 2: 批量重命名 (Batch Rename)
**目标**: `logs/` 目录下有多个 `.log` 文件。
*   **要求**: 编写一个单行命令或脚本，使用 `for` 循环将所有 `.log` 文件重命名为 `.log.bak`。
    *   例如 `app_2023.log` -> `app_2023.log.bak`。
*   *提示*: `mv "$file" "${file}.bak"`。

### 任务 3: 网站存活检测 (Health Check)
**目标**: 编写一个脚本 `check_status.sh`，接收一个域名作为参数。
*   **要求**:
    1.  使用 `curl` 检查该域名的 HTTP 状态码。
    2.  如果状态码是 200，输出 "Site is UP"。
    3.  否则，输出 "Site is DOWN (Status: XXX)"。
*   *提示*:
    *   获取状态码: `CODE=$(curl -o /dev/null -s -w "%{http_code}" $1)`
    *   判断: `if [ "$CODE" -eq 200 ]; then ...`

## 4. 验证与通关

完成任务后，运行验证脚本：
```bash
bash lab/verify.sh
```
如果看到 `[PASS]`，恭喜你已经掌握了 Shell 脚本的魔法！

## 5. 进阶思考 (Deep Dive)

1.  **set -e**: 在脚本开头加上 `set -e`，可以让脚本在遇到任何错误（命令返回非 0）时立即停止执行。这在自动化部署中非常重要，防止错误级联。
2.  **ShellCheck**: 有一个神器叫 `shellcheck`，可以自动分析你的脚本并给出优化建议。在 VS Code 中有同名插件。
3.  **Cron**: 脚本写好了，怎么让它每天凌晨 2 点自动运行？你需要学习 `crontab`。
