#!/bin/bash

# 设置颜色变量
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[*] 初始化 Chapter 07 实验环境...${NC}"

# 1. 模拟一个源代码包 (Source Tarball)
# 包含：configure 脚本, Makefile, src/
echo -e "${GREEN}[+] 生成 redis-5.0.0.tar.gz (模拟源码包)...${NC}"
mkdir -p redis-5.0.0/src
cat > redis-5.0.0/configure << 'EOF'
#!/bin/bash
echo "Checking dependencies..."
if command -v gcc >/dev/null 2>&1; then
    echo "gcc found."
else
    echo "Error: gcc not found. Please install build-essential."
    exit 1
fi
echo "Configuration complete. Run 'make' to build."
EOF
chmod +x redis-5.0.0/configure

cat > redis-5.0.0/Makefile << 'EOF'
all:
	@echo "Compiling source code..."
	@echo "Linking libraries..."
	@echo "Build successful! Binary created at src/redis-server"
	@touch src/redis-server
	@chmod +x src/redis-server

install:
	@echo "Installing to /usr/local/bin..."
	@cp src/redis-server ./redis-server-installed
	@echo "Installation complete."
EOF

echo "int main() { return 0; }" > redis-5.0.0/src/server.c

# 打包
tar -czf redis-5.0.0.tar.gz redis-5.0.0
rm -rf redis-5.0.0

# 2. 模拟一个需要备份的网站目录 (Backup Scenario)
echo -e "${GREEN}[+] 生成 var/www/html (模拟网站数据)...${NC}"
mkdir -p var/www/html/images
mkdir -p var/www/html/css
echo "<h1>Home</h1>" > var/www/html/index.html
echo "body { color: red; }" > var/www/html/css/style.css
touch var/www/html/images/logo.png
touch var/www/html/images/banner.jpg

# 3. 模拟一个需要解压的日志包 (Incident Response)
echo -e "${GREEN}[+] 生成 incident_logs.zip (模拟事故日志)...${NC}"
mkdir -p logs_analysis
echo "User admin login failed" > logs_analysis/auth.log
echo "Database connection timeout" > logs_analysis/db.log
# 如果系统没有 zip 命令，尝试用 tar 代替，或者提示用户
if command -v zip >/dev/null 2>&1; then
    zip -r incident_logs.zip logs_analysis > /dev/null
else
    echo "Warning: zip command not found. Creating .tar instead."
    tar -cf incident_logs.tar logs_analysis
fi
rm -rf logs_analysis

echo -e "${GREEN}[✔] 实验环境初始化完成！${NC}"
echo -e "当前目录下已生成: redis-5.0.0.tar.gz, var/www/html/, incident_logs.zip (or .tar)"
