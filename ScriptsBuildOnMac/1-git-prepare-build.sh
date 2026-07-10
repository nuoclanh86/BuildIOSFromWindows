#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/0-config.sh"

echo
echo "========== Run git on Mac =========="

BRANCH=$1
PROJECT="/Users/admin/Documents/GitHub/kinder"

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
echo "========== git - switch branch =========="

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "$CURRENT_BRANCH" = "$BRANCH" ]; then
    echo "Already on branch: $CURRENT_BRANCH"
else
    echo "Switching branch: $CURRENT_BRANCH -> $BRANCH"
    git switch "$BRANCH"
fi

echo
echo "========== git - pull =========="

git pull

echo
echo "========== git - done =========="
echo "Branch   : $(git rev-parse --abbrev-ref HEAD)"
echo "Revision : $(git rev-parse HEAD)"
echo
