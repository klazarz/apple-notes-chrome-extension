# Save to Apple Notes - Chrome Extension

A Chrome extension that saves the current webpage to Apple Notes with one click. The page title becomes the note title, and the URL is saved in the note body.

## Requirements

- macOS (uses AppleScript to interact with Apple Notes)
- Google Chrome
- Python 3 (pre-installed on macOS)

## Installation

### Step 1: Install the Native Messaging Host

Open Terminal and run:

```bash
cd /path/to/apple-notes-chrome-extension
chmod +x install.sh
./install.sh
```

You'll be prompted for your password to install the native host to `/usr/local/bin`.

### Step 2: Load the Extension in Chrome

1. Open Chrome and navigate to `chrome://extensions`
2. Enable **Developer mode** (toggle in the top right corner)
3. Click **Load unpacked**
4. Select the `apple-notes-chrome-extension` folder

### Step 3: Grant Permissions

The first time you use the extension, macOS will ask for permission to control Apple Notes. Click **OK** to allow.

## Usage

1. Navigate to any webpage you want to save
2. Click the extension icon in Chrome's toolbar
3. Review the title and URL
4. Click **Save to Notes**
5. The note will be created in Apple Notes and the app will open

## How It Works

The extension uses Chrome's Native Messaging API to communicate with a Python script on your Mac. The Python script uses AppleScript to create notes in Apple Notes.

```
Chrome Extension → Native Messaging → Python Script → AppleScript → Apple Notes
```

## Troubleshooting

### "Error: Native host has exited"

This usually means the native host isn't installed correctly. Re-run the install script:
```bash
./install.sh
```

If the error persists, verify the native host is installed:
```bash
ls -la /usr/local/bin/apple_notes_host.py
cat ~/Library/Application\ Support/Google/Chrome/NativeMessagingHosts/com.applenotes.chrome.json
```

### "Error: Access not allowed"

You need to grant automation permissions:
1. Open **System Settings** → **Privacy & Security** → **Automation**
2. Find the entry for Python/Terminal and enable Apple Notes

### Note not appearing in iCloud

The extension tries to create notes in your iCloud account first. If that fails, it falls back to the default account. Make sure you're signed into iCloud in Apple Notes.

## Uninstallation

1. Remove the extension from `chrome://extensions`
2. Delete the native messaging host:
   ```bash
   sudo rm /usr/local/bin/apple_notes_host.py
   rm ~/Library/Application\ Support/Google/Chrome/NativeMessagingHosts/com.applenotes.chrome.json
   ```

## Files

```
apple-notes-chrome-extension/
├── manifest.json          # Chrome extension manifest
├── popup.html             # Extension popup UI
├── popup.js               # Popup logic
├── icons/                 # Extension icons
├── install.sh             # Installation script
├── README.md              # This file
└── native-host/
    └── apple_notes_host.py    # Native messaging host
```

## Acknowledgements
Created 100% by Claude Code - One Shot
