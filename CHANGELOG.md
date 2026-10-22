# Changelog

## v1.3.0, 2026-10-22

- Install from GitHub Pages: the site now has a Download and Install section with one file installers served directly from Pages
- Windows installer (Install-WiFiShareCard.bat): downloads the tool into %LOCALAPPDATA% WiFiShareCard, creates Desktop and Start Menu shortcuts via PowerShell, writes an uninstaller, no admin rights needed
- macOS installer (install-mac.sh): installs into ~/Applications/WiFiShareCard, creates a double click Desktop .command launcher and an uninstaller
- Linux installer (install-linux.sh): installs into ~/.local/share/wifi-share-card, adds an apps menu .desktop entry plus a Desktop shortcut and an uninstaller
- Linux installer verified end to end twice: in a sandbox home against local files, and from the real GitHub Pages URL after publishing (files, app entry and uninstaller all created correctly)
- Full source zip linked from the site and READMEs (GitHub generated archive of main)
- llms.txt documents the installers for AI assistants


## v1.2.0, 2026-10-22

- Premium UI and UX redesign: Sora plus Plus Jakarta Sans, navy and gold hero with gradient mesh, glassmorphism quick start panel, step numbered panels, sticky card preview on desktop, refined shadows, focus rings and hover states
- Dark mode toggle for the page, remembered on the device (the share card itself stays navy)
- UX upgrades: password strength meter, password field disabled for open networks, toast confirmations for copy and downloads, smoother responsive layout, accessibility pass (aria labels, live status region, semantic landmarks)
- SEO: keyword rich title and meta description, canonical, robots meta, Open Graph and Twitter cards with dedicated og-image.svg, favicon.svg and site.webmanifest
- Structured data for search and AI: JSON-LD WebApplication, HowTo and FAQPage, with the FAQ also visible on the page word for word
- New crawl and AI files at the site root: robots.txt (welcomes search and AI crawlers), sitemap.xml, llms.txt, .nojekyll
- New visible content sections for search: how WiFi QR sharing works, use cases (home, office and shop, rentals), and the standard WiFi QR format explained
- Launchers now prefer the v1.2.0 HTML file. No change to QR generation, payload format or the My-WiFi-Card injection method


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
