# Chapter 04: 网络互联 (Networking)

## 1. 实战背景 (The Pain Point)

**场景一（端口冲突）**：你兴致勃勃地写了一个 Web 应用，准备运行 `npm start`，结果报错：`Error: listen EADDRINUSE: address already in use :::8080`。你抓狂了：到底是谁占用了我的 8080 端口？

**场景二（接口调试）**：前端同事说你的 API 挂了，返回 500。你坚称是好的。为了自证清白，你需要在服务器上直接请求这个接口，看看它到底返回了什么，以及响应头里有没有那个关键的 Token。

本章我们将学习如何在没有浏览器的情况下，透视网络连接。

## 2. 核心命令详解 (The Toolkit)

### 2.1 `ss` - 网络侦探 (Socket Statistics)
取代了古老的 `netstat`。
*   `ss -tuln`: 查看当前所有**正在监听 (Listening)** 的 **TCP (t)** 和 **UDP (u)** 端口，以**数字 (n)** 形式显示。
*   `ss -lptn`: **神器**。显示监听端口的同时，显示**进程名 (p)** 和 PID。（需要 sudo 权限才能看到 PID）。

### 2.2 `curl` - 瑞士军刀 (Client URL)
最强大的命令行 HTTP 客户端。
*   `curl http://localhost:8080`: 发送 GET 请求并打印 Body。
*   `curl -I http://localhost:8080`: 只看 **响应头 (Headers)** (HEAD 请求)。
*   `curl -v http://localhost:8080`: **Verbose 模式**。显示详细的握手、请求头、响应头过程（调试神器）。
*   `curl -o file.json http://...`: 将结果保存到文件。

### 2.3 `nc` - 网络瑞士军刀 (Netcat)
（本章暂不深入，但要知道它可以用来测试 TCP 连通性）
*   `nc -zv localhost 8080`: 快速测试本机 8080 端口通不通。

### 2.4 `ip` - 地址查询
*   `ip addr`: 查看本机的 IP 地址。

## 3. 实验手册 (Hands-on Lab)

请使用 **两个终端** 配合操作。

### 准备工作
在 **终端 A** 中运行初始化脚本，并启动一个“流氓”服务：
```bash
bash lab/init.sh
python3 web_server.py
```
*你会看到 `Serving at port 8080`。现在保持终端 A 不要动，去终端 B 操作。*

### 任务 1: 夺回端口 (Port Conflict)
**目标**: 在 **终端 B** 中，找出是谁占用了 8080 端口，并杀掉它。
**操作**:
1.  运行 `ss -lptn` (如果没有权限，试着不加 p，或者用 `sudo ss -lptn`)。
2.  找到 `:8080` 对应的那一行。
3.  如果是 root 权限，你能看到 PID；如果不是，你可能只能看到端口被占。
4.  *提示*: 如果 `ss` 看不到 PID，可以使用 `lsof -i :8080`。
5.  找到 PID 后，使用 `kill <PID>`。
6.  *回到终端 A，你会发现那个 Python 脚本退出了，端口被释放了。*

### 任务 2: API 联调 (API Testing)
**目标**: 启动另一个 API 服务，并保存其响应。
**操作**:
1.  在终端 A (现在应该空闲了) 启动 API 服务: `python3 api_service.py` (它监听 9000 端口)。
2.  在终端 B，使用 `curl` 访问 `http://localhost:9000/api/status`。
3.  将响应结果保存到当前目录下的 `api_response.json`。

### 任务 3: 检查响应头 (Header Check)
**目标**: 检查 9000 端口服务的响应头。
**操作**:
1.  在终端 B，使用 `curl -I http://localhost:9000/api/status`。
2.  将输出重定向保存到 `headers.txt`。

## 4. 通关验证 (Verification)

在终端 B 中运行验证脚本：

```bash
bash verify.sh
```

## 5. 避坑与原理 (Deep Dive)

1.  **0.0.0.0 vs 127.0.0.1**:
    *   `127.0.0.1` (localhost): 只有本机能访问。
    *   `0.0.0.0`: 允许外网（局域网其他机器）访问。
    *   在使用 `ss` 时，注意看 Local Address 是 `127.0.0.1:8080` 还是 `*:8080`。
2.  **防火墙**: 有时候 `curl` 不通，不仅是因为服务没起，还可能是防火墙（ufw/iptables）挡住了。
3.  **Exit Code**: `curl` 如果请求失败，会返回非 0 的退出码。在脚本中可以利用 `$?` 来判断网络通断。
