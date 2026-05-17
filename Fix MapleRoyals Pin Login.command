#!/bin/bash
# Replaces iphlpapi.dll in CrossOver to fix MapleRoyals pin login issue

SRC="$HOME/Documents/iphlpapi.dll"
DEST="/Applications/CrossOver.app/Contents/SharedSupport/CrossOver/lib/wine/i386-windows/iphlpapi.dll"

if [ ! -f "$SRC" ]; then
    osascript -e 'display alert "Source file missing" message "iphlpapi.dll not found in ~/Documents. Download it from https://tinyurl.com/e633fsau and place it in your Documents folder." as critical'
    exit 1
fi

if ! osascript -e "do shell script \"cp '$SRC' '$DEST'\" with administrator privileges" 2>/dev/null; then
    osascript -e 'display alert "Replacement failed" message "Could not copy iphlpapi.dll. Check that CrossOver is installed and you entered your password." as critical'
    exit 1
fi

osascript -e 'display notification "iphlpapi.dll replaced successfully" with title "MapleRoyals Fix"'
echo "Done. You can close this window."
sleep 2
