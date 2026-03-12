# Chapter 07: 软件与归档 (Packages & Archives)

## 1. 实战背景 (The Pain Point)

在 Linux 世界，软件分发主要有两种方式：包管理器（如 `apt`, `yum`）和源码编译（Source Code）。

*   **场景一 (Source Compile)**: 你的项目依赖 Redis 5.0.0 的某个特性，但系统的 `apt` 源里只有 Redis 4.0。你必须下载源码包，手动编译安装。
*   **场景二 (Backup & Restore)**: 网站要升级了，你需要把整个 `/var/www/html` 目录打包备份，万一升级失败还能回滚。
*   **场景三 (Incident Response)**: 生产环境出事了，运维把几百兆的日志打包成 `incident_logs.zip` 发给你分析。你需要解压并查看里面的 `auth.log`。

本章我们将学习如何从源码构建软件，以及如何熟练地打包和解包各种格式的文件。

## 2. 核心工具箱 (The Toolkit)

### 2.1 `tar` - 磁带归档 (Tape Archive)
Linux 下最常用的打包工具。它最初是为磁带备份设计的，所以名字叫 Tape ARchive。

**常用参数 (必背)**:
*   `-c`: **C**reate (创建包)
*   `-x`: e**X**tract (解包)
*   `-z`: g**Z**ip (使用 gzip 压缩/解压，通常对应 .tar.gz)
*   `-v`: **V**erbose (显示详细过程)
*   `-f`: **F**ile (指定文件名，**必须放在最后**)

**组合技**:
*   **解压 (.tar.gz)**: `tar -xzvf file.tar.gz`
    *   *口诀*: **X**tract **Z**ip **V**erbose **F**ile (解压-压缩-详细-文件)
*   **打包 (.tar.gz)**: `tar -czvf backup.tar.gz ./data`
    *   *口诀*: **C**reate **Z**ip **V**erbose **F**ile (创建-压缩-详细-文件)

### 2.2 `zip` & `unzip` - 跨平台友好
Windows 和 Mac 用户最熟悉的格式。如果你的文件要发给 Windows 用户，请用 zip。

*   **解压**: `unzip file.zip`
*   **打包**: `zip -r archive.zip ./folder`
    *   `-r`: **R**ecursive (递归打包目录)

### 2.3 源码编译三部曲 (The Holy Trinity)
当你下载了一个源码包 (如 `.tar.gz`)，通常需要经过三步才能把它变成可执行程序：

1.  **`./configure`**: **配置**。检查你的系统环境（有没有 GCC 编译器？有没有依赖库？），并生成 `Makefile`。
2.  **`make`**: **编译**。根据 `Makefile` 的指示，调用编译器（如 gcc）把源代码翻译成二进制机器码。
3.  **`make install`**: **安装**。把生成的二进制文件、配置文件、文档复制到系统目录（如 `/usr/local/bin`）。通常需要 `sudo`。

## 3. 实验任务 (Hands-on Lab)

请先在 `Chapter_07` 目录下运行初始化脚本：
```bash
bash lab/init.sh
```

### 任务 1: 源码编译安装 Redis (Compile from Source)
**目标**: 目录下有一个模拟的 `redis-5.0.0.tar.gz` 源码包。
*   **要求**:
    1.  解压源码包 (`tar -xzvf`)。
    2.  进入解压后的目录。
    3.  运行 `./configure` 进行配置。
    4.  运行 `make` 进行编译（会生成 `src/redis-server`）。
    5.  (可选) 运行 `make install` 模拟安装。

### 任务 2: 网站数据备份 (Backup)
**目标**: 目录下有一个 `var/www/html` 目录，模拟网站数据。
*   **要求**: 将 `var/www/html` 目录打包并压缩为 `web_backup.tar.gz`。
*   *提示*: `tar -czvf web_backup.tar.gz var/www/html`。

### 任务 3: 事故日志分析 (Incident Response)
**目标**: 目录下有一个 `incident_logs.zip` (或 `.tar`，取决于你的环境)。
*   **要求**: 解压这个包到当前目录。你应该能看到 `logs_analysis/` 目录。
*   *提示*: 使用 `unzip` 或 `tar`。

## 4. 验证与通关

完成任务后，运行验证脚本：
```bash
bash lab/verify.sh
```
如果看到 `[PASS]`，恭喜你掌握了 Linux 软件打包与分发的奥义！

## 5. 进阶思考 (Deep Dive)

1.  **依赖地狱 (Dependency Hell)**: 源码编译最痛苦的是缺依赖（报错 `error: xxx not found`）。你需要根据报错信息，用 `apt install libxxx-dev` 安装对应的开发库。
2.  **包管理器 (`apt`/`yum`)**: 为什么优先用包管理器？因为它们自动处理依赖，且方便升级和卸载。只有在包管理器版本太老或没有对应软件时，才考虑源码编译。
3.  **Docker**: 现代部署中，我们倾向于使用 Docker 容器，因为它把环境和依赖都打包在一起了，彻底解决了“在我电脑上能跑”的问题。
