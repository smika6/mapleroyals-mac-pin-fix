#!/bin/bash
# Replaces iphlpapi.dll in CrossOver to fix MapleRoyals pin login issue.
#
# Looks for iphlpapi.dll in:
#   1. The same folder as this script
#   2. ~/Downloads (asks: use from there, or move next to this script first)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST="/Applications/CrossOver.app/Contents/SharedSupport/CrossOver/lib/wine/i386-windows/iphlpapi.dll"

LOCAL_DLL="$SCRIPT_DIR/iphlpapi.dll"
DOWNLOADS_DLL="$HOME/Downloads/iphlpapi.dll"

SRC=""

if [ -f "$LOCAL_DLL" ]; then
    SRC="$LOCAL_DLL"
elif [ -f "$DOWNLOADS_DLL" ]; then
    CHOICE=$(osascript -e "set ans to button returned of (display dialog \"iphlpapi.dll was found in your Downloads folder, but not next to this script.\n\nUse it from Downloads, or move it next to the script first?\" buttons {\"Cancel\", \"Use from Downloads\", \"Move and use\"} default button \"Move and use\" with title \"MapleRoyals Pin Fix\")" 2>/dev/null)
    case "$CHOICE" in
        "Move and use")
            if ! mv "$DOWNLOADS_DLL" "$LOCAL_DLL" 2>/dev/null; then
                osascript -e 'display alert "Move failed" message "Could not move iphlpapi.dll from Downloads." as critical'
                exit 1
            fi
            SRC="$LOCAL_DLL"
            ;;
        "Use from Downloads")
            SRC="$DOWNLOADS_DLL"
            ;;
        *)
            exit 0
            ;;
    esac
else
    osascript -e 'display alert "iphlpapi.dll not found" message "Download it from https://tinyurl.com/e633fsau and put it next to this script (or in your Downloads folder), then try again." as critical'
    exit 1
fi

if ! osascript -e "do shell script \"cp '$SRC' '$DEST'\" with administrator privileges" 2>/dev/null; then
    osascript -e 'display alert "Replacement failed" message "Could not copy iphlpapi.dll. Check that CrossOver is installed and you entered your password." as critical'
    exit 1
fi

osascript -e 'display notification "iphlpapi.dll replaced successfully" with title "MapleRoyals Fix"'
echo "Done. You can close this window."
sleep 2
