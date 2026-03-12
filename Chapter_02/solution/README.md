# 参考答案

## 任务 1: 大扫除
方法一 (推荐):
```bash
# 先确认
find project_build -name "*.o"
find project_build -name "*.tmp"
# 再删除
find project_build -name "*.o" -delete
find project_build -name "*.tmp" -delete
```
方法二 (一次性):
```bash
find project_build \( -name "*.o" -o -name "*.tmp" \) -delete
```

## 任务 2: 格式修正
进入 `submissions` 目录后：
```bash
cd submissions
for f in *.TEXT; do
    mv "$f" "${f%.TEXT}.txt"
done
```

## 任务 3: 寻找巨兽
```bash
# 查找大文件
du -ah logs | sort -rh | head -n 1
# 假设找到的是 logs/archive/2023/11/debug_trace.log
rm logs/archive/2023/11/debug_trace.log
```
