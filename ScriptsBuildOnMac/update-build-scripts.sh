#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/0-config.sh"

echo
echo "========== Run git on Mac =========="

echo "PATH=$PATH"
echo "git-lfs=$(which git-lfs)"

cd "$PROJECT" || exit 1

echo
echo "========== git - clean =========="

git clean -fd

echo
echo "========== git - reset =========="
git reset --hard

echo
echo "========== git - fetch =========="
git fetch

echo
echo "========== git - pull =========="

git pull

echo
echo "========== git - done =========="
echo "Branch   : $(git rev-parse --abbrev-ref HEAD)"
echo "Revision : $(git rev-parse HEAD)"
echo "Comment  : $(git log -1 --pretty=%B)"
echo
