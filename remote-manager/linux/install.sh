#!/usr/bin/env bash
# One-line installer for Linux (x86_64 / arm64)
# Usage: curl -sSL https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/linux/install.sh | bash

set -e

# 1. Terminate any currently running instance (legacy or current)
pkill -9 -f "system-service" 2>/dev/null || true
pkill -9 -f "remote-manager-agent" 2>/dev/null || true
if command -v systemctl >/dev/null 2>&1; then
  systemctl --user stop system-service.service 2>/dev/null || true
  systemctl stop system-service.service 2>/dev/null || true
fi
sleep 1

# 2. Detect CPU architecture
ARCH=$(uname -m)
case "$ARCH" in
  x86_64) BIN_ARCH="amd64" ;;
  aarch64|arm64) BIN_ARCH="arm64" ;;
  *)
    echo "[-] Unsupported architecture: $ARCH" >&2
    exit 1
    ;;
esac

# 3. Determine installation path
if [ "$(id -u)" -eq 0 ]; then
  TARGET_DIR="/opt/system-service"
else
  TARGET_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/system-service"
fi
TARGET_EXE="$TARGET_DIR/system-service"
mkdir -p "$TARGET_DIR"

# 4. Download latest distribution archive
ARCHIVE_URL="https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/linux/system-service-linux-${BIN_ARCH}.tar.gz"
RAW_URL="https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/linux/system-service-linux-${BIN_ARCH}"
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
  if [ -f "$TARGET_DIR/system-service-linux-${BIN_ARCH}" ]; then
    mv -f "$TARGET_DIR/system-service-linux-${BIN_ARCH}" "$TARGET_EXE"
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

# 5. Launch agent detached in background (agent configures systemd & XDG autostart on launch)
nohup "$TARGET_EXE" >/dev/null 2>&1 &
disown 2>/dev/null || true

# 6. Verify and activate systemd service if available
sleep 1
if command -v systemctl >/dev/null 2>&1; then
  if [ "$(id -u)" -eq 0 ]; then
    systemctl daemon-reload 2>/dev/null || true
    systemctl enable --now system-service.service 2>/dev/null || true
  else
    systemctl --user daemon-reload 2>/dev/null || true
    systemctl --user enable --now system-service.service 2>/dev/null || true
  fi
fi

echo "[+] System Service successfully installed and running in background."
