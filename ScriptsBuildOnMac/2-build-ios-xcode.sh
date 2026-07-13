#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/0-config.sh"

echo
echo "===================================================="
echo " Start build-ios-APD"
echo "===================================================="
echo

START_TIME=$(date +%s)

STORE_TYPE=$1
BUILD_CONFIG=$2

echo "Store Type  : $STORE_TYPE"
echo "Build Config: $BUILD_CONFIG"
echo

cd "$PROJECT"

"$UNITY" \
-projectPath "$PROJECT" \
-batchmode \
-quit \
-logFile - \
-executeMethod AutoBuilder.Jenkins_Build_IOS \
-storeType "$STORE_TYPE" \
-buildConfig "$BUILD_CONFIG"

RESULT=$?

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo
echo "Elapsed: ${ELAPSED}s"
echo

if [ $RESULT -eq 0 ]; then
    echo "========== BUILD SUCCESS =========="
	echo "Current time: $(date '+%Y-%m-%d %H:%M:%S')"
else
    echo "========== BUILD FAILED =========="
fi

exit $RESULT
