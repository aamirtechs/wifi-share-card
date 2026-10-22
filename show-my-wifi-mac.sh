#!/bin/bash
# WiFi Share Card - macOS auto-detect launcher
# Reads the connected WiFi name, tries to read its password from your Keychain
# (macOS will ask your permission), creates My-WiFi-Card.html filled in, opens it.
# Everything stays on your own Mac.
set -e
cd "$(dirname "$0")"

echo "WiFi Share Card - Auto-detect (Mac)"
echo "----------------------------------------"

DEVICE=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $2}' | head -n 1)
DEVICE=${DEVICE:-en0}

SSID=$(networksetup -getairportnetwork "$DEVICE" | sed 's/Current Wi-Fi Network: //')
if [ -z "$SSID" ] || echo "$SSID" | grep -q "not associated"; then
  echo "No connected WiFi found. Connect first, then run again."
  exit 1
fi
echo "Connected WiFi : $SSID"

PASSWORD=$(security find-generic-password -D "AirPort network password" -a "$SSID" -gw 2>/dev/null || true)
if [ -z "$PASSWORD" ]; then
  echo "Note: Could not read password from Keychain. The card will open, type the password there if needed."
fi

HTML=""
for f in wifi-share-card-v1.2.0.html wifi-share-card-v1.1.0.html wifi-share-card-v1.0.0.html wifi-share-card.html index.html; do
  if [ -f "$f" ]; then HTML="$f"; break; fi
done
if [ -z "$HTML" ]; then
  echo "Card file not found. Downloading it from the live site..."
  curl -sL -o index.html "https://aamirtechs.github.io/wifi-share-card/"
  HTML="index.html"
fi

SSID="$SSID" PASSWORD="$PASSWORD" HTML="$HTML" python3 - << 'PYEOF'
import json, os, pathlib
ssid = os.environ.get("SSID","")
password = os.environ.get("PASSWORD","")
html_path = pathlib.Path(os.environ["HTML"])
template = html_path.read_text(encoding="utf-8")
marker = "window.WIFI_CARD_CONFIG=null;/*__WIFI_CONFIG__*/"
config = json.dumps({"title":"My WiFi","ssid":ssid,"password":password,"auth":"WPA"})
if marker in template:
    filled = template.replace(marker, f"window.WIFI_CARD_CONFIG={config};")
    pathlib.Path("My-WiFi-Card.html").write_text(filled, encoding="utf-8")
    print("Created My-WiFi-Card.html with your WiFi filled in.")
else:
    pathlib.Path("My-WiFi-Card.html").write_text(template, encoding="utf-8")
    print("Older card version: opening template, you may need to type the password.")
PYEOF

open "My-WiFi-Card.html"
echo "Opening your WiFi card. Scan the QR with your phone. Keep My-WiFi-Card.html private, it contains your password."
