# Chapter 01: 文本探针 (Text Detective)

## 1. 实战背景 (The Pain Point)

作为一名后端工程师或运维人员，你每天都要和海量的文本打交道。

*   **场景一 (Security Audit)**: 安全团队发来警报，说内网有机器正在被暴力破解 SSH 密码。你需要从 500MB 的 `auth.log` 中，统计出某个可疑 IP 到底尝试了多少次，并提取出它的所有登录时间。
*   **场景二 (Crash Investigation)**: 线上支付服务突然挂了。监控显示在 `10:05:05` 抛出了 `CRITICAL` 错误。但是，光看错误信息 "Connection Refused" 是没用的，你需要知道错误发生**前 5 秒**系统在做什么，才能复现 Bug。
*   **场景三 (Code Debt)**: 项目要重构，主管让你把所有代码（包括子目录）里标记为 `TODO` 或 `FIXME` 的文件找出来，列一个清单。

本章我们将学习如何使用 Linux 的“文本探针”工具组，在不打开文件的情况下，精准定位、统计和分析信息。

## 2. 核心工具箱 (The Toolkit)

### 2.1 `grep` - 文本搜索瑞士军刀
`grep` (Global Regular Expression Print) 是最强大的文本搜索工具。

**基础用法**:
`grep [参数] "搜索内容" [文件]`

**详细参数说明**:

| 参数 | 英文全称 | 含义 | 示例 |
| :--- | :--- | :--- | :--- |
| `-i` | **i**gnore-case | **忽略大小写**。默认 grep 区分大小写，加上它后 "error", "ERROR", "Error" 都会被搜到。 | `grep -i "error" server.log` |
| `-v` | in**v**ert-match | **反向匹配**。只显示**不包含**关键词的行。用于排除干扰信息。 | `grep -v "INFO" server.log` (排除普通日志) |
| `-r` | **r**ecursive | **递归搜索**。在指定目录及其所有子目录下搜索。 | `grep -r "TODO" ./src` |
| `-l` | files-with-matches | **只列出文件名**。不显示具体的匹配行，只显示包含该关键词的文件路径。 | `grep -rl "TODO" ./src` (配合 -r 使用) |
| `-n` | **n**umber | **显示行号**。显示匹配行在文件中的行号。 | `grep -n "ERROR" server.log` |
| `-c` | **c**ount | **统计行数**。不打印匹配的内容，只输出匹配了多少行。 | `grep -c "ERROR" server.log` |
| `-B <N>` | **B**efore | **显示前 N 行**。除了匹配行，还显示它前面的 N 行上下文。 | `grep -B 5 "CRITICAL" server.log` |
| `-A <N>` | **A**fter | **显示后 N 行**。除了匹配行，还显示它后面的 N 行上下文。 | `grep -A 5 "CRITICAL" server.log` |
| `-C <N>` | **C**ontext | **显示前后 N 行**。同时显示前后上下文。 | `grep -C 5 "CRITICAL" server.log` |
| `-E` | **E**xtended-regexp | **扩展正则表达式**。允许使用 `|` (或) 等高级正则语法。 | `grep -E "ERROR|WARN" server.log` |

> **💡 小贴士**: 记不住参数？
> *   想看上下文？记 **A**fter, **B**efore, **C**ontext (ABC)。
> *   想排除？记 in**v**ert。
> *   想忽略大小写？记 **i**gnore。

### 2.2 `wc` - 这里的 wc 不是厕所 (Word Count)
用于统计文件的各种计数。

**详细参数说明**:

| 参数 | 英文全称 | 含义 | 示例 |
| :--- | :--- | :--- | :--- |
| `-l` | **l**ines | **统计行数**。最常用的参数。 | `wc -l file.txt` |
| `-w` | **w**ords | **统计单词数**。以空格/换行分隔。 | `wc -w file.txt` |
| `-c` | **c**haracters | **统计字节数**。 | `wc -c file.txt` |

**组合技**:
`grep "ERROR" server.log | wc -l`
(先找出所有 ERROR 行，再统计有多少行 = 统计错误出现的次数)

### 2.3 管道 (Pipe `|`) 与 重定向 (`>`)
*   **管道 `|`**: 管道就像流水线。它把上一个命令的**输出 (Output)**，直接插到下一个命令的**输入 (Input)** 口。
    *   *场景*: "把 `cat` 吐出来的内容，喂给 `grep` 吃，再把 `grep` 剩下的骨头，喂给 `head` 看。"
    *   `cat huge.log | grep "ERROR" | head -n 5`

*   **重定向 `>`**:
    *   `>` (覆盖): 把命令结果写入文件。**注意：如果文件存在，会先清空它！**
        *   `echo "Hello" > readme.txt`
    *   `>>` (追加): 把命令结果追加到文件末尾。不会清空原文件。
        *   `echo "World" >> readme.txt`

## 3. 实验任务 (Hands-on Lab)

请先在 `Chapter_01` 目录下运行初始化脚本：
```bash
bash lab/init.sh
```
这会生成 `auth.log` (安全日志), `server.log` (应用日志) 和 `project/` (代码库)。

### 任务 1: 安全审计 (Security Audit)
**目标**: 分析 `auth.log`，统计 IP `192.168.1.100` 发起的失败登录尝试 (`Failed password`) 一共有多少次。
*   **要求**: 将统计出的**数字**保存到 `attack_count.txt`。
*   *提示*:
    1.  先用 `grep` 过滤出包含该 IP 的行。
    2.  再通过管道 `|` 过滤出包含 "Failed password" 的行。
    3.  最后用 `wc -l` 统计行数，或者直接在最后一步用 `grep -c`。
    4.  别忘了把结果 `>` 重定向到文件。

### 任务 2: 崩溃现场还原 (Crash Investigation)
**目标**: 在 `server.log` 中，找到 `CRITICAL` 级别的错误。我们需要知道错误发生前的上下文。
*   **要求**: 提取包含 `CRITICAL` 的行，以及它**之前 (Before) 的 5 行**日志。将结果保存到 `crash_context.txt`。
*   *提示*: 这里的关键词是“之前” (Before)。使用 `grep` 对应参数即可。

### 任务 3: 技术债务扫描 (Code Debt Scan)
**目标**: 你的团队接手了一个旧项目 `project/`。请找出所有包含 `TODO` 或 `FIXME` 标记的文件。
*   **要求**: 递归搜索 `project/` 目录，只列出**文件名**，保存到 `code_debt.txt`。
*   *提示*:
    1.  需要递归搜索子目录，用什么参数？
    2.  只需要文件名，不需要代码内容，用什么参数？
    3.  关键词是 "TODO" 或 "FIXME"，可以用 `grep -E "TODO|FIXME"`。

## 4. 验证与通关

完成任务后，运行验证脚本：
```bash
bash lab/verify.sh
```
如果看到 `[PASS]`，说明你已经掌握了 Linux 文本处理的核心技能！

## 5. 进阶思考 (Deep Dive)

1.  **正则威力**: `grep -E` (Extended Regex) 允许使用更复杂的逻辑。例如 `grep -E "ERROR|WARN"` 可以同时搜索错误和警告。
2.  **效率**: 在几 GB 的日志文件中，`grep` 依然非常快。但如果是几百 GB，你可能需要 `awk` 或者专门的日志分析工具 (ELK Stack)。
3.  **Color**: 使用 `grep --color=auto` 可以高亮匹配的关键字，让你一眼看到重点。
