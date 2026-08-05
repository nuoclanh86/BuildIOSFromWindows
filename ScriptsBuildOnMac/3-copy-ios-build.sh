#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/0-config.sh"

set -e

IPA_BUILT_TYPE=$1


IPA_FILE=$(find "$EXPORT_PATH" -name "*.ipa" | head -n 1)

if [ -z "$IPA_FILE" ]; then
	echo "ERROR: IPA file not found"
else
	echo "Copy: IPA file $IPA_BUILT_TYPE"
	TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

	# Rename IPA when copying
	if [ "$IPA_BUILT_TYPE" = "ReleaseBuild" ]; then
		IPA_SUFFIX="_release"
	elif [ "$IPA_BUILT_TYPE" = "cheat" ]; then
		IPA_SUFFIX="_cheat"
	else
		IPA_SUFFIX="_unknown"
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
	else
		MAC_DEST_FOLDER="$MAC_FOLDER_SHARED/$TIMESTAMP"
		mkdir -p "$MAC_DEST_FOLDER"

		echo
		echo "Copy IPA:"
		echo "$IPA_FILE"
		echo "To:"
		echo "$MAC_DEST_FOLDER/$NEW_IPA_NAME"

		cp "$IPA_FILE" "$MAC_DEST_FOLDER/$NEW_IPA_NAME"
		cp "$BUILD_LOG" "$MAC_DEST_FOLDER/$BUILD_LOG_FILENAME"

		echo
		echo "========== Copy IPA to Mac Share DONE =========="
	fi
	#
	# Copy IPA to Windows Share
	#
	echo
	echo "========== Copy IPA to Windows Share =========="

	if [ ! -d "$WINDOW_SHARE" ]; then
		echo "ERROR: Windows share not mounted: $WINDOW_SHARE"
	else
		DEST_FOLDER="$WINDOW_SHARE/$TIMESTAMP"
		mkdir -p "$DEST_FOLDER"

		echo
		echo "Copy IPA:"
		echo "$IPA_FILE"
		echo "To:"
		echo "$DEST_FOLDER/$NEW_IPA_NAME"

		cp "$IPA_FILE" "$DEST_FOLDER/$NEW_IPA_NAME"		
		cp "$BUILD_LOG" "$MAC_DEST_FOLDER/$BUILD_LOG_FILENAME"

		echo
		echo "========== Copy IPA to Windows Share DONE =========="

	fi
	
fi

echo
