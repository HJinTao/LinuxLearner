#!/bin/bash
# Verify Chapter 08

set -e

LAB_DIR="lab/lab_files"

# Check if lab files exist
if [ ! -d "$LAB_DIR" ]; then
    echo "FAIL: Lab directory '$LAB_DIR' not found. Did you run 'lab/init.sh'?"
    exit 1
fi

PASS=true

# Check Task 1: worker.py running in background
if pgrep -f "worker.py" > /dev/null; then
    echo "PASS: Task 1 - 'worker.py' is running in background."
else
    echo "FAIL: Task 1 - 'worker.py' process not found. Did you run it with nohup &?"
    PASS=false
fi

# Check Task 2: myweb.service running
# Use systemctl status (check exit code 0 for active)
if systemctl is-active --quiet myweb; then
    echo "PASS: Task 2 - 'myweb.service' is active (running)."
else
    echo "FAIL: Task 2 - 'myweb.service' is not active. Check 'systemctl status myweb'."
    PASS=false
fi

# Check Task 3: myweb.service enabled
if systemctl is-enabled --quiet myweb; then
    echo "PASS: Task 3 - 'myweb.service' is enabled (autostart)."
else
    echo "FAIL: Task 3 - 'myweb.service' is not enabled. Run 'sudo systemctl enable myweb'."
    PASS=false
fi

if [ "$PASS" = true ]; then
    echo "=========================================="
    echo "  CONGRATULATIONS! ALL TESTS PASSED!  "
    echo "=========================================="
    exit 0
else
    echo "=========================================="
    echo "  SOME TESTS FAILED. KEEP TRYING!     "
    echo "=========================================="
    exit 1
fi
