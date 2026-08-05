#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/0-config.sh"

set -e

BUILD_TYPE=$1
IPA_BUILT_TYPE=$2

echo "Project : $PROJECT_PATH"
echo "Scheme  : $SCHEME"
echo "Config  : $CONFIGURATION"

security unlock-keychain -p "1234567890?a" ~/Library/Keychains/login.keychain-db

if [ "$BUILD_TYPE" == "Archive" ]; then

    echo
    echo "========== Start build Archive =========="

    xcodebuild \
    -project "$PROJECT_PATH/Unity-iPhone.xcodeproj" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -archivePath "$ARCHIVE_PATH" \
    archive

    echo
    echo "========== Xcode Archive DONE =========="

elif [ "$BUILD_TYPE" == "IPA" ]; then

    echo
    echo "========== Start Export IPA =========="

    rm -rf "$EXPORT_PATH"
    
    xcodebuild \
    -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportPath "$EXPORT_PATH" \
    -exportOptionsPlist "$EXPORT_OPTIONS"

    echo "========== Export IPA DONE =========="

else
    echo "ERROR: Invalid build type: $BUILD_TYPE"
    echo "Usage:"
    echo "  ./build.sh Archive"
    echo "  ./build.sh IPA"
    exit 1
fi

echo
