#!/bin/bash
# Initialize lab environment for Chapter 06

set -e

# Create lab directory if not exists
LAB_DIR="lab_files"
mkdir -p "$LAB_DIR"
cd "$LAB_DIR"

# Task 1: deploy.sh (no execute permission)
echo "#!/bin/bash" > deploy.sh
echo "echo 'Deployment successful!'" >> deploy.sh
chmod 644 deploy.sh

# Task 2: id_rsa (too open permission)
echo "-----BEGIN OPENSSH PRIVATE KEY-----" > id_rsa
echo "MIIEpAIBAAKCAQEA..." >> id_rsa
echo "-----END OPENSSH PRIVATE KEY-----" >> id_rsa
chmod 644 id_rsa

# Task 3: public_html (too restrictive permission)
mkdir -p public_html
echo "<h1>Hello World</h1>" > public_html/index.html
chmod 700 public_html

echo "Lab environment initialized in $(pwd)."
echo "Go to $LAB_DIR and fix the permissions!"
