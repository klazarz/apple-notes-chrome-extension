#!/usr/bin/env python3
"""
Native messaging host for Save to Apple Notes Chrome extension.
Receives messages from Chrome and creates notes in Apple Notes via AppleScript.
"""

import json
import struct
import subprocess
import sys


def read_message():
    """Read a message from Chrome (length-prefixed JSON)."""
    raw_length = sys.stdin.buffer.read(4)
    if not raw_length:
        return None
    message_length = struct.unpack('=I', raw_length)[0]
    message = sys.stdin.buffer.read(message_length).decode('utf-8')
    return json.loads(message)


def send_message(message):
    """Send a message to Chrome (length-prefixed JSON)."""
    encoded = json.dumps(message).encode('utf-8')
    sys.stdout.buffer.write(struct.pack('=I', len(encoded)))
    sys.stdout.buffer.write(encoded)
    sys.stdout.buffer.flush()


def create_note(title, url):
    """Create a note in Apple Notes using AppleScript."""
    # Escape special characters for AppleScript
    escaped_title = title.replace('\\', '\\\\').replace('"', '\\"')
    escaped_url = url.replace('\\', '\\\\').replace('"', '\\"')

    applescript = f'''
    tell application "Notes"
        activate
        tell account "iCloud"
            make new note with properties {{name:"{escaped_title}", body:"<h1>{escaped_title}</h1><p><a href=\\"{escaped_url}\\">{escaped_url}</a></p>"}}
        end tell
    end tell
    '''

    try:
        subprocess.run(
            ['osascript', '-e', applescript],
            check=True,
            capture_output=True,
            text=True
        )
        return True, None
    except subprocess.CalledProcessError as e:
        # Try with default account if iCloud fails
        applescript_default = f'''
        tell application "Notes"
            activate
            make new note with properties {{name:"{escaped_title}", body:"<h1>{escaped_title}</h1><p><a href=\\"{escaped_url}\\">{escaped_url}</a></p>"}}
        end tell
        '''
        try:
            subprocess.run(
                ['osascript', '-e', applescript_default],
                check=True,
                capture_output=True,
                text=True
            )
            return True, None
        except subprocess.CalledProcessError as e2:
            return False, str(e2.stderr)


def main():
    message = read_message()
    if not message:
        send_message({'success': False, 'error': 'No message received'})
        return

    if message.get('action') == 'createNote':
        title = message.get('title', 'Untitled')
        url = message.get('url', '')
        success, error = create_note(title, url)
        if success:
            send_message({'success': True})
        else:
            send_message({'success': False, 'error': error or 'Failed to create note'})
    else:
        send_message({'success': False, 'error': 'Unknown action'})


if __name__ == '__main__':
    main()
