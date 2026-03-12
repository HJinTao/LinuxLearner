#!/bin/bash
# Verify Chapter 07

set -e

LAB_DIR="lab/lab_files"

# Check if lab files exist
if [ ! -d "$LAB_DIR" ]; then
    echo "FAIL: Lab directory '$LAB_DIR' not found. Did you run 'lab/init.sh'?"
    exit 1
fi

cd "$LAB_DIR"

PASS=true

# Check Task 1: legacy_code directory exists
if [ ! -d "legacy_code" ]; then
    echo "FAIL: Task 1 - 'legacy_code' directory not found. Did you extract the tar.gz?"
    PASS=false
else
    echo "PASS: Task 1 - 'legacy_code' extracted successfully."
fi

# Check Task 2: config_backup.tar.gz exists
if [ ! -f "config_backup.tar.gz" ]; then
    echo "FAIL: Task 2 - 'config_backup.tar.gz' not found."
    PASS=false
else
    # Check if it contains config/
    if tar -tf config_backup.tar.gz | grep -q "config/"; then
        echo "PASS: Task 2 - 'config_backup.tar.gz' contains config directory."
    else
        echo "FAIL: Task 2 - 'config_backup.tar.gz' is empty or doesn't contain 'config/'."
        PASS=false
    fi
fi

# Check Task 3: logs.zip exists
if [ ! -f "logs.zip" ]; then
    echo "FAIL: Task 3 - 'logs.zip' not found."
    PASS=false
else
    # Check if it contains logs/
    if unzip -l logs.zip | grep -q "logs/"; then
        echo "PASS: Task 3 - 'logs.zip' contains logs directory."
    else
        echo "FAIL: Task 3 - 'logs.zip' is empty or doesn't contain 'logs/'."
        PASS=false
    fi
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
