@echo off

set BRANCH=feature/toy-agent/prototype-v7/develop
REM set BRANCH=feature/tung/prototype-v7
set STORE_TYPE=global
set BUILD_CONFIG=releaseBuild

set MAC_AUTO_BUILD=Users/admin/Documents/GitHub/BuildIOSFromWindows/ScriptsBuildOnMac

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
call :BUILD
call :ARCHIVE
call :IPA
call :COPY
call :SHOWINFO
goto END

:PREPARE
echo ----- Window - 1-git-prepare-build.sh %BRANCH%
ssh admin@10.219.12.174 "/%MAC_AUTO_BUILD%/1-git-prepare-build.sh" %BRANCH%
exit /b

:BUILD
echo ----- Window - 2-build-ios-xcode.sh %STORE_TYPE% %BUILD_CONFIG%
ssh admin@10.219.12.174 "/%MAC_AUTO_BUILD%/2-build-ios-xcode.sh" %STORE_TYPE% %BUILD_CONFIG%
exit /b

:ARCHIVE
echo ----- Window - 3-build-ios-ipa.sh Archive
ssh admin@10.219.12.174 "/%MAC_AUTO_BUILD%/3-build-ios-ipa.sh" Archive
exit /b

:IPA
echo ----- Window - 3-build-ios-ipa.sh IPA
ssh admin@10.219.12.174 "/%MAC_AUTO_BUILD%/3-build-ios-ipa.sh" IPA
exit /b

:COPY
echo ----- Window - 3-build-ios-ipa.sh Copy IPA
ssh admin@10.219.12.174 "/%MAC_AUTO_BUILD%/3-build-ios-ipa.sh" Copy
exit /b

:SHOWINFO
echo ----- Window - 4-git-show-info.sh
ssh admin@10.219.12.174 "/%MAC_AUTO_BUILD%/4-git-show-info.sh"
exit /b

:END
pause