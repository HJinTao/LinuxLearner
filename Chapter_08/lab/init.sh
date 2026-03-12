#!/bin/bash
# Initialize lab environment for Chapter 08

set -e

# Create lab directory if not exists
LAB_DIR="lab_files"
mkdir -p "$LAB_DIR"
cd "$LAB_DIR"

# Task 1: worker.py (simple infinite loop)
echo "Creating worker.py..."
cat << 'EOF' > worker.py
import time
import sys

print("Worker started...")
while True:
    print(f"Working at {time.time()}")
    sys.stdout.flush()
    time.sleep(2)
EOF
chmod +x worker.py

# Task 2: web_server.py (simple http server)
echo "Creating web_server.py..."
cat << 'EOF' > web_server.py
from http.server import SimpleHTTPRequestHandler, HTTPServer

port = 8081
print(f"Starting server on port {port}")
httpd = HTTPServer(('0.0.0.0', port), SimpleHTTPRequestHandler)
httpd.serve_forever()
EOF
chmod +x web_server.py

# Task 2: myweb.service (template)
echo "Creating myweb.service template..."
cat << 'EOF' > myweb.service
[Unit]
Description=My Simple Web Server
After=network.target

[Service]
# FIX ME: Replace with absolute path to web_server.py
# Example: /usr/bin/python3 /path/to/lab_files/web_server.py
ExecStart=/usr/bin/python3 /tmp/web_server.py
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

echo "Lab environment initialized in $(pwd)."
echo "Remember to check the README for instructions!"
