# 参考答案

## 任务 1: 逮捕 CPU 刺客
```bash
# 1. 启动 top
top
# (在 top 界面中按 P 排序，看到 PID 例如 12345)
# 按 q 退出

# 2. 杀掉进程
kill 12345
```

## 任务 2: 清理僵尸服务
```bash
# 查找进程
ps aux | grep frozen_service.py

# 输出示例:
# user  12346  0.0  0.1  ... python3 frozen_service.py
# user  12350  0.0  0.0  ... grep frozen_service.py

# 杀掉第一个 PID
kill 12346
```

## 任务 3: 搜查伪装者
```bash
# 查找
ps aux | grep sneaky

# 强制查杀
kill -9 <PID>
```
