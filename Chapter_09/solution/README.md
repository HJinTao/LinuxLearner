# Vol.9 Solution (Capstone Project)

## 任务 1: 部署代码
**命令:**
```bash
tar -xzvf webapp.tar.gz
cd webapp
python3 app.py
```
**解析:**
解压后，你应该能看到 `webapp` 目录。进入并尝试运行，确保没有语法错误。

## 任务 2: 编写启动脚本
**webapp/start.sh 内容:**
```bash
#!/bin/bash
cd /path/to/Chapter_09/lab/lab_files/webapp
python3 app.py
```
**命令:**
```bash
chmod +x start.sh
```
**解析:**
`cd` 到目录是关键，否则程序可能找不到依赖文件（虽然这个简单示例没有）。

## 任务 3: Systemd 托管
**webapp.service 内容:**
```ini
[Unit]
Description=WebApp Production Service
After=network.target

[Service]
ExecStart=/path/to/Chapter_09/lab/lab_files/webapp/start.sh
WorkingDirectory=/path/to/Chapter_09/lab/lab_files/webapp
Restart=always
User=root  # 如果不想用 root，改成你的用户名

[Install]
WantedBy=multi-user.target
```
**命令:**
```bash
sudo cp webapp.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable webapp
sudo systemctl start webapp
```

## 任务 4: 验收
**命令:**
```bash
sudo systemctl status webapp
curl http://127.0.0.1:5000
```
**解析:**
`status` 应该显示 `active (running)`，`curl` 应该返回 "Hello from Chapter 09!"。

## 避坑指南
*   **权限**: 确保 `start.sh` 有执行权限 (`chmod +x start.sh`)，否则 Systemd 会报错 `Access denied`。
*   **端口冲突**: 如果 5000 端口被占用了，你可以修改 `app.py` 里的端口号，或者用 `kill` 命令杀掉占用的进程。
