# Chapter 02: 空间治理与批量处理 (Space Governance)

## 1. 实战背景 (The Pain Point)

作为一名开发者，文件系统就是你的战场。但战场往往充满混乱：

**场景一（强迫症噩梦）**：你接手了一个遗留项目，编译目录下到处都是编译产生的 `.o` 中间文件和 `.tmp` 临时文件，混杂在几百个源文件里。手动删？手会断。

**场景二（格式灾难）**：教务系统导出了一批作业，结果因为配置错误，所有文本文件的后缀都变成了 `.TEXT`（例如 `student_101.TEXT`），但评测脚本只认 `.txt`。你有 1000 个文件需要改名。

**场景三（磁盘报警）**：服务器突然报警“Disk Usage 99%”。你不知道是哪个疯狂的日志文件吃掉了空间，只知道它藏在某个深层目录下。

本章我们将学习如何批量管理文件和精准定位空间杀手。

## 2. 核心命令详解 (The Toolkit)

### 2.1 `find` - 精准制导导弹
Linux 中最强大的文件查找工具（比图形界面的搜索强一万倍）。
*   `find . -name "*.txt"`: 在当前目录及子目录下查找所有 `.txt` 文件。
*   `find . -name "*.o" -type f`: 查找名为 `*.o` 的**文件**（排除目录）。
*   `find . -size +10M`: 查找大于 10MB 的文件。
*   `find . -name "*.tmp" -delete`: **危险操作**。找到并直接删除。

### 2.2 `du` - 磁盘侦察兵 (Disk Usage)
*   `du -h`: 以人类可读的格式（K, M, G）显示目录大小。
*   `du -sh .`: 显示当前目录的总大小（Summary）。
*   `du -ah . | sort -rh | head -n 5`: **连招**。显示当前目录下最大的 5 个文件/目录。

### 2.3 `mv` - 移动与重命名 (Move)
*   `mv old.txt new.txt`: 重命名。
*   `mv file.txt ./dir/`: 移动。

### 2.4 `xargs` - 管道传送门 (Extended Arguments)
将前一个命令的输出，转换成后一个命令的参数。**批量处理的神器**。
*   `find . -name "*.TEXT" | xargs -I {} mv {} {}.bak`: 把找到的所有文件加上 .bak 后缀。

## 3. 正则与逻辑 (The Logic)

### 批量重命名的逻辑
在 Linux 中，批量重命名通常不直接用 `mv`（因为 `mv` 一次只能处理一个源文件到一个目标文件）。我们需要结合 `find` 或 `bash` 循环。

**Shell 循环法（推荐新手）**:
```bash
for file in *.TEXT; do
    mv "$file" "${file%.TEXT}.txt"
done
```
*   `${file%.TEXT}` 是 Bash 的字符串操作，意思是“删掉文件名末尾的 .TEXT”。

## 4. 实验手册 (Hands-on Lab)

请先在当前目录下运行初始化脚本，生成实验数据：
```bash
bash lab/init.sh
```
运行后，你的目录下会出现 `project_build/`, `submissions/`, `logs/`。

### 任务 1: 大扫除 (Clean Up)
**目标**: 进入 `project_build` 目录，删除该目录及其所有子目录下所有的 `.o` (Object file) 和 `.tmp` (Temporary file) 文件。
*   **注意**: 千万别误删了 `.c` 源代码文件！
*   *提示*: 使用 `find` 命令。你可以先 `find ...` 看看找对了没，再执行删除。

### 任务 2: 格式修正 (Batch Rename)
**目标**: 进入 `submissions` 目录，将所有后缀为 `.TEXT` 的文件重命名为 `.txt`。
*   *提示*: 参考“正则与逻辑”部分的 Shell 循环法，或者尝试搜索 `rename` 命令（如果系统有安装）。这里推荐用 `for` 循环练习。

### 任务 3: 寻找巨兽 (Space Hunter)
**目标**: `logs` 目录下藏着一个巨大的日志文件，导致磁盘空间紧张。请找到它并将其删除。
*   *提示*: 使用 `du -ah logs | sort -rh | head -n 5` 找出最大的文件。

## 5. 通关验证 (Verification)

完成以上三个任务后，运行验证脚本：

```bash
bash verify.sh
```

## 6. 避坑与原理 (Deep Dive)

1.  **`rm -rf` 的恐惧**: `find . -name "*.tmp" -exec rm {} \;` 或者 `find ... -delete` 是非常高效的，但也非常危险。**永远先运行不带删除功能的 `find` 确认一遍**，再执行删除。
2.  **文件名里的空格**: 如果文件名包含空格（如 `My Homework.txt`），简单的 `xargs` 或 `for` 循环可能会出错。
    *   **进阶**: 使用 `find ... -print0 | xargs -0 ...` 来完美处理带空格的文件名。
3.  **Inode**: 有时候你删除了大文件，但磁盘空间没释放？可能是因为有进程还打开着这个文件。Linux 是通过 Inode 引用文件的，只有引用计数为 0 才会真正释放 block。
