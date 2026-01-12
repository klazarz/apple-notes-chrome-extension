#!/bin/bash

# Installation script for Save to Apple Notes Chrome extension native messaging host

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOST_NAME="com.applenotes.chrome"
HOST_PATH="$SCRIPT_DIR/native-host/apple_notes_host.py"

# Chrome native messaging hosts directory
CHROME_NM_DIR="$HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts"

echo "=== Save to Apple Notes - Native Host Installer ==="
echo ""

# Check if extension ID was provided
if [ -z "$1" ]; then
    echo "Usage: ./install.sh <extension-id>"
    echo ""
    echo "To get your extension ID:"
    echo "  1. Open Chrome and go to chrome://extensions"
    echo "  2. Enable 'Developer mode' (toggle in top right)"
    echo "  3. Click 'Load unpacked' and select: $SCRIPT_DIR"
    echo "  4. Copy the extension ID shown under the extension name"
    echo "  5. Run: ./install.sh <paste-extension-id-here>"
    echo ""
    exit 1
fi

EXTENSION_ID="$1"

echo "Extension ID: $EXTENSION_ID"
echo "Host path: $HOST_PATH"
echo ""

# Make the host script executable
chmod +x "$HOST_PATH"

# Create Chrome native messaging hosts directory if it doesn't exist
mkdir -p "$CHROME_NM_DIR"

# Create the manifest file
MANIFEST_PATH="$CHROME_NM_DIR/$HOST_NAME.json"

cat > "$MANIFEST_PATH" << EOF
{
  "name": "$HOST_NAME",
  "description": "Native messaging host for Save to Apple Notes Chrome extension",
  "path": "$HOST_PATH",
  "type": "stdio",
  "allowed_origins": [
    "chrome-extension://$EXTENSION_ID/"
  ]
}
EOF

echo "Installed native messaging host manifest to:"
echo "  $MANIFEST_PATH"
echo ""
echo "Installation complete!"
echo ""
echo "You can now use the extension to save pages to Apple Notes."
echo "Click the extension icon in Chrome to test it."
