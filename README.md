# Linux 实战课程 (Linux Learner)

欢迎来到 Linux 实战课程！本课程专为开发者设计，旨在通过真实的运维场景和痛点，帮助你掌握 Linux 核心命令与系统管理技能。告别枯燥的参数背诵，从“解决问题”开始你的 Linux 之旅。

## 🚀 项目简介

本课程采用 **“场景驱动” (Scenario-Driven)** 的教学模式。每一章都从一个具体的“痛点”出发（例如：日志文件太大怎么查？端口被占用怎么办？），引导你使用正确的工具解决问题。

*   **实战导向**: 拒绝空谈，直接上手。
*   **环境自洽**: 每个章节提供初始化脚本，一键生成实验环境。
*   **自动验证**: 提供验证脚本，实时反馈学习成果。

## 🛠️ 环境配置 (Docker)

为了保证实验环境的一致性，推荐使用 Docker 进行学习。以下是详细的配置步骤：

### 1. 安装 Docker
请根据你的操作系统下载并安装 Docker Desktop 或 Docker Engine：
*   [Docker 官网下载](https://www.docker.com/products/docker-desktop)

### 2. 获取 Ubuntu 镜像
本课程基于 **Ubuntu 24.04 LTS** 编写。打开终端（Terminal / PowerShell / CMD），运行以下命令拉取镜像：

```bash
docker pull ubuntu:24.04
```

### 3. 启动实验容器
建议将本项目代码挂载到容器中，这样你可以在宿主机（你的电脑）用编辑器写代码，在容器内运行命令。

在本项目根目录下（`LinuxLearner`），运行以下命令启动容器：

**Windows (PowerShell):**
```powershell
docker run -it --name linux-learner `
  -v ${PWD}:/workspace `
  -w /workspace `
  ubuntu:24.04 /bin/bash
```

**macOS / Linux:**
```bash
docker run -it --name linux-learner \
  -v $(pwd):/workspace \
  -w /workspace \
  ubuntu:24.04 /bin/bash
```

### 4. 容器内初始化 (首次进入)
进入容器后，建议先更新包管理器并安装基础工具（如 `vim`, `curl`, `git` 等，视章节需求而定）：

```bash
apt-get update
apt-get install -y vim curl git iproute2 iputils-ping procps
```

*注意：如果退出了容器，可以通过 `docker start -ai linux-learner` 再次进入。*

## 📖 课程大纲

本课程包含 9 个章节，建议按顺序学习：

| 章节 | 主题 | 核心技能 | 场景示例 |
| :--- | :--- | :--- | :--- |
| **Chapter 01** | [文本探针 (Text Detective)](./Chapter_01) | `grep`, `tail`, `cat` | 在海量日志中定位错误信息 |
| **Chapter 02** | [空间治理 (Space Governance)](./Chapter_02) | `find`, `du`, `xargs` | 清理垃圾文件，批量重命名 |
| **Chapter 03** | [性能审判 (Performance)](./Chapter_03) | `top`, `ps`, `kill` | 找出并终结 CPU 占用过高的进程 |
| **Chapter 04** | [网络互联 (Networking)](./Chapter_04) | `ss`, `curl`, `nc` | 排查端口冲突，测试 API 连通性 |
| **Chapter 05** | [自动化金字塔 (Scripting)](./Chapter_05) | `bash`, 变量, 函数 | 编写自动备份与构建脚本 |
| **Chapter 06** | [权限堡垒 (Permissions)](./Chapter_06) | `chmod`, `chown`, `sudo` | 解决 Permission denied 报错 |
| **Chapter 07** | [软件与归档 (Packages)](./Chapter_07) | `tar`, `apt`, `wget` | 源码包安装与环境备份 |
| **Chapter 08** | [服务守护 (Daemons)](./Chapter_08) | `systemctl`, `nohup` | 让程序在后台稳定运行 |
| **Chapter 09** | [综合实战 (Capstone)](./Chapter_09) | All Skills | 从零部署 Web 应用全流程 |

## ⚡ 如何开始学习

以 **Chapter 01** 为例：

1.  **进入目录**:
    ```bash
    cd Chapter_01
    ```

2.  **阅读文档**:
    查看当前目录下的 `README.md`，了解本章的任务背景和核心知识点。

3.  **初始化环境**:
    运行 `lab/` 目录下的初始化脚本，生成实验数据：
    ```bash
    bash lab/init.sh
    ```

4.  **完成任务**:
    根据 README 的指引，在终端中执行命令解决问题。

5.  **验证结果**:
    当你认为任务完成后，运行验证脚本：
    ```bash
    bash verify.sh
    ```
    如果看到 `[PASS]`，恭喜你通关！进入下一章吧。

---
Happy Hacking! 🐧
