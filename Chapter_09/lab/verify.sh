#!/bin/bash
# Verify Chapter 09

set -e

LAB_DIR="lab/lab_files"

# Check if lab files exist
if [ ! -d "$LAB_DIR" ]; then
    echo "FAIL: Lab directory '$LAB_DIR' not found. Did you run 'lab/init.sh'?"
    exit 1
fi

PASS=true

# Check Task 1: Deployed source code
if [ ! -d "$LAB_DIR/webapp" ]; then
    echo "FAIL: Task 1 - 'webapp' directory not found. Did you extract the tar.gz?"
    PASS=false
else
    echo "PASS: Task 1 - 'webapp' source code extracted."
fi

# Check Task 2: start.sh
if [ ! -x "$LAB_DIR/webapp/start.sh" ]; then
    echo "FAIL: Task 2 - 'start.sh' is not executable or doesn't exist."
    PASS=false
else
    echo "PASS: Task 2 - 'start.sh' is ready."
fi

# Check Task 3: webapp.service active
if systemctl is-active --quiet webapp; then
    echo "PASS: Task 3 - 'webapp.service' is running."
else
    echo "FAIL: Task 3 - 'webapp.service' is not running. Check 'systemctl status webapp'."
    PASS=false
fi

# Check Task 4: Port 5000 responsive
# We use curl or nc to check port 5000
if curl -s http://127.0.0.1:5000 > /dev/null; then
    echo "PASS: Task 4 - WebApp is responding on port 5000."
else
    echo "FAIL: Task 4 - Could not connect to port 5000. Is the app running?"
    PASS=false
fi

if [ "$PASS" = true ]; then
    echo "=========================================="
    echo "  CONGRATULATIONS! YOU COMPLETED THE COURSE!  "
    echo "=========================================="
    exit 0
else
    echo "=========================================="
    echo "  STILL SOME ISSUES. KEEP DEBUGGING!  "
    echo "=========================================="
    exit 1
fi
