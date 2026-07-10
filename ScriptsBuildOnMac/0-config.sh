#!/bin/bash

# All these paths are on the Mac

PROJECT="/Users/admin/Documents/GitHub/kinder"
BUILD_SCRIPT_FOLDER="/Users/admin/Documents/GitHub/BuildIOSFromWindows"
UNITY="/Applications/Unity/Hub/Editor/6000.3.12f1/Unity.app/Contents/MacOS/Unity"
# Windows shared folder mounted on the Mac
WINDOW_SHARE="/Volumes/Shared_Write/IOS_auto_build"




# Default Path
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
BUILD_ROOT="$PROJECT/_build"
PROJECT_PATH="$BUILD_ROOT/ios"
ARCHIVE_PATH="$BUILD_ROOT/Archive.xcarchive"
EXPORT_PATH="$BUILD_ROOT/IPA"
EXPORT_OPTIONS="$BUILD_SCRIPT_FOLDER/ScriptsBuildOnMac/ExportOptions.plist"

SCHEME="Unity-iPhone"
CONFIGURATION="Release"


echo "Current time: $(date '+%Y-%m-%d %H:%M:%S')"

