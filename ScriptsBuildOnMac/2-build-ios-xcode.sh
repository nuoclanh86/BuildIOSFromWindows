#!/bin/bash

echo
echo "===================================================="
echo " Start build-ios-APD"
echo "===================================================="
echo

START_TIME=$(date +%s)

STORE_TYPE=$1
BUILD_CONFIG=$2

UNITY="/Applications/Unity/Hub/Editor/6000.3.12f1/Unity.app/Contents/MacOS/Unity"
PROJECT="/Users/admin/Documents/GitHub/kinder"

echo "Store Type  : $STORE_TYPE"
echo "Build Config: $BUILD_CONFIG"
echo

cd "$PROJECT" || exit 1

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
else
    echo "========== BUILD FAILED =========="
fi

exit $RESULT
