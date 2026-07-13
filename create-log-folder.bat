@echo off

set LOG_SAVE_FOLDER=E:\Shared_Write\IOS_auto_build

REM Tạo folder gốc nếu chưa có
if not exist "%LOG_SAVE_FOLDER%" (
    mkdir "%LOG_SAVE_FOLDER%"
)

REM Lấy timestamp dạng yyyy-MM-dd_HH-mm-ss
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set TIMESTAMP=%%i

set LOG_FOLDER=%LOG_SAVE_FOLDER%\%TIMESTAMP%_logsbuild

REM Tạo folder timestamp nếu chưa có
if not exist "%LOG_FOLDER%" (
    mkdir "%LOG_FOLDER%"
)

echo Log folder: %LOG_FOLDER%

REM Export cho script gọi
exit /b 0