# Vol.8: 服务守护 (Daemons)

## 1. 实战背景 (The Pain Point)

你在 SSH 终端里运行了一个 Python 爬虫脚本 `python spider.py`，跑得正欢。突然，你的网络断了一下，SSH 连接断开了。当你重新连上服务器，发现——爬虫进程也没了！
这是因为普通的进程是依附于终端会话的。为了让程序在后台长久运行，甚至开机自启，你需要掌握“守护进程” (Daemon) 的技术。

## 2. 核心命令详解 (The Toolkit)

| 命令 | 常用参数 | 说明 |
| :--- | :--- | :--- |
| `nohup` | `&` | 最简单的后台运行方式（No Hang Up） |
| `jobs` | `-l` | 查看当前终端的后台任务 |
| `bg` / `fg` | | 将任务切换到后台/前台 |
| `systemctl` | `start`, `stop`, `status`, `enable` | Systemd 服务管理神器 |
| `journalctl` | `-u service_name -f` | 查看服务的实时日志 |

> **查阅手册**: 输入 `man systemd.service` 查看服务文件写法。

## 3. 正则与逻辑 (The Logic)

### 3.1 简单的后台运行 (`nohup`)

```bash
nohup python app.py > output.log 2>&1 &
```
*   `nohup`: 忽略挂起信号（SIGHUP），即关闭终端不杀进程。
*   `&`: 放入后台执行。
*   `> output.log`: 标准输出重定向。
*   `2>&1`: 错误输出重定向到标准输出。

### 3.2 Systemd 服务文件结构

Systemd 是 Linux 的初始化系统，管理所有服务。一个 `.service` 文件通常包含三部分：

```ini
[Unit]
Description=My Awesome Service
After=network.target  # 在网络启动后启动

[Service]
ExecStart=/usr/bin/python3 /path/to/app.py
Restart=always        # 挂了自动重启
User=root             # 以什么用户身份运行

[Install]
WantedBy=multi-user.target # 多用户模式下启用（开机自启）
```

## 4. 实验手册 (Hands-on Lab)

请先运行初始化脚本：
```bash
cd Chapter_08/lab
./init.sh
```

进入 `Chapter_08/lab` 目录，完成以下任务：

### 任务 1: 临时后台运行
目录下有一个 `worker.py` 脚本，它每秒打印一次日志。
**目标**: 使用 `nohup` 将其在后台运行，并将输出重定向到 `worker.log`。
(提示: 运行后用 `tail -f worker.log` 查看，用 `ps aux | grep worker` 确认进程存在)

### 任务 2: 配置 Systemd 服务
目录下有一个 `web_server.py` (模拟 Web 服务) 和一个模板文件 `myweb.service`。
**目标**:
1.  修改 `myweb.service` 中的 `ExecStart` 路径，指向你的 `web_server.py` 的**绝对路径**。
2.  将 `.service` 文件链接或复制到 `/etc/systemd/system/` (需要 sudo)。
3.  重载配置: `sudo systemctl daemon-reload`
4.  启动服务: `sudo systemctl start myweb`
5.  查看状态: `sudo systemctl status myweb`

### 任务 3: 设置开机自启
**目标**: 使用 `systemctl` 命令设置该服务为开机自启。

## 5. 通关验证 (Verification)

完成所有任务后，运行验证脚本：
```bash
cd ..
./verify.sh
```
注意：本章节验证需要 sudo 权限来检查 systemd 状态。

## 6. 避坑与原理 (Deep Dive)

*   **绝对路径**: 在 systemd 的 `.service` 文件中，所有路径（命令、文件）都必须写**绝对路径**。写 `python app.py` 是不行的，要写 `/usr/bin/python3 /home/ubuntu/app.py`。
*   **权限问题**: 确保 `User=` 指定的用户有权限访问你的脚本和相关文件。
*   **日志查看**: `systemd` 托管的程序，标准输出会被 `journald` 收集。使用 `journalctl -u myweb -f` 可以像 `tail -f` 一样实时查看日志，非常方便。
