# Chapter 04: 网络互联 (Networking)

## 1. 实战背景 (The Pain Point)

代码写好了，部署上去却连不通。这是最让人头秃的时刻。

*   **场景一 (Port Conflict)**: 启动服务时报错 "Address already in use"。到底是谁占用了 8080 端口？
*   **场景二 (API Testing)**: 你写了个 REST API，想快速测试一下 `/api/login` 接口是否正常，但不想打开 Postman 或浏览器。
*   **场景三 (Connectivity Check)**: 数据库连接不上，是防火墙挡住了，还是数据库挂了？你需要测试 TCP 端口的连通性。

本章我们将学习如何使用 Linux 命令行工具，进行网络侦探和调试。

## 2. 核心工具箱 (The Toolkit)

### 2.1 `ss` - 端口侦探 (Socket Statistics)
`ss` 是 `netstat` 的现代替代品，用于查看网络连接状态。

**最常用的咒语**: `ss -lntp`

**详细参数说明**:

| 参数 | 英文全称 | 含义 |
| :--- | :--- | :--- |
| `-l` | **l**istening | **显示监听状态的套接字**。如果不加这个，默认只显示已建立连接 (ESTABLISHED) 的套接字。 |
| `-n` | **n**umeric | **不解析服务名**。直接显示 IP 和端口数字 (如 80)，而不是服务名 (如 http)。这能加快显示速度。 |
| `-t` | **t**cp | **只显示 TCP 连接**。如果想看 UDP，用 `-u`。 |
| `-p` | **p**rocesses | **显示进程信息**。显示是哪个进程 (PID 和程序名) 在使用这个端口。**注意**: 需要 sudo 权限才能看到所有进程。 |

**示例**:
*   `ss -lntp`: 列出所有正在监听的 TCP 端口及其对应的进程。
*   `ss -lntp | grep 8080`: 查找占用 8080 端口的进程。

### 2.2 `curl` - 网络瑞士军刀 (Client URL)
`curl` 是一个命令行 HTTP 客户端。

语法: `curl [参数] [URL]`

**详细参数说明**:

| 参数 | 含义 | 示例 |
| :--- | :--- | :--- |
| `-v` | **v**erbose (啰嗦模式)。显示详细的请求头 (Request Headers) 和响应头 (Response Headers)。调试神器。 | `curl -v http://localhost` |
| `-I` | **I**nfo (只看头)。只获取响应头，不下载响应体。用于快速检查状态码 (200/404)。 | `curl -I http://google.com` |
| `-o <file>` | **o**utput (输出)。将响应内容保存到指定文件，而不是打印到屏幕。 | `curl -o index.html http://google.com` |
| `-X <METHOD>` | 指定请求方法 (GET, POST, PUT, DELETE)。默认是 GET。 | `curl -X POST http://api.com` |
| `-d <data>` | **d**ata。发送 POST 数据。会自动将方法切换为 POST。 | `curl -d "name=admin" http://api.com/login` |
| `-H <header>` | **H**eader。添加自定义请求头。 | `curl -H "Content-Type: application/json" ...` |

### 2.3 `nc` - 网络猫 (Netcat)
`nc` 是网络界的“万能胶”，可以读写 TCP/UDP 连接。

**详细参数说明**:

| 参数 | 含义 | 示例 |
| :--- | :--- | :--- |
| `-z` | **z**ero-I/O mode。**扫描模式**，不发送任何数据。仅用于检测端口是否通。 | `nc -z localhost 80` |
| `-v` | **v**erbose。**显示详细信息**。如果不加，扫描成功可能什么都不显示。 | `nc -zv localhost 80` |
| `-l` | **l**isten。**监听模式**。把自己变成一个服务器，监听指定端口。 | `nc -l 1234` (开启一个聊天室) |

**场景示例**:

1.  **端口扫描/连通性测试 (替代 Telnet)**:
    *   `nc -zv 192.168.1.5 3306`: 测试数据库端口是否通。
    *   *输出*: `Connection to 192.168.1.5 port 3306 [tcp/mysql] succeeded!`

2.  **手动对话 (调试)**:
    *   `nc localhost 6379`: 连接 Redis 端口。连接成功后，你可以直接输入 Redis 命令 (如 `PING`)，它会回复 `PONG`。

## 3. 实验任务 (Hands-on Lab)

请先在 `Chapter_04` 目录下运行初始化脚本：
```bash
bash lab/init.sh
```
这会启动三个后台服务：一个 Web 服务器，一个 API 服务，和一个隐藏的后门服务。

### 任务 1: 谁占用了 8080？ (Port Hunt)
**目标**: 我们的 Web 服务器运行在 8080 端口。
*   **要求**:
    1.  使用 `ss` 确认 8080 端口处于监听状态。
    2.  使用 `curl` 访问 `http://localhost:8080`，并将输出保存到 `web_response.txt`。
*   *提示*: `curl http://localhost:8080 > web_response.txt`。

### 任务 2: API 接口验收 (API Testing)
**目标**: 9000 端口运行着一个 API 服务。
*   **要求**:
    1.  访问 `http://localhost:9000/api/status` 接口。
    2.  将返回的 JSON 数据保存到 `api_status.json`。
*   *提示*: 确保 URL 路径完全正确，否则会返回 404。

### 任务 3: 寻找隐藏后门 (Backdoor Discovery)
**目标**: 有一个神秘的服务监听在 `50000` 到 `60000` 之间的某个端口上。
*   **要求**:
    1.  使用 `ss -lntp` 找出这个端口。
    2.  使用 `nc` (Netcat) 连接该端口。
    3.  服务会发送一个 Flag 给我们。将这个 Flag 保存到 `flag.txt`。
*   *提示*:
    1.  运行 `ss -lntp`，肉眼观察 50000-60000 范围内的端口。
    2.  运行 `nc localhost <端口号> > flag.txt`。

## 4. 验证与通关

完成任务后，运行验证脚本：
```bash
bash lab/verify.sh
```
如果看到 `[PASS]`，你就是网络神探！

## 5. 进阶思考 (Deep Dive)

1.  **防火墙**: 如果 `ss` 显示端口在监听，但 `curl` 连不上（Connection timed out），通常是防火墙（iptables/ufw）的问题。如果是 Connection refused，则是服务没启动或端口错了。
2.  **DNS**: `curl google.com` 慢？可能是 DNS 解析慢。尝试 `curl -w "%{time_namelookup}\n" google.com` 查看 DNS 耗时。
3.  **JSON**: 在命令行处理 JSON 响应，推荐配合 `jq` 工具使用 (例如 `curl ... | jq .status`)。
