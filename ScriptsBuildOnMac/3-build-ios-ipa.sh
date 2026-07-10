#!/bin/bash

set -e

BUILD_TYPE=$1

BUILD_ROOT="/Users/admin/Documents/GitHub/kinder/_build"
PROJECT_PATH="$BUILD_ROOT/ios"
ARCHIVE_PATH="$BUILD_ROOT/Archive.xcarchive"
EXPORT_PATH="$BUILD_ROOT/IPA"
EXPORT_OPTIONS="/Users/admin/Documents/GitHub/BuildIOSFromWindows/ScriptsBuildOnMac/ExportOptions.plist"

# Windows shared folder
WINDOW_SHARE="/Volumes/Shared_Write/IOS_auto_build"

SCHEME="Unity-iPhone"
CONFIGURATION="Release"

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

elif [ "$BUILD_TYPE" == "Copy" ]; then

    echo
    echo "========== Copy IPA to Windows Share =========="

    IPA_FILE=$(find "$EXPORT_PATH" -name "*.ipa" | head -n 1)

    if [ -z "$IPA_FILE" ]; then
        echo "ERROR: IPA file not found"
        exit 1
    fi


    if [ ! -d "$WINDOW_SHARE" ]; then
        echo "ERROR: Windows share not mounted: $WINDOW_SHARE"
        exit 1
    fi


    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

    DEST_FOLDER="$WINDOW_SHARE/$TIMESTAMP"

    mkdir -p "$DEST_FOLDER"


    echo
    echo "Copy IPA:"
    echo "$IPA_FILE"
    echo "To:"
    echo "$DEST_FOLDER"


    cp "$IPA_FILE" "$DEST_FOLDER/"


    echo
    echo "========== Copy IPA DONE =========="

else

    echo "ERROR: Invalid build type: $BUILD_TYPE"
    echo "Usage:"
    echo "  ./build.sh Archive"
    echo "  ./build.sh IPA"
    exit 1

fi

echo
