@echo off
rem Unblock Zone.Identifier and launch silent background agent
powershell -NoProfile -ExecutionPolicy Bypass -Command "Unblock-File -Path '%~dp0agent-windows-silent.exe' -ErrorAction SilentlyContinue; Start-Process -FilePath '%~dp0agent-windows-silent.exe'"
