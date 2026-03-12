#!/bin/bash
# Verify Chapter 06

set -e

LAB_DIR="lab/lab_files"

# Check if lab files exist
if [ ! -d "$LAB_DIR" ]; then
    echo "FAIL: Lab directory '$LAB_DIR' not found. Did you run 'lab/init.sh'?"
    exit 1
fi

cd "$LAB_DIR"

PASS=true

# Check Task 1: deploy.sh executable
if [ ! -x "deploy.sh" ]; then
    echo "FAIL: Task 1 - 'deploy.sh' is not executable. Run 'ls -l deploy.sh' to check permissions."
    PASS=false
else
    echo "PASS: Task 1 - 'deploy.sh' is executable."
fi

# Check Task 2: id_rsa 600
PERM=$(stat -c "%a" id_rsa)
if [ "$PERM" != "600" ]; then
    echo "FAIL: Task 2 - 'id_rsa' permission is $PERM (expected 600). It's too open!"
    PASS=false
else
    echo "PASS: Task 2 - 'id_rsa' is secure (600)."
fi

# Check Task 3: public_html 755
PERM=$(stat -c "%a" public_html)
if [ "$PERM" != "755" ]; then
    echo "FAIL: Task 3 - 'public_html' permission is $PERM (expected 755). Web server cannot access it!"
    PASS=false
else
    echo "PASS: Task 3 - 'public_html' is accessible (755)."
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
