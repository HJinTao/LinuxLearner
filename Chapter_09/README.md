# Vol.9: 综合实战 (Capstone Project)

## 1. 实战背景 (The Pain Point)

这是最终考核。开发团队刚刚把代码打包发给你了（`webapp.tar.gz`），老板要求你：
1.  把这个 Web 应用跑起来，监听 5000 端口。
2.  必须在后台运行，不能因为你关掉终端就挂了。
3.  必须开机自启，防止服务器重启后业务中断。
4.  不要用 root 运行（安全第一）。

你将用到之前学过的所有知识：解压、权限、脚本、Systemd、日志查看。

## 2. 核心命令回顾 (The Toolkit)

*   `tar -xzvf`: 解压源码
*   `chmod +x`: 赋予脚本执行权限
*   `systemctl`: 配置服务与自启
*   `curl`: 本地测试接口
*   `journalctl`: 排查启动报错

## 3. 任务简报 (The Mission)

请先运行初始化脚本：
```bash
cd Chapter_09/lab
./init.sh
```

进入 `Chapter_09/lab` 目录，你只有一个文件 `webapp.tar.gz`。

### 阶段 1: 部署代码
1.  解压 `webapp.tar.gz`。
2.  进入解压后的目录，查看 `README.txt`（如果有的话）和代码文件。
3.  尝试手动运行一下 `python3 app.py`，确保它能跑通（按 `Ctrl+C` 退出）。
    *   *注意*: 如果提示权限不足，检查文件权限。

### 阶段 2: 编写启动脚本
为了规范化，创建一个名为 `start.sh` 的脚本：
1.  内容：进入 `app.py` 所在目录，然后执行 `python3 app.py`。
2.  赋予 `start.sh` 执行权限。
3.  测试运行 `./start.sh`，确保能启动应用。

### 阶段 3: Systemd 托管
创建一个名为 `webapp.service` 的系统服务文件：
1.  **Description**: WebApp Production Service
2.  **ExecStart**: 指向你的 `start.sh` 的绝对路径。
3.  **Restart**: always
4.  **User**: 使用当前用户（`whoami` 查看）。

然后：
1.  链接/复制到 `/etc/systemd/system/`。
2.  重载配置。
3.  启动服务并设置开机自启。

### 阶段 4: 验收
1.  确保服务状态是 `active (running)`。
2.  使用 `curl http://127.0.0.1:5000` 获取返回内容。
3.  使用 `journalctl -u webapp` 查看最后几行日志。

## 5. 通关验证 (Verification)

完成所有任务后，运行验证脚本：
```bash
cd ..
./verify.sh
```
如果看到 `PASS`，恭喜你！你已经具备了独立部署小型应用的能力。

## 6. 避坑与原理 (Deep Dive)

*   **工作目录 (WorkingDirectory)**: 在 Systemd 中，建议配置 `WorkingDirectory=/path/to/app`，这样程序里的相对路径（如读取 `config.json`）才不会出错。
*   **环境变量**: 如果应用需要环境变量（如 `DATABASE_URL`），可以在 Service 块中添加 `Environment="DATABASE_URL=..."`。
*   **虚拟环境**: Python 项目通常需要激活 venv。在 `ExecStart` 中可以直接指定 venv 里的 python 解释器路径：`/path/to/venv/bin/python app.py`，这样就不需要手动 `source activate` 了。
