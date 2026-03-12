# Vol.8 Solution (Daemons)

## 任务 1: 临时后台运行
**命令:**
```bash
nohup python3 worker.py > worker.log 2>&1 &
```
**解析:**
`nohup` 保证退出终端不杀进程，`&` 将其放入后台，`> worker.log 2>&1` 将标准输出和错误输出都重定向到同一个日志文件。

## 任务 2: 配置 Systemd 服务
**配置 myweb.service:**
```ini
[Service]
ExecStart=/usr/bin/python3 /absolute/path/to/Chapter_08/lab/lab_files/web_server.py
```
**启动命令:**
```bash
sudo cp myweb.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start myweb
sudo systemctl status myweb
```
**解析:**
关键点是路径必须是**绝对路径**。如果不确定 python 路径，用 `which python3` 查看。

## 任务 3: 设置开机自启
**命令:**
```bash
sudo systemctl enable myweb
```
**解析:**
这会创建软链接到 `/etc/systemd/system/multi-user.target.wants/`，使服务在系统进入多用户模式时自动启动。

## 避坑指南
*   **重载配置**: 每次修改 `/etc/systemd/system/` 下的 `.service` 文件后，必须执行 `sudo systemctl daemon-reload` 才能生效。
*   **查看日志**: 如果服务启动失败 (status 显示 `failed`)，使用 `journalctl -u myweb -n 50 --no-pager` 查看最近的 50 行日志来排查原因。
