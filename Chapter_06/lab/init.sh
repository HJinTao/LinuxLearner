#!/bin/bash

# 设置颜色变量
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[*] 初始化 Chapter 06 实验环境...${NC}"

# 1. 模拟一个被“破坏”的部署脚本
echo -e "${GREEN}[+] 生成 deploy.sh (不可执行)...${NC}"
cat > deploy.sh << EOF
#!/bin/bash
echo "Deploying application..."
echo "Success!"
EOF
# 设置为只读，不可执行 (644)
chmod 644 deploy.sh

# 2. 模拟 SSH 私钥文件 (权限过大)
echo -e "${GREEN}[+] 生成 id_rsa (权限过大 - 危险)...${NC}"
echo "FAKE PRIVATE KEY CONTENT" > id_rsa
# 设置为所有人可读 (644)，这是 SSH 不允许的，必须是 600
chmod 644 id_rsa

# 3. 模拟 Web 根目录 (权限过小)
echo -e "${GREEN}[+] 生成 var/www/html (权限过小)...${NC}"
mkdir -p var/www/html
echo "<h1>Index</h1>" > var/www/html/index.html
# 设置为只有拥有者可读写执行 (700)，这样 Web 服务器(其他用户)无法读取
chmod 700 var/www/html
chmod 600 var/www/html/index.html

# 4. 模拟一个需要 root 权限才能修改的配置文件
echo -e "${GREEN}[+] 生成 system.conf (属于 root)...${NC}"
# 注意：在非 root 环境下运行此脚本，文件的 owner 还是当前用户。
# 为了模拟效果，我们只能通过 verify.sh 来检查权限位，或者让用户尝试 sudo chown (如果他们有 sudo 权限)
# 这里主要练习 chmod
echo "critical_config=true" > system.conf
chmod 444 system.conf # 只读

# 5. 模拟一个 Python 脚本，头部有 Shebang 但没权限
echo -e "${GREEN}[+] 生成 run.py...${NC}"
echo "#!/usr/bin/env python3" > run.py
echo "print('Running...')" >> run.py
chmod 644 run.py

echo -e "${GREEN}[✔] 实验环境初始化完成！${NC}"
echo -e "当前目录下已生成: deploy.sh, id_rsa, var/www/html/, system.conf, run.py"
