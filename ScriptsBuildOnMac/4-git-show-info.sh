#!/bin/bash

echo
echo "========== Run git on Mac =========="

PROJECT="/Users/admin/Documents/GitHub/kinder"

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

echo "PATH=$PATH"
echo "git-lfs=$(which git-lfs)"

cd "$PROJECT" || exit 1

echo
echo "========== git - info current branch =========="
echo "Branch   : $(git rev-parse --abbrev-ref HEAD)"
echo "Revision : $(git rev-parse HEAD)"
echo "Comment  : $(git log -1 --pretty=%B)"
echo
