#!/bin/bash

# Installation script for Save to Apple Notes Chrome extension native messaging host

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOST_NAME="com.applenotes.chrome"
HOST_SOURCE="$SCRIPT_DIR/native-host/apple_notes_host.py"
HOST_PATH="/usr/local/bin/apple_notes_host.py"

# Stable extension ID (generated from the key in manifest.json)
EXTENSION_ID="mobmonabcddflgfffebjoogihkolkklg"

# Chrome native messaging hosts directory
CHROME_NM_DIR="$HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts"

echo "=== Save to Apple Notes - Native Host Installer ==="
echo ""

# Check if /usr/local/bin exists
if [ ! -d "/usr/local/bin" ]; then
    echo "Creating /usr/local/bin..."
    sudo mkdir -p /usr/local/bin
fi

# Copy native host to /usr/local/bin (avoids macOS sandbox restrictions)
echo "Installing native host to $HOST_PATH..."
echo "(You may be prompted for your password)"
sudo cp "$HOST_SOURCE" "$HOST_PATH"
sudo chmod +x "$HOST_PATH"

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

echo ""
echo "Installed native messaging host manifest to:"
echo "  $MANIFEST_PATH"
echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Open Chrome and go to chrome://extensions"
echo "  2. Enable 'Developer mode' (toggle in top right)"
echo "  3. Click 'Load unpacked' and select: $SCRIPT_DIR"
echo "  4. Click the extension icon to save pages to Apple Notes"
