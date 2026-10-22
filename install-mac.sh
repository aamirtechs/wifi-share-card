#!/bin/bash
# WiFi Share Card installer for macOS (v1.3)
# Downloads the tool files from GitHub Pages into ~/Applications/WiFiShareCard
# and puts a double-clickable "WiFi Share Card.command" on your Desktop.
set -e

BASE="${WIFI_SHARE_CARD_BASE:-https://aamirtechs.github.io/wifi-share-card}"
DIR="$HOME/Applications/WiFiShareCard"

echo "Installing WiFi Share Card..."
echo "Folder: $DIR"
mkdir -p "$DIR"

echo "Downloading files from $BASE ..."
curl -fL "$BASE/index.html" -o "$DIR/index.html"
curl -fL "$BASE/show-my-wifi-mac.sh" -o "$DIR/show-my-wifi-mac.sh"
curl -fL "$BASE/favicon.svg" -o "$DIR/favicon.svg" || true
chmod +x "$DIR/show-my-wifi-mac.sh"

# Desktop launcher (.command files run in Terminal on double click)
LAUNCHER="$HOME/Desktop/WiFi Share Card.command"
if [ -d "$HOME/Desktop" ]; then
  cat > "$LAUNCHER" << EOF
#!/bin/bash
cd "$DIR" && bash show-my-wifi-mac.sh
EOF
  chmod +x "$LAUNCHER"
  echo "Desktop launcher created: WiFi Share Card.command"
else
  LAUNCHER=""
  echo "No Desktop folder found, skipping the desktop launcher."
fi

# Uninstaller
cat > "$DIR/uninstall-mac.sh" << 'EOF'
#!/bin/bash
rm -f "$HOME/Desktop/WiFi Share Card.command"
cd "$HOME"
rm -rf "$HOME/Applications/WiFiShareCard"
echo "WiFi Share Card uninstalled."
EOF
chmod +x "$DIR/uninstall-mac.sh"

echo ""
echo "Installed. Double-click 'WiFi Share Card' on your Desktop,"
echo "or run: bash \"$DIR/show-my-wifi-mac.sh\""
echo "It detects your connected WiFi and opens your QR card."
echo "Uninstall any time with: bash \"$DIR/uninstall-mac.sh\""
