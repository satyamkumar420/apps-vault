#!/usr/bin/env bash
# Universal remote-manager agent installer (Linux & macOS)
# Usage: curl -sSL https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/install.sh | bash

set -e

OS="$(uname -s)"
case "$OS" in
  Linux*)
    curl -sSL https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/linux/install.sh | bash
    ;;
  Darwin*)
    curl -sSL https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/macos/install.sh | bash
    ;;
  *)
    echo "[-] Unsupported operating system: $OS" >&2
    echo "[-] For Windows, please run in PowerShell (Run as Administrator or User):" >&2
    echo "    irm https://raw.githubusercontent.com/satyamkumar420/apps-vault/master/remote-manager/windows/install.ps1 | iex" >&2
    exit 1
    ;;
esac
