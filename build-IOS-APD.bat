@echo off

set BRANCH=feature/toy-agent/prototype-v7/develop
REM set BRANCH=feature/tung/prototype-v7
set STORE_TYPE=global
set BUILD_CONFIG=releaseBuild

set MAC_AUTO_BUILD=Users/admin/Documents/GitHub/BuildIOSFromWindows/ScriptsBuildOnMac

call create-log-folder.bat

if errorlevel 1 (
    echo Cannot create log folder.
    pause
    exit /b 1
)

REM =====================================================
REM No parameter -> run all
REM =====================================================
if "%~1"=="" goto RUN_ALL

REM =====================================================
REM Run specific step
REM =====================================================

if /I "%~1"=="update" goto UPDATE
if /I "%~1"=="build" goto BUILD
if /I "%~1"=="archive" goto ARCHIVE
if /I "%~1"=="ipa" goto IPA
if /I "%~1"=="copy" goto COPY
if /I "%~1"=="info" goto SHOWINFO

echo Unknown parameter: %~1
echo.
echo Usage:
echo     build.bat
echo     build.bat update
echo     build.bat build
echo     build.bat archive
echo     build.bat ipa
echo     build.bat copy
echo     build.bat info
goto END

:RUN_ALL
call :UPDATE
call :CHECK_ERROR Update

call :BUILD
call :CHECK_ERROR Build

call :ARCHIVE
call :CHECK_ERROR Archive

call :IPA
call :CHECK_ERROR IPA

call :COPY
call :CHECK_ERROR Copy

call :SHOWINFO
call :CHECK_ERROR ShowInfo

echo.
echo ========================================
echo           BUILD SUCCESS!
echo ========================================
goto END

:UPDATE
echo.
echo ----- Window - 1-git-prepare-build.sh %BRANCH%
ssh admin@10.219.12.174 "/%MAC_AUTO_BUILD%/1-git-prepare-build.sh" %BRANCH% > "%LOG_FOLDER%\1-git-prepare-build.log" 2>&1
exit /b %ERRORLEVEL%

:BUILD
echo.
echo ----- Window - 2-build-ios-xcode.sh %STORE_TYPE% %BUILD_CONFIG%
ssh admin@10.219.12.174 "/%MAC_AUTO_BUILD%/2-build-ios-xcode.sh" %STORE_TYPE% %BUILD_CONFIG% > "%LOG_FOLDER%\2-build-ios-xcode.log" 2>&1
exit /b %ERRORLEVEL%

:ARCHIVE
echo.
echo ----- Window - 3-build-ios-ipa.sh Archive
ssh admin@10.219.12.174 "/%MAC_AUTO_BUILD%/3-build-ios-ipa.sh" Archive > "%LOG_FOLDER%\3-build-ios-ipa_Archive.log" 2>&1
exit /b %ERRORLEVEL%

:IPA
echo.
echo ----- Window - 3-build-ios-ipa.sh IPA
ssh admin@10.219.12.174 "/%MAC_AUTO_BUILD%/3-build-ios-ipa.sh" IPA > "%LOG_FOLDER%\3-build-ios-ipa_IPA.log" 2>&1
exit /b %ERRORLEVEL%

:COPY
echo.
echo ----- Window - 3-build-ios-ipa.sh Copy IPA
ssh admin@10.219.12.174 "/%MAC_AUTO_BUILD%/3-build-ios-ipa.sh" Copy > "%LOG_FOLDER%\3-build-ios-ipa_copyIPA.log" 2>&1
exit /b %ERRORLEVEL%

:SHOWINFO
echo.
echo ----- Window - 4-git-show-info.sh
ssh admin@10.219.12.174 "/%MAC_AUTO_BUILD%/4-git-show-info.sh" > "%LOG_FOLDER%\4-git-show-info.log" 2>&1
exit /b %ERRORLEVEL%

:CHECK_ERROR
if errorlevel 1 (
    echo.
    echo ========================================
    echo BUILD FAILED at step: %1
    echo Exit Code: %ERRORLEVEL%
    echo ========================================
    goto END
)
exit /b 0

:END
pause
exit /b