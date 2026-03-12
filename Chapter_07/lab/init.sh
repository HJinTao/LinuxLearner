#!/bin/bash
# Initialize lab environment for Chapter 07

set -e

# Create lab directory if not exists
LAB_DIR="lab_files"
mkdir -p "$LAB_DIR"
cd "$LAB_DIR"

# Task 1: legacy_code.tar.gz
echo "Creating dummy legacy code..."
mkdir -p legacy_code
echo "This is legacy code file 1." > legacy_code/main.c
echo "This is legacy code file 2." > legacy_code/utils.c
tar -czvf legacy_code.tar.gz legacy_code
rm -rf legacy_code

# Task 2: config/
echo "Creating config directory..."
mkdir -p config
echo "host=localhost" > config/db.conf
echo "port=8080" > config/server.conf

# Task 3: logs/
echo "Creating logs directory..."
mkdir -p logs
echo "Error log line 1" > logs/error.log
echo "Access log line 1" > logs/access.log

echo "Lab environment initialized in $(pwd)."
echo "Go to $LAB_DIR and start unpacking!"
