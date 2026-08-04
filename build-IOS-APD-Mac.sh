#!/bin/bash

source "$BUILD_SCRIPT_FOLDER/ScriptsBuildOnMac/0-config.sh"

set -e

SECONDS=0

BRANCH="feature/toy-agent/prototype-v7/develop"
# BRANCH="feature/tung/prototype-v7"

STORE_TYPE="global"
BUILD_CONFIG="fastBuild"

#=====================================================
# Special preset
#=====================================================
if [[ "$1" == "tung" ]]; then
    BRANCH="feature/tung/prototype-v7"
    MODE="all"
elif [[ "$1" == "release" ]]; then
    BUILD_CONFIG="releaseBuild"
    MODE="all"
elif [[ -z "$1" ]]; then
    MODE="all"
else
    MODE="$1"
fi

check_error()
{
    local STEP="$1"
    local CODE=$2

    echo "Finished This Step at : $(date)"
	elapsed=$SECONDS

	hours=$((elapsed / 3600))
	minutes=$(((elapsed % 3600) / 60))

	echo
	echo
	echo "========== Finished in ${hours} hr ${minutes} min =========="
	echo
	echo
	echo

    if [[ $CODE -ne 0 ]]; then
        echo
        echo "========================================"
        echo "BUILD FAILED at step: $STEP"
        echo "Exit Code: $CODE"
        echo "========================================"
        exit $CODE
    fi
}

run_update()
{
    echo
    echo "----- MAC - 1-git-prepare-build.sh $BRANCH"

    "$BUILD_SCRIPT_FOLDER/ScriptsBuildOnMac/1-git-prepare-build.sh" "$BRANCH"
    check_error "Update" $?
}

run_build()
{
    echo
    echo "----- MAC - 2-build-ios-xcode.sh $STORE_TYPE $BUILD_CONFIG"

    caffeinate "$BUILD_SCRIPT_FOLDER/ScriptsBuildOnMac/2-build-ios-xcode.sh" "$STORE_TYPE" "$BUILD_CONFIG"
    check_error "Build" $?
}

run_archive()
{
    echo
    echo "----- MAC - 3-build-ios-ipa.sh Archive"

    caffeinate "$BUILD_SCRIPT_FOLDER/ScriptsBuildOnMac/3-build-ios-ipa.sh" Archive
    check_error "Archive" $?
}

run_ipa()
{
    echo
    echo "----- MAC - 3-build-ios-ipa.sh IPA"

    caffeinate "$BUILD_SCRIPT_FOLDER/ScriptsBuildOnMac/3-build-ios-ipa.sh" IPA
    check_error "IPA" $?
}

run_copy()
{
    echo
    echo "----- MAC - Copy IPA"

    "$BUILD_SCRIPT_FOLDER/ScriptsBuildOnMac/3-build-ios-ipa.sh" Copy

    check_error "Copy" 0
}

run_info()
{
    echo
    echo "----- MAC - 4-git-show-info.sh"

    "$BUILD_SCRIPT_FOLDER/ScriptsBuildOnMac/4-git-show-info.sh"
    check_error "ShowInfo" $?
}

case "$MODE" in
    all)
        run_update
        run_build
        run_archive
        run_ipa
        run_copy
        run_info

        echo
        echo "========================================"
        echo "          BUILD SUCCESS!"
        echo "========================================"
        ;;

    update)
        run_update
        ;;

    build)
        run_build
        ;;

    archive)
        run_archive
        ;;

    ipa)
        run_ipa
        ;;

    copy)
        run_copy
        ;;

    info)
        run_info
        ;;

    *)
        echo "Unknown parameter: $MODE"
        echo
        echo "Usage:"
        echo "  ./build-IOS-APD-Mac.sh"
        echo "  ./build-IOS-APD-Mac.sh update"
        echo "  ./build-IOS-APD-Mac.sh build"
        echo "  ./build-IOS-APD-Mac.sh archive"
        echo "  ./build-IOS-APD-Mac.sh ipa"
        echo "  ./build-IOS-APD-Mac.sh copy"
        echo "  ./build-IOS-APD-Mac.sh info"
        echo "  ./build-IOS-APD-Mac.sh release"		
        echo "  ./build-IOS-APD-Mac.sh tung"
        exit 1
        ;;
esac