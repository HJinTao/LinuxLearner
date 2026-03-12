# Chapter 08: 服务守护 (Daemons)

## 1. 实战背景 (The Pain Point)

你在 SSH 终端里运行了一个 Python 爬虫脚本 `python spider.py`，跑得正欢。突然，你的网络断了一下，SSH 连接断开了。当你重新连上服务器，发现——爬虫进程也没了！

这是因为普通的进程是依附于终端会话的 (Session)。当终端关闭时，它会向所有子进程发送 `SIGHUP` 信号，导致它们退出。

为了让程序在后台长久运行，甚至开机自启、挂了自动重启，你需要掌握“守护进程” (Daemon) 的技术。

## 2. 核心工具箱 (The Toolkit)

### 2.1 `nohup` & `&` - 简易后台运行
这是最快让程序在后台运行的方法，适合临时任务。

**语法**: `nohup [命令] &`

*   **nohup**: **No Hang Up** (不挂断)。它的作用是让进程忽略 `SIGHUP` 信号。即使终端关闭，进程也不会死。
*   **&**: **Ampersand**。让命令在后台 (Background) 执行，你的终端可以继续输入其他命令。

**示例**:
`nohup python3 long_task.py > output.log 2>&1 &`
*   `> output.log`: 将标准输出 (stdout) 重定向到文件。
*   `2>&1`: 将标准错误 (stderr) 重定向到标准输出 (stdout)，也就是一起写入 log。

### 2.2 `systemd` - 现代 Linux 的守护神
Systemd 是目前主流 Linux 发行版 (Ubuntu, CentOS 7+) 的初始化系统。它管理着系统中的所有服务。

**常用命令 (`systemctl`)**:

| 命令 | 含义 |
| :--- | :--- |
| `systemctl start <服务名>` | 启动服务 |
| `systemctl stop <服务名>` | 停止服务 |
| `systemctl restart <服务名>` | 重启服务 |
| `systemctl status <服务名>` | **查看状态** (排错神器，会显示最后几行日志) |
| `systemctl enable <服务名>` | **设置开机自启** |
| `systemctl disable <服务名>` | 取消开机自启 |
| `systemctl daemon-reload` | **重载配置**。当你修改了 `.service` 文件后，必须执行这个命令。 |

**服务配置文件 (.service)**:
通常位于 `/etc/systemd/system/` 目录下。

```ini
[Unit]
Description=My Web Server
After=network.target  # 在网络启动后再启动

[Service]
# 核心配置
ExecStart=/usr/bin/python3 /opt/web_server.py  # 启动命令 (必须绝对路径!)
WorkingDirectory=/opt/                         # 工作目录
Restart=always                                 # 挂了自动重启 (非常重要!)
User=www-data                                  # 以什么用户身份运行

[Install]
WantedBy=multi-user.target # 多用户模式下启用 (对应开机自启)
```

## 3. 实验任务 (Hands-on Lab)

请先在 `Chapter_08` 目录下运行初始化脚本：
```bash
bash lab/init.sh
```

### 任务 1: 不死的爬虫 (nohup)
**目标**: 目录下有一个 `long_task.py`，模拟一个需要跑很久的数据处理脚本。
*   **要求**:
    1.  使用 `nohup` 将其在后台运行。
    2.  将输出重定向到 `nohup.out` (默认行为) 或自定义日志文件。
    3.  关闭当前终端 (或模拟关闭)，验证进程是否还在运行。
*   *提示*: `nohup python3 long_task.py &`。

### 任务 2: 编写 Systemd 服务 (Service File)
**目标**: 目录下有一个 `web_server.py` 和一个有错误的 `my_web.service` 模板。
*   **要求**:
    1.  修复 `my_web.service` 中的错误。
        *   **ExecStart**: 必须使用 `python3` 的绝对路径 (通常是 `/usr/bin/python3`) 和脚本的**绝对路径** (使用 `pwd` 查看)。
        *   **WorkingDirectory**: 设置为脚本所在的**绝对路径**。
    2.  (可选，需 sudo) 将 `.service` 文件复制到 `/etc/systemd/system/` 并启动。
    3.  **注意**: 由于 Docker 环境限制，我们主要验证配置文件的正确性，不强制要求在容器内成功启动 systemd 服务。

### 任务 3: 服务管理 (Service Management)
**目标**: 模拟运维操作。
*   **要求**:
    1.  尝试启动服务: `systemctl start my_web` (如果环境支持)。
    2.  检查状态: `systemctl status my_web`。
    3.  测试服务: `curl localhost:8088`。

## 4. 验证与通关

完成任务后，运行验证脚本：
```bash
bash lab/verify.sh
```
如果看到 `[PASS]`，说明你已经掌握了让程序永生的秘密！

## 5. 进阶思考 (Deep Dive)

1.  **Zombie Process**: 如果父进程退出了，子进程会被 PID 1 (systemd) 接管。但如果父进程没退出也没回收子进程，子进程就会变成僵尸。
2.  **Journalctl**: Systemd 收集了所有服务的日志。
    *   `journalctl -u my_web -f`: 实时查看 my_web 服务的日志 (类似 `tail -f`)。
    *   `journalctl -xe`: 查看系统最近的错误日志 (排查服务启动失败的神器)。
3.  **User**: 永远不要用 `root` 运行 Web 服务！如果服务被黑，黑客就拥有了 root 权限。在 `.service` 里指定 `User=nobody` 或专用用户。
