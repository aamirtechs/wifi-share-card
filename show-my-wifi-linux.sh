#!/bin/bash
# WiFi Share Card - Linux auto-detect launcher (NetworkManager / nmcli)
# Reads the connected WiFi name and saved password, creates My-WiFi-Card.html
# filled in, and opens it. Everything stays on your own laptop.
set -e
cd "$(dirname "$0")"

echo "WiFi Share Card - Auto-detect (Linux)"
echo "------------------------------------------"

if ! command -v nmcli >/dev/null 2>&1; then
  echo "nmcli not found. Open the HTML card manually and type your WiFi name and password."
  exit 1
fi

SSID=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes"{print $2; exit}')
if [ -z "$SSID" ]; then
  echo "No connected WiFi found. Connect first, then run again."
  exit 1
fi
echo "Connected WiFi : $SSID"

PASSWORD=$(nmcli -s -g 802-11-wireless-security.psk connection show "$SSID" 2>/dev/null || true)
if [ -z "$PASSWORD" ]; then
  echo "Note: No password returned. It may be an open network, or you may need to type it on the card."
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

xdg-open "My-WiFi-Card.html"
echo "Opening your WiFi card. Scan the QR with your phone. Keep My-WiFi-Card.html private, it contains your password."
