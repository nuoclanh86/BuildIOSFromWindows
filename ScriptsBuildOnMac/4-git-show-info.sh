#!/bin/bash

set -e

USE_COLOR=$1

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/0-config.sh"

echo
echo "========== Run git on Mac =========="

# echo "PATH=$PATH"
# echo "git-lfs=$(which git-lfs)"

cd "$PROJECT"

if [ "$USE_COLOR" = "hasColor" ]; then
    COLOR="$YELLOW"
    RESET="$NC"
else
    COLOR=""
    RESET=""
fi

echo
echo -e "${COLOR}========== git - info current branch ==========${RESET}"
echo -e "${COLOR}Branch   : $(git rev-parse --abbrev-ref HEAD)${RESET}"
echo -e "${COLOR}Revision : $(git rev-parse HEAD)${RESET}"
echo -e "${COLOR}Comment  : $(git log -1 --pretty=%s)${RESET}"
echo