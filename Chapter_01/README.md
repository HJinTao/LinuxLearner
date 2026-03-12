# Chapter 01: 文本探针 (Text Detective)

## 1. 实战背景 (The Pain Point)

想象一下，你是一名刚入职的后端开发实习生。

**场景一**：你的主管突然甩给你一个 2GB 的服务器日志文件 `server.log`，并告诉你：“昨晚 8 点系统崩了一次，赶紧把所有报错信息找出来发给我，我 5 分钟后要开会。” —— 你还在手动翻页吗？

**场景二**：教务处的老师发来一份混乱的 CSV 成绩单 `grades.csv`，让你把所有“网络安全（CyberSecurity）”专业的学生名单整理出来。 —— 你还在用 Excel 的筛选功能吗？如果是 100 个这样的文件呢？

本章我们将化身“文本侦探”，学习如何不打开文件就能精准定位信息。

## 2. 核心命令详解 (The Toolkit)

在 Linux 中，我们很少直接用编辑器（如 vim/nano）打开大文件，因为那太慢了。我们使用流式处理工具。

### 2.1 `cat` - 也就是看看 (Concatenate)
最简单的查看文件命令，但通常配合管道使用。
*   `cat filename`: 显示整个文件内容。
*   `cat -n filename`: 显示内容并显示行号。

### 2.2 `head` & `tail` - 掐头去尾
*   `head -n 5 filename`: 查看文件的前 5 行（快速确认文件格式）。
*   `tail -n 10 filename`: 查看文件的最后 10 行（通常日志的最新报错就在这里）。
*   `tail -f filename`: **神器**。实时监控文件末尾的新增内容（实时看日志）。

### 2.3 `grep` - 文本搜查官 (Global Regular Expression Print)
最强大的文本搜索工具。
*   `grep "keyword" filename`: 找出包含 keyword 的所有行。
*   `grep -v "keyword" filename`: 反向查找，找出**不**包含 keyword 的行。
*   `grep -i "keyword" filename`: 忽略大小写。
*   `grep -n "keyword" filename`: 显示匹配行的行号。
*   `grep -E "pattern" filename`: 使用扩展正则表达式（更复杂的逻辑）。

> **新手引导**: 试着在终端输入 `man grep`，按 `q` 退出。学会查手册是高手的标志。

## 3. 正则与逻辑 (The Logic)

在搜索时，我们经常需要模糊匹配。

*   **管道符 `|`**: 将前一个命令的输出，作为后一个命令的输入。
    *   `cat server.log | grep "ERROR"` 等同于 `grep "ERROR" server.log`。
    *   但 `head -n 100 server.log | grep "ERROR"` 可以只搜前 100 行。

*   **重定向 `>`**: 将结果保存到文件。
    *   `grep "ERROR" server.log > errors.txt`：把搜到的结果写入 `errors.txt`。

## 4. 实验手册 (Hands-on Lab)

请先在当前目录下运行初始化脚本，生成实验数据：
```bash
bash lab/init.sh
```
运行后，你的目录下会出现 `server.log`, `grades.csv`, `main.c`。

### 任务 1: 抓捕嫌疑人 (Log Analysis)
**目标**: 从 `server.log` 中找出所有包含 "ERROR" 或 "CRITICAL" 的行，并将结果保存到 `error_report.txt`。
*   *提示*: 你可以运行两次 grep 并追加（`>>`），或者使用 `grep -E "ERROR|CRITICAL"`。

### 任务 2: 验明正身 (Code Inspection)
**目标**: 提取 `main.c` 的前 5 行，保存到 `main_head.txt`。我们需要确认这个文件是否包含了正确的头文件。
*   *提示*: 使用 `head` 命令。

### 任务 3: 人员筛选 (Data Mining)
**目标**: 从 `grades.csv` 中筛选出所有 "CyberSecurity" 专业的学生记录，保存到 `security_students.txt`。
*   *提示*: `grep` 可以直接搜索 CSV 中的特定单词。

## 5. 通关验证 (Verification)

完成以上三个任务后，运行验证脚本：

```bash
bash verify.sh
```

如果看到 `[PASS]` 和 `恭喜！所有任务已完成！`，说明你已经掌握了这一章的内容。

## 6. 避坑与原理 (Deep Dive)

1.  **管道缓冲区**: 当你使用 `tail -f server.log | grep "ERROR"` 时，可能会发现报错显示有延迟。这是因为 Linux 的管道有缓冲区（Buffer）。只有缓冲区满了，数据才会流向下一个命令。
2.  **grep 的颜色**: 在脚本中使用 grep 时，为了避免干扰，有时需要加上 `--color=never`，但在终端交互时，`--color=auto` 能帮你高亮关键字。
3.  **一切皆文本**: 在 Linux 中，无论是配置、日志还是代码，本质都是文本流。掌握了文本处理，你就掌握了 Linux 的半壁江山。
