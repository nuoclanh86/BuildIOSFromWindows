#!/bin/bash

set -e

BRANCH="feature/toy-agent/prototype-v7/develop"
# BRANCH="feature/tung/prototype-v7"

STORE_TYPE="global"
BUILD_CONFIG="releaseBuild"

SCRIPT_DIR="$(pwd)/ScriptsBuildOnMac"

#=====================================================
# Special preset
#=====================================================
if [[ "$1" == "tung" ]]; then
    BRANCH="feature/tung/prototype-v7"
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

    "$SCRIPT_DIR/1-git-prepare-build.sh" "$BRANCH"
    check_error "Update" $?
}

run_build()
{
    echo
    echo "----- MAC - 2-build-ios-xcode.sh $STORE_TYPE $BUILD_CONFIG"

    "$SCRIPT_DIR/2-build-ios-xcode.sh" "$STORE_TYPE" "$BUILD_CONFIG"
    check_error "Build" $?
}

run_archive()
{
    echo
    echo "----- MAC - 3-build-ios-ipa.sh Archive"

    "$SCRIPT_DIR/3-build-ios-ipa.sh" Archive
    check_error "Archive" $?
}

run_ipa()
{
    echo
    echo "----- MAC - 3-build-ios-ipa.sh IPA"

    "$SCRIPT_DIR/3-build-ios-ipa.sh" IPA
    check_error "IPA" $?
}

run_copy()
{
    echo
    echo "----- MAC - Copy IPA"

    # "$SCRIPT_DIR/3-build-ios-ipa.sh" Copy

    check_error "Copy" 0
}

run_info()
{
    echo
    echo "----- MAC - 4-git-show-info.sh"

    "$SCRIPT_DIR/4-git-show-info.sh"
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
        echo "  ./build-IOS-APD-Mac.sh tung"
        exit 1
        ;;
esac