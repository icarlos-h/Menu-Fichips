@echo off
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-startup-task.ps1"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-shutdown-task.ps1"
pause
