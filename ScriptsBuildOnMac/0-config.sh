#!/bin/bash

# All these paths are on the Mac

PROJECT_DIR="/Users/admin/Documents/GitHub"

PROJECT="${PROJECT_DIR}/kinder"
BUILD_SCRIPT_FOLDER="/Users/admin/Documents/GitHub/BuildIOSFromWindows"
UNITY="/Applications/Unity/Hub/Editor/6000.3.12f1/Unity.app/Contents/MacOS/Unity"

# Windows shared folder mounted on the Mac
WINDOW_SHARE="/Volumes/Shared_Write/IOS_auto_build"
# Mac shared folder
MAC_FOLDER_SHARED="${PROJECT_DIR}/FolderShared"


BRANCH="feature/toy-agent/prototype-v7/develop"
# BRANCH="feature/tung/prototype-v7"
STORE_TYPE="global"
BUILD_CONFIG="fastBuild"


# Default Path
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
BUILD_ROOT="$PROJECT/_build"
PROJECT_PATH="$BUILD_ROOT/ios"
ARCHIVE_PATH="$BUILD_ROOT/Archive.xcarchive"
EXPORT_PATH="$BUILD_ROOT/IPA"
EXPORT_OPTIONS="$BUILD_SCRIPT_FOLDER/ScriptsBuildOnMac/ExportOptions.plist"

SCHEME="Unity-iPhone"
CONFIGURATION="Release"


