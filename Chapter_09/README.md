# Chapter 09: 综合实战 (Capstone Project)

## 1. 实战背景 (The Pain Point)

这是最终考核。你刚刚入职一家初创公司，开发团队把代码打包发给你了（`release_v1.0.tar.gz`），老板要求你：

1.  **部署上线**: 把这个 Web 应用跑起来，监听 8080 端口。
2.  **解决冲突**: 服务器上似乎已经有一个旧进程占用了 8080 端口，你需要处理掉它。
3.  **持久化**: 应用必须在后台运行，且支持开机自启。
4.  **配置分离**: 应用的端口号定义在配置文件中，你需要确认配置是否正确。

你将用到之前学过的所有知识：解压 (tar)、进程管理 (ps/kill)、网络检测 (ss/curl)、权限 (chmod) 和 脚本 (bash)。

## 2. 核心命令回顾 (The Toolkit)

*   `tar -xzvf`: 解压源码包
*   `ss -lntp`: 查看端口占用
*   `kill <PID>`: 杀掉冲突进程
*   `nohup ... &`: 后台运行
*   `curl`: 验证服务接口

## 3. 任务简报 (The Mission)

请先运行初始化脚本：
```bash
bash lab/init.sh
```
初始化脚本会模拟一个**端口冲突**的场景：一个“旧进程”正占着 8080 端口。

### 阶段 1: 环境清理 (Cleanup)
**目标**: 释放 8080 端口。
1.  使用 `ss -lntp` 确认 8080 端口被谁占用了（记下 PID）。
2.  使用 `kill` 终止该进程。
3.  再次检查端口是否释放。

### 阶段 2: 部署代码 (Deployment)
**目标**: 解压代码包。
1.  解压 `release_v1.0.tar.gz`。
2.  进入解压后的 `webapp` 目录。
3.  查看 `src/app.py` 和 `config/app.conf`，了解应用是如何读取端口配置的。

### 阶段 3: 启动应用 (Startup)
**目标**: 运行新版本的 Web 应用。
1.  手动运行 `python3 src/app.py`，确认没有报错。
    *   *注意*: 如果报错端口被占用，说明阶段 1 没做干净。
2.  验证: 在另一个终端运行 `curl localhost:8080`，应该能看到 "Welcome"。
3.  按 `Ctrl+C` 停止应用。

### 阶段 4: 生产环境运行 (Production)
**目标**: 让应用在后台稳定运行。
1.  使用 `nohup python3 src/app.py > logs/app.log 2>&1 &` 启动应用。
2.  使用 `ps aux | grep app.py` 确认进程在后台运行。
3.  使用 `tail -f logs/app.log` 查看启动日志。

## 4. 验证与通关

完成所有任务后，运行验证脚本：
```bash
bash lab/verify.sh
```
如果看到 `[PASS]`，恭喜你！你已经完成了本课程的所有挑战，成为了一名合格的 Linux 工程师！🎓

## 5. 毕业寄语 (Conclusion)

Linux 的世界浩瀚无垠，但这 9 个章节涵盖了开发者日常 90% 的场景。
*   遇到问题，先查日志 (`tail`, `grep`)。
*   空间不够，分析磁盘 (`du`, `find`)。
*   服务挂了，检查进程 (`ps`, `top`)。
*   连不通了，排查网络 (`ss`, `curl`)。
*   重复劳动，写个脚本 (`bash`)。

Keep Learning, Keep Hacking! 🐧
