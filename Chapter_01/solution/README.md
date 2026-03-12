# 参考答案

## 任务 1: 抓捕嫌疑人
```bash
grep -E "ERROR|CRITICAL" server.log > error_report.txt
```
或者分两步（不推荐，因为顺序会乱，除非用追加）：
```bash
grep "ERROR" server.log > error_report.txt
grep "CRITICAL" server.log >> error_report.txt
```

## 任务 2: 验明正身
```bash
head -n 5 main.c > main_head.txt
```

## 任务 3: 人员筛选
```bash
grep "CyberSecurity" grades.csv > security_students.txt
```
