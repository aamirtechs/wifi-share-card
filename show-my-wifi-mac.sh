#!/bin/bash
# WiFi Share Card - macOS auto-detect launcher
# Reads the connected WiFi name, tries to read its password from your Keychain
# (macOS will ask your permission), then opens the card filled in.
# Everything stays on your own Mac.
set -e
cd "$(dirname "$0")"

echo "WiFi Share Card - Auto-detect (Mac)"
echo "-----------------------------------"

# Find WiFi device (usually en0)
DEVICE=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $2}' | head -n 1)
DEVICE=${DEVICE:-en0}

SSID=$(networksetup -getairportnetwork "$DEVICE" | sed 's/Current Wi-Fi Network: //')
if [ -z "$SSID" ] || echo "$SSID" | grep -q "not associated"; then
  echo "No connected WiFi found. Connect first, then run again."
  exit 1
fi
echo "Connected WiFi : $SSID"

PASSWORD=""
# This may pop up a Keychain permission dialog, that is expected on your own Mac
PASSWORD=$(security find-generic-password -D "AirPort network password" -a "$SSID" -gw 2>/dev/null || true)
if [ -z "$PASSWORD" ]; then
  echo "Note: Could not read password from Keychain. The card will open, type the password there if needed."
fi

HTML=""
for f in wifi-share-card-v1.0.0.html wifi-share-card.html index.html; do
  if [ -f "$f" ]; then HTML="$f"; break; fi
done
if [ -z "$HTML" ]; then echo "HTML card not found in this folder."; exit 1; fi

ENC_SSID=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))' "$SSID")
ENC_PASS=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))' "$PASSWORD")
ABS_PATH="$(pwd)/$HTML"

open "file://$ABS_PATH?title=My%20WiFi&ssid=$ENC_SSID&password=$ENC_PASS&auth=WPA"
echo "Opening your WiFi card in your browser. Scan the QR with your phone."
