#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/0-config.sh"

set -e

BUILD_TYPE=$1

echo "Project : $PROJECT_PATH"
echo "Scheme  : $SCHEME"
echo "Config  : $CONFIGURATION"

security unlock-keychain -p "1234567890?a" ~/Library/Keychains/login.keychain-db

SECONDS=0

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
	
	elapsed=$SECONDS
	hours=$((elapsed / 3600))
	minutes=$(((elapsed % 3600) / 60))
	echo "========== Finished in ${hours} hr ${minutes} min =========="

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
	
	elapsed=$SECONDS
	hours=$((elapsed / 3600))
	minutes=$(((elapsed % 3600) / 60))
	echo "========== Finished in ${hours} hr ${minutes} min =========="

elif [ "$BUILD_TYPE" == "Copy" ]; then

    IPA_FILE=$(find "$EXPORT_PATH" -name "*.ipa" | head -n 1)

    if [ -z "$IPA_FILE" ]; then
        echo "ERROR: IPA file not found"
        exit 1
    fi

    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

    # Rename IPA when copying
    if [ "$BUILD_CONFIG" = "ReleaseBuild" ]; then
        IPA_SUFFIX="_release"
    else
        IPA_SUFFIX="_cheat"
    fi

    IPA_FILENAME=$(basename "$IPA_FILE")
    IPA_NAME="${IPA_FILENAME%.ipa}"
    NEW_IPA_NAME="${IPA_NAME}${IPA_SUFFIX}.ipa"

    #
    # Copy IPA to Mac Share
    #
    echo
    echo "========== Copy IPA to Mac Share =========="

    if [ ! -d "$MAC_FOLDER_SHARED" ]; then
        echo "ERROR: Mac share folder not found: $MAC_FOLDER_SHARED"
        exit 1
    fi

    MAC_DEST_FOLDER="$MAC_FOLDER_SHARED/$TIMESTAMP"
    mkdir -p "$MAC_DEST_FOLDER"

    echo
    echo "Copy IPA:"
    echo "$IPA_FILE"
    echo "To:"
    echo "$MAC_DEST_FOLDER/$NEW_IPA_NAME"

    cp "$IPA_FILE" "$MAC_DEST_FOLDER/$NEW_IPA_NAME"

    echo
    echo "========== Copy IPA to Mac Share DONE =========="

    #
    # Copy IPA to Windows Share
    #
    echo
    echo "========== Copy IPA to Windows Share =========="

    if [ ! -d "$WINDOW_SHARE" ]; then
        echo "ERROR: Windows share not mounted: $WINDOW_SHARE"
        exit 1
    fi

    DEST_FOLDER="$WINDOW_SHARE/$TIMESTAMP"
    mkdir -p "$DEST_FOLDER"

    echo
    echo "Copy IPA:"
    echo "$IPA_FILE"
    echo "To:"
    echo "$DEST_FOLDER/$NEW_IPA_NAME"

    cp "$IPA_FILE" "$DEST_FOLDER/$NEW_IPA_NAME"

    echo
    echo "========== Copy IPA to Windows Share DONE =========="

    elapsed=$SECONDS
    hours=$((elapsed / 3600))
    minutes=$(((elapsed % 3600) / 60))

    echo
    echo
    echo "========== Finished in ${hours} hr ${minutes} min =========="
    echo
    echo
    echo

else

    echo "ERROR: Invalid build type: $BUILD_TYPE"
    echo "Usage:"
    echo "  ./build.sh Archive"
    echo "  ./build.sh IPA"
    exit 1

fi

echo
