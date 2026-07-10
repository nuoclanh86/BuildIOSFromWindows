#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/config.sh"

echo
echo "========== Run git on Mac =========="

echo "PATH=$PATH"
echo "git-lfs=$(which git-lfs)"

cd "$PROJECT" || exit 1

echo
echo "========== git - info current branch =========="
echo "Branch   : $(git rev-parse --abbrev-ref HEAD)"
echo "Revision : $(git rev-parse HEAD)"
echo "Comment  : $(git log -1 --pretty=%B)"
echo
