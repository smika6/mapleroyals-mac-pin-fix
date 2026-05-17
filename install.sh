#!/bin/bash
# Installs the MapleRoyals pin login fix for macOS / CrossOver.
# Installs a right-click Quick Action and (optionally) a double-click script on the Desktop.

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKFLOW_NAME="Install iphlpapi.dll (MapleRoyals fix).workflow"
COMMAND_NAME="Fix MapleRoyals Pin Login.command"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "=========================================="
echo "  MapleRoyals Pin Login Fix - Installer"
echo "=========================================="
echo ""

# Sanity checks
if [ ! -d "$REPO_DIR/$WORKFLOW_NAME" ]; then
    echo -e "${RED}ERROR:${NC} Can't find '$WORKFLOW_NAME' next to this script."
    echo "Make sure you're running install.sh from inside the unzipped repo folder."
    exit 1
fi

if [ ! -f "$REPO_DIR/$COMMAND_NAME" ]; then
    echo -e "${RED}ERROR:${NC} Can't find '$COMMAND_NAME' next to this script."
    exit 1
fi

if [ ! -d "/Applications/CrossOver.app" ]; then
    echo -e "${YELLOW}WARNING:${NC} CrossOver doesn't appear to be installed at /Applications/CrossOver.app"
    echo "The fix won't work until CrossOver is installed there."
    echo ""
fi

# Install the Quick Action
echo "Installing right-click Quick Action..."
mkdir -p "$HOME/Library/Services"
rm -rf "$HOME/Library/Services/$WORKFLOW_NAME"
cp -R "$REPO_DIR/$WORKFLOW_NAME" "$HOME/Library/Services/"
echo -e "  ${GREEN}OK${NC} - installed to ~/Library/Services/"
echo ""

# Optional: copy command file to Desktop
read -p "Also put the double-click script on your Desktop? [Y/n]: " yn
yn=${yn:-Y}
if [[ "$yn" =~ ^[Yy]$ ]]; then
    cp "$REPO_DIR/$COMMAND_NAME" "$HOME/Desktop/"
    chmod +x "$HOME/Desktop/$COMMAND_NAME"
    echo -e "  ${GREEN}OK${NC} - '$COMMAND_NAME' is on your Desktop"
fi
echo ""

# Refresh Services registry so the menu item shows up immediately
echo "Refreshing macOS Services menu..."
/System/Library/CoreServices/pbs -flush >/dev/null 2>&1 || true
/System/Library/CoreServices/pbs -update >/dev/null 2>&1 || true
echo -e "  ${GREEN}OK${NC}"
echo ""

# Look for the dll: same folder as install.sh first, then ~/Downloads
LOCAL_DLL="$REPO_DIR/iphlpapi.dll"
DOWNLOADS_DLL="$HOME/Downloads/iphlpapi.dll"

if [ -f "$LOCAL_DLL" ]; then
    echo -e "${GREEN}Found iphlpapi.dll next to install.sh${NC} - you're all set!"
    echo ""
elif [ -f "$DOWNLOADS_DLL" ]; then
    echo -e "${YELLOW}Found iphlpapi.dll in ~/Downloads${NC} but not next to install.sh."
    read -p "Move it next to install.sh? [Y/n]: " yn
    yn=${yn:-Y}
    if [[ "$yn" =~ ^[Yy]$ ]]; then
        if mv "$DOWNLOADS_DLL" "$LOCAL_DLL"; then
            echo -e "  ${GREEN}OK${NC} - moved to $LOCAL_DLL"
        else
            echo -e "  ${YELLOW}!!${NC} Move failed - leaving it in Downloads"
        fi
    else
        echo "  OK, leaving it in Downloads. The fix will still work."
    fi
    echo ""
else
    echo -e "${YELLOW}!! ONE MORE STEP !!${NC}"
    echo "You still need the iphlpapi.dll file."
    echo "  1. Download it from: https://tinyurl.com/e633fsau"
    echo "  2. Put it next to install.sh, or in your Downloads folder"
    echo ""
fi

echo "=========================================="
echo "  Done!"
echo "=========================================="
echo ""
echo "How to use it:"
echo "  Right-click MapleRoyals.app in Finder"
echo "  -> Quick Actions (or Services)"
echo "  -> 'Install iphlpapi.dll (MapleRoyals fix)'"
echo ""
echo "If the menu item doesn't show up, log out and back in once."
echo ""
