# 参考答案

## 任务 1: 夺回端口
```bash
# 1. 查找占用 8080 的进程
ss -lptn | grep 8080
# 或者
lsof -i :8080

# 输出示例:
# LISTEN 0 5 *:8080 *:* users:(("python3",pid=12345,fd=3))

# 2. 杀掉进程
kill 12345
```

## 任务 2: API 联调
```bash
curl http://localhost:9000/api/status > api_response.json
```

## 任务 3: 检查响应头
```bash
curl -I http://localhost:9000/api/status > headers.txt
```
