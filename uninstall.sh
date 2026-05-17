#!/bin/bash
# Removes the MapleRoyals pin login fix Quick Action and (optionally) the Desktop script.
# Does NOT touch the iphlpapi.dll already copied into CrossOver (that's the actual fix).

WORKFLOW_NAME="Install iphlpapi.dll (MapleRoyals fix).workflow"
COMMAND_NAME="Fix MapleRoyals Pin Login.command"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "=========================================="
echo "  MapleRoyals Pin Login Fix - Uninstaller"
echo "=========================================="
echo ""

removed_any=false

# Remove the Quick Action
if [ -d "$HOME/Library/Services/$WORKFLOW_NAME" ]; then
    rm -rf "$HOME/Library/Services/$WORKFLOW_NAME"
    echo -e "  ${GREEN}OK${NC} - removed right-click Quick Action"
    removed_any=true
else
    echo -e "  ${YELLOW}--${NC} Quick Action not found (already removed)"
fi

# Remove the Desktop command file
if [ -f "$HOME/Desktop/$COMMAND_NAME" ]; then
    read -p "Also remove '$COMMAND_NAME' from your Desktop? [Y/n]: " yn
    yn=${yn:-Y}
    if [[ "$yn" =~ ^[Yy]$ ]]; then
        rm "$HOME/Desktop/$COMMAND_NAME"
        echo -e "  ${GREEN}OK${NC} - removed Desktop script"
        removed_any=true
    fi
else
    echo -e "  ${YELLOW}--${NC} Desktop script not found (already removed)"
fi

# Refresh services
echo ""
echo "Refreshing macOS Services menu..."
/System/Library/CoreServices/pbs -flush >/dev/null 2>&1 || true
/System/Library/CoreServices/pbs -update >/dev/null 2>&1 || true
echo -e "  ${GREEN}OK${NC}"

echo ""
if [ "$removed_any" = true ]; then
    echo "Uninstalled."
else
    echo "Nothing to uninstall."
fi
echo ""
echo "Note: This does NOT undo the actual fix - the iphlpapi.dll already inside"
echo "CrossOver stays there. If you want CrossOver's original dll back, you'd"
echo "need to reinstall CrossOver."
echo ""
