@echo off

set MAC_AUTO_BUILD=Users/admin/Documents/GitHub/BuildIOSFromWindows

echo ----- Window - update-build-scripts
echo.

ssh admin@10.219.12.174 "/%MAC_AUTO_BUILD%/ScriptsBuildOnMac/update-build-scripts.sh" > build.log 2>&1

set EXIT_CODE=%ERRORLEVEL%

if %EXIT_CODE% neq 0 (
    echo.
    echo ========================================
    echo        BUILD FAILED!
    echo.
    echo Exit Code: %EXIT_CODE%
    echo Check build.log for details.
    echo ========================================
    pause
    exit /b %EXIT_CODE%
)

echo.
echo ========================================
echo        BUILD SUCCESS!
echo ========================================

pause
exit /b 0