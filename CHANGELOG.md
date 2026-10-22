# Changelog

## v1.0.0, 2026-10-22

- Initial release: printable WiFi share card with QR code, WiFi name and password
- Single-file offline HTML with embedded QR library (standard WIFI QR format, correct special character escaping)
- Print card, download card PNG, download QR PNG, copy details
- WPA / WPA2 / WPA3, WEP, open and hidden network support
- Windows auto-detect launcher (`Show-My-WiFi.bat` and `.ps1`, using `netsh`)
- macOS launcher (`networksetup` plus Keychain) and Linux launcher (`nmcli`)
- Tests: 9/9 HTML checks and 6/6 QR payload tests passed
