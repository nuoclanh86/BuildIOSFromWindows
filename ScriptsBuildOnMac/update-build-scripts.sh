#!/bin/bash

echo
echo "========== Run git on Mac =========="

PROJECT="/Users/admin/Documents/GitHub/BuildIOSFromWindows"

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

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
