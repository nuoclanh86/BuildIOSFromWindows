#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

source "$(pwd)/ScriptsBuildOnMac/0-config.sh"

set -e

SECONDS=0

echo -e "${GREEN}============== Build CMD ===================================${NC}"
echo -e "${GREEN}== ./build-IOS-APD-Mac.sh 						--> 	build cheat 	, feature/toy-agent/prototype-v7/develop ${NC}"
echo -e "${GREEN}== ./build-IOS-APD-Mac.sh release 				--> 	build release 	, feature/toy-agent/prototype-v7/develop ${NC}"
echo -e "${GREEN}== ./build-IOS-APD-Mac.sh tung 				--> 	build cheat 	, feature/tung/prototype-v7 ${NC}"
echo -e "${GREEN}== ./build-IOS-APD-Mac.sh tung 'branch_name' 	-->		build cheat 	, 'branch_name' ${NC}"
echo -e "${GREEN}============================================================${NC}"

#=====================================================
# Special preset
#=====================================================
BUILT_IPA="non"
if [[ "$1" == "tung" ]]; then
    if [[ -n "$2" ]]; then
        BRANCH="$2"
    else
        BRANCH="feature/tung/prototype-v7"
    fi

    BUILT_IPA="cheat"
    MODE="all"

elif [[ "$1" == "release" ]]; then
    BUILD_CONFIG="releaseBuild"
    BUILT_IPA="releaseBuild"
    MODE="all"

elif [[ -z "$1" ]]; then
    BUILT_IPA="cheat"
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

	echo -e "${GREEN}============================================================${NC}"
	echo -e "${GREEN}==========${NC} Finished in ${hours} hr ${minutes} min ${GREEN}================${NC}"
	echo -e "${GREEN}============================================================${NC}"

    if [[ $CODE -ne 0 ]]; then
        echo
        echo -e "${RED}========================================${NC}"
        echo -e "${RED}BUILD FAILED at step: $STEP${NC}"
        echo -e "${RED}Exit Code: $CODE${NC}"
        echo -e "${RED}========================================${NC}"
        exit $CODE
    fi
}

run_update()
{
    echo
    echo "----- MAC - 1-git-prepare-build.sh $BRANCH -----"

    "$BUILD_SCRIPT_FOLDER/ScriptsBuildOnMac/1-git-prepare-build.sh" "$BRANCH"
    check_error "Update" $?
}

run_build()
{
    echo
    echo "----- MAC - 2-build-ios-xcode.sh $STORE_TYPE $BUILD_CONFIG"

    caffeinate "$BUILD_SCRIPT_FOLDER/ScriptsBuildOnMac/2-build-ios-xcode.sh" "$STORE_TYPE" "$BUILD_CONFIG" >> "$BUILD_LOG" 2>&1
    check_error "Build" $?
}

run_archive()
{
    echo
    echo "----- MAC - 3-build-ios-ipa.sh Archive -----"

    caffeinate "$BUILD_SCRIPT_FOLDER/ScriptsBuildOnMac/3-build-ios-ipa.sh" Archive >> "$BUILD_LOG" 2>&1
    check_error "Archive" $?
}

run_ipa()
{
    echo
    echo "----- MAC - 3-build-ios-ipa.sh IPA -----"

    caffeinate "$BUILD_SCRIPT_FOLDER/ScriptsBuildOnMac/3-build-ios-ipa.sh" IPA >> "$BUILD_LOG" 2>&1
    check_error "IPA" $?
}

run_copy()
{
    echo
    echo "----- MAC - Copy IPA -----"

    "$BUILD_SCRIPT_FOLDER/ScriptsBuildOnMac/3-copy-ios-build.sh" "$BUILT_IPA"

    check_error "Copy" 0
}

run_info()
{
    echo
    echo "----- MAC - 4-git-show-info.sh -----"

    if [ "$1" = "writelog" ]; then
        "$BUILD_SCRIPT_FOLDER/ScriptsBuildOnMac/4-git-show-info.sh" >> "$BUILD_LOG" 2>&1
    else
        "$BUILD_SCRIPT_FOLDER/ScriptsBuildOnMac/4-git-show-info.sh" hasColor
    fi

    check_error "ShowInfo" $?
}

case "$MODE" in
    all)
        run_update
		run_info
		run_info writelog
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
		run_info writelog
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
		echo "  ./build-IOS-APD-Mac.sh release"
		echo "  ./build-IOS-APD-Mac.sh tung"
		echo "  ./build-IOS-APD-Mac.sh update"
		echo "  ./build-IOS-APD-Mac.sh build"
		echo "  ./build-IOS-APD-Mac.sh archive"
		echo "  ./build-IOS-APD-Mac.sh ipa"
		echo "  ./build-IOS-APD-Mac.sh copy"
		echo "  ./build-IOS-APD-Mac.sh info"
        exit 1
        ;;
esac