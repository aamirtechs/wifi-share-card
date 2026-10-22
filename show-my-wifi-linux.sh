#!/bin/bash
# WiFi Share Card - Linux auto-detect launcher (NetworkManager / nmcli)
# Reads the connected WiFi name and its saved password, then opens the card.
# Everything stays on your own laptop.
set -e
cd "$(dirname "$0")"

echo "WiFi Share Card - Auto-detect (Linux)"
echo "-------------------------------------"

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
AUTH="WPA"
if [ -z "$PASSWORD" ]; then
  echo "Note: No password returned. It may be an open network, or you may need to type it on the card."
fi

HTML=""
for f in wifi-share-card-v1.0.0.html wifi-share-card.html index.html; do
  if [ -f "$f" ]; then HTML="$f"; break; fi
done
if [ -z "$HTML" ]; then echo "HTML card not found in this folder."; exit 1; fi

ENC_SSID=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))' "$SSID")
ENC_PASS=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))' "$PASSWORD")
ABS_PATH="$(pwd)/$HTML"

xdg-open "file://$ABS_PATH?title=My%20WiFi&ssid=$ENC_SSID&password=$ENC_PASS&auth=$AUTH"
echo "Opening your WiFi card in your browser. Scan the QR with your phone."
