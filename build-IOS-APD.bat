@echo off

set MAC_AUTO_BUILD=/Users/admin/Documents/GitHub/BuildIOSFromWindows/build-IOS-APD-Mac.sh

ssh admin@10.219.12.174 "%MAC_AUTO_BUILD%" %~1

pause
exit /b