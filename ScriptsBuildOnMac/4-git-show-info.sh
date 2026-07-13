#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/0-config.sh"

echo
echo "========== Run git on Mac =========="

echo "PATH=$PATH"
echo "git-lfs=$(which git-lfs)"

cd "$PROJECT"

echo
echo "========== git - info current branch =========="
echo "Branch   : $(git rev-parse --abbrev-ref HEAD)"
echo "Revision : $(git rev-parse HEAD)"
echo "Comment  : $(git log -1 --pretty=%B)"
echo
