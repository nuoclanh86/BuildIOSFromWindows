#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/0-config.sh"

echo
echo "========== Run git on Mac =========="

# echo "PATH=$PATH"
# echo "git-lfs=$(which git-lfs)"

cd "$PROJECT"

echo
echo -e "${YELLOW}========== git - info current branch ==========${NC}"
echo -e "${YELLOW}Branch   : $(git rev-parse --abbrev-ref HEAD)${NC}"
echo -e "${YELLOW}Revision : $(git rev-parse HEAD)${NC}"
echo -e "${YELLOW}Comment  : $(git log -1 --pretty=%B)${NC}"
echo
