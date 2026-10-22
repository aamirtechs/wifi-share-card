#!/bin/bash
# WiFi Share Card installer for Linux (v1.3)
# Downloads the tool files from GitHub Pages into ~/.local/share/wifi-share-card
# and adds a "WiFi Share Card" app entry (and a Desktop shortcut when possible).
set -e

BASE="${WIFI_SHARE_CARD_BASE:-https://aamirtechs.github.io/wifi-share-card}"
DIR="$HOME/.local/share/wifi-share-card"
APPS="$HOME/.local/share/applications"

echo "Installing WiFi Share Card..."
echo "Folder: $DIR"
mkdir -p "$DIR" "$APPS"

echo "Downloading files from $BASE ..."
curl -fL "$BASE/index.html" -o "$DIR/index.html"
curl -fL "$BASE/show-my-wifi-linux.sh" -o "$DIR/show-my-wifi-linux.sh"
curl -fL "$BASE/favicon.svg" -o "$DIR/favicon.svg" || true
chmod +x "$DIR/show-my-wifi-linux.sh"

cat > "$APPS/wifi-share-card.desktop" << EOF
[Desktop Entry]
Type=Application
Name=WiFi Share Card
Comment=Show a QR code for my connected WiFi
Exec=bash "$DIR/show-my-wifi-linux.sh"
Icon=$DIR/favicon.svg
Terminal=true
Categories=Utility;Network;
EOF

if [ -d "$HOME/Desktop" ]; then
  cp "$APPS/wifi-share-card.desktop" "$HOME/Desktop/wifi-share-card.desktop"
  chmod +x "$HOME/Desktop/wifi-share-card.desktop"
  echo "Desktop shortcut created."
fi

cat > "$DIR/uninstall-linux.sh" << 'EOF'
#!/bin/bash
rm -f "$HOME/.local/share/applications/wifi-share-card.desktop"
rm -f "$HOME/Desktop/wifi-share-card.desktop"
cd "$HOME"
rm -rf "$HOME/.local/share/wifi-share-card"
echo "WiFi Share Card uninstalled."
EOF
chmod +x "$DIR/uninstall-linux.sh"

echo ""
echo "Installed. Open 'WiFi Share Card' from your apps menu or Desktop,"
echo "or run: bash \"$DIR/show-my-wifi-linux.sh\""
echo "It detects your connected WiFi and opens your QR card."
echo "Uninstall any time with: bash \"$DIR/uninstall-linux.sh\""
