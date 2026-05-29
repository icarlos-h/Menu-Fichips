@echo off
set SCRIPT_DIR=%~dp0
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%launch-screens.ps1" -FullscreenInsteadOfPositioned $true
