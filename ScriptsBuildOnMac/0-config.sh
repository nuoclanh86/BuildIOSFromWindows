#!/bin/bash

PROJECT="/Users/admin/Documents/GitHub/kinder"
BUILD_SCRIPT_FOLDER="/Users/admin/Documents/GitHub/BuildIOSFromWindows"

BUILD_ROOT="$PROJECT/_build"
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

UNITY="/Applications/Unity/Hub/Editor/6000.3.12f1/Unity.app/Contents/MacOS/Unity"

PROJECT_PATH="$BUILD_ROOT/ios"
ARCHIVE_PATH="$BUILD_ROOT/Archive.xcarchive"
EXPORT_PATH="$BUILD_ROOT/IPA"
EXPORT_OPTIONS="/Users/admin/Documents/GitHub/BuildIOSFromWindows/ScriptsBuildOnMac/ExportOptions.plist"

# Windows shared folder
WINDOW_SHARE="/Volumes/Shared_Write/IOS_auto_build"

SCHEME="Unity-iPhone"
CONFIGURATION="Release"
