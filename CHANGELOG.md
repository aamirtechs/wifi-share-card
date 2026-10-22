# Changelog

## v1.1.0, 2026-10-22

- Fix for "card does not show my connected WiFi": explained in the card itself that browsers block web pages from reading WiFi name and password, so the page alone will always start empty
- New Windows launcher behaviour: creates My-WiFi-Card.html with the detected WiFi injected into the file and opens that file, instead of relying on URL parameters. Same injection method added to the Mac and Linux launchers. Launchers download the card from the live site if the HTML is missing next to them
- Card now loads details from injected config first, then URL query params, then URL hash params
- Added in-card instructions to find the WiFi password on Windows without any script (Settings on Windows 11, netsh on any Windows)
- Troubleshooting added to the Windows launcher: extract the zip first, check you are connected, manual fallback


## v1.0.0, 2026-10-22

- Initial release: printable WiFi share card with QR code, WiFi name and password
- Single-file offline HTML with embedded QR library (standard WIFI QR format, correct special character escaping)
- Print card, download card PNG, download QR PNG, copy details
- WPA / WPA2 / WPA3, WEP, open and hidden network support
- Windows auto-detect launcher (`Show-My-WiFi.bat` and `.ps1`, using `netsh`)
- macOS launcher (`networksetup` plus Keychain) and Linux launcher (`nmcli`)
- Tests: 9/9 HTML checks and 6/6 QR payload tests passed
