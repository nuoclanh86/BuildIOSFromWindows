@echo off

set MAC_AUTO_BUILD=Users/admin/Documents/GitHub/BuildIOSFromWindows

echo ----- Window - update-build-scripts
ssh admin@10.219.12.174 "/%MAC_AUTO_BUILD%/ScriptsBuildOnMac/update-build-scripts.sh"

pause