#!/bin/bash
# Initialize lab environment for Chapter 09

set -e

# Create lab directory if not exists
LAB_DIR="lab_files"
mkdir -p "$LAB_DIR"
cd "$LAB_DIR"

# Task 1: Create webapp source code
echo "Creating webapp source code..."
mkdir -p webapp
cat << 'EOF' > webapp/app.py
import time
import sys
from http.server import SimpleHTTPRequestHandler, HTTPServer

class MyHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(b"Hello from Chapter 09!")

port = 5000
print(f"Starting server on port {port}...")
sys.stdout.flush()
httpd = HTTPServer(('127.0.0.1', port), MyHandler)
httpd.serve_forever()
EOF

echo "How to run:" > webapp/README.txt
echo "1. chmod +x app.py" >> webapp/README.txt
echo "2. python3 app.py" >> webapp/README.txt

# Create start.sh (but leave it empty or partially filled for the student)
echo "#!/bin/bash" > webapp/start.sh
echo "# Write your startup script here" >> webapp/start.sh

# Pack everything
tar -czvf webapp.tar.gz webapp
rm -rf webapp

echo "Lab environment initialized in $(pwd)."
echo "You have one file: webapp.tar.gz. Good luck!"
