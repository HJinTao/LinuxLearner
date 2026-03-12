# Vol.7: 软件与归档 (Packages & Archives)

## 1. 实战背景 (The Pain Point)

当你接手一个旧项目时，通常会收到一个 `source_code.tar.gz` 压缩包。或者，你在部署前需要备份当前的配置文件。
在 Windows 上，你习惯右键“解压”或“压缩”，但在 Linux 服务器的黑框框里，你需要掌握命令行归档的艺术。此外，手动编译安装软件也是高阶玩家的必修课。

## 2. 核心命令详解 (The Toolkit)

| 命令 | 常用参数 | 说明 |
| :--- | :--- | :--- |
| `tar` | `-czvf`, `-xzvf` | 打包/解包工具（Tape Archive） |
| `zip` / `unzip` | `-r` | 处理 .zip 格式（Windows 兼容性好） |
| `apt` | `update`, `install` | Ubuntu/Debian 的软件包管理器 |
| `wget` | `-O` | 从网络下载文件 |

> **查阅手册**: 输入 `man tar` 查看那几十个参数的含义。

## 3. 正则与逻辑 (The Logic)

### 3.1 Tar 参数速记 (czvf vs xzvf)

`tar` 命令的参数组合就像咒语，但其实有逻辑可循：

*   **c** (Create): 创建包
*   **x** (eXtract): 解包
*   **z** (Gzip): 使用 gzip 压缩（通常对应 .tar.gz）
*   **v** (Verbose): 显示详细过程（看着文件一个个出来很解压）
*   **f** (File): 指定文件名（**必须放在最后**）

**口诀：**
*   打包：`czvf` (Create Zip Verbose File) -> "创造压缩文件"
*   解包：`xzvf` (eXtract Zip Verbose File) -> "解压压缩文件"

### 3.2 软件安装三部曲

虽然 `apt install` 很方便，但有时你需要从源码安装（如安装特定版本的 Redis）：
1.  `wget http://.../redis.tar.gz` (下载)
2.  `tar -xzvf redis.tar.gz` (解压)
3.  `cd redis` && `./configure` && `make` && `sudo make install` (编译安装)

## 4. 实验手册 (Hands-on Lab)

请先运行初始化脚本：
```bash
cd Chapter_07/lab
./init.sh
```

进入 `Chapter_07/lab` 目录，完成以下任务：

### 任务 1: 解救旧代码
目录下有一个 `legacy_code.tar.gz` 文件。
**目标**: 将其解压到当前目录。解压后你应该能看到 `legacy_code/` 文件夹。

### 任务 2: 备份配置文件
目录下有一个 `config/` 文件夹，里面存放着重要的配置。
**目标**: 将 `config/` 文件夹打包并压缩为 `config_backup.tar.gz`。

### 任务 3: 跨平台压缩
为了发给使用 Windows 的同事，我们需要用 `zip` 格式。
**目标**: 将 `logs/` 文件夹打包为 `logs.zip`。

## 5. 通关验证 (Verification)

完成所有任务后，运行验证脚本：
```bash
cd ..
./verify.sh
```
如果看到 `PASS`，恭喜你掌握了 Linux 的文件搬运术！

## 6. 避坑与原理 (Deep Dive)

*   **万能的解压命令**: 在现代 Linux 中，`tar` 非常智能，通常不需要加 `-z` (gzip) 或 `-j` (bzip2)，它能自动识别格式。直接 `tar -xf file.tar.gz` 也能工作。
*   **权限保留**: `tar` 会默认保留文件的权限信息，这对于备份系统文件至关重要。`cp` 命令如果没有 `-p` 参数则会丢失权限。
*   **管道流**: `tar` 可以结合 `ssh` 实现远程备份，例如：`tar -czf - folder/ | ssh user@host "cat > backup.tar.gz"`。
