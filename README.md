# WiFi Share Card

[![GitHub stars](https://img.shields.io/github/stars/aamirtechs/wifi-share-card?style=social)](https://github.com/aamirtechs/wifi-share-card/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/aamirtechs/wifi-share-card?style=social)](https://github.com/aamirtechs/wifi-share-card/network/members)
[![GitHub issues](https://img.shields.io/github/issues/aamirtechs/wifi-share-card)](https://github.com/aamirtechs/wifi-share-card/issues)
[![License: MIT](https://img.shields.io/badge/License-MIT-gold.svg)](LICENSE)

**Share the WiFi your laptop is connected to with your phone, or with guests, using a QR code card. Scan, tap Join or Connect, done. No typing a long password.**

Live demo: https://aamirtechs.github.io/wifi-share-card/

Just like the WiFi share feature built into Android and iPhone, but on a computer.

> Important: A web page on its own cannot read your connected WiFi. Browsers block every website from seeing your WiFi name and password, for security. Opening the HTML or the live demo alone will show an empty form, that is expected. The launchers in this repo are what read your WiFi on your own computer: on Windows, download the files, extract them, then double-click `Show-My-WiFi.bat`. It creates `My-WiFi-Card.html` with your connected WiFi already filled in and opens that file (v1.1 behaviour, no URL parameters needed). It is a single self-contained HTML file with launchers that auto-detect your current network on Windows, macOS and Linux. No build step, no server, no account, no paid APIs. Everything runs locally on your own device.

## The problem

Phones can share WiFi with a QR code in two taps. Laptops usually cannot. So you end up reading a long password out loud, typing it wrong on a small phone keyboard, or hunting for the sticker on the router.

WiFi Share Card fixes that gap: your laptop shows the QR code, your phone scans it and joins.

## Features

- **Printable share card.** QR code, WiFi name and password in one clean navy and gold card you can show on screen, save as PNG, or print for home, office, shop or guests.
- **Live QR generation.** Standard `WIFI:T:WPA;S:<name>;P:<password>;;` format supported by iPhone Camera and Android. Updates as you type.
- **Correct escaping.** Special characters in network names and passwords (`\ ; , " :`) are escaped to the WiFi QR standard, tested with symbol heavy passwords.
- **Windows auto-detect.** `Show-My-WiFi.bat` / `.ps1` reads the connected SSID and its saved password using the built-in `netsh` command, creates `My-WiFi-Card.html` already filled in, and opens it.
- **macOS and Linux launchers.** Shell scripts using `networksetup` plus Keychain on Mac, and `nmcli` on Linux.
- **Flexible networks.** WPA / WPA2 / WPA3, WEP, open networks, and hidden SSIDs. Show or hide the password on the card.
- **Downloads.** Full card as PNG, QR code only as PNG, or copy the details to clipboard.
- **100% local and offline.** The QR library is embedded in the HTML file. No network calls, no analytics, your password never leaves your device.

## How to run

### Option A, fastest on Windows

1. Connect your laptop to the WiFi you want to share.
2. Download or clone this repository and keep all files in the same folder.
3. Extract the files first if you downloaded a zip, then double-click `Show-My-WiFi.bat`.
4. It creates `My-WiFi-Card.html` and your browser opens that card with the QR, name and password already filled in.
5. Point your phone camera at the QR and tap Join / Connect.

### Option B, manual, any computer

1. Open `index.html` in any modern browser.
2. Type the card title, WiFi name (SSID) and password.
3. Scan the QR, print it, or download it as a PNG.

### macOS / Linux

```bash
# macOS
bash show-my-wifi-mac.sh

# Linux (NetworkManager)
bash show-my-wifi-linux.sh
```

macOS may ask for Keychain permission to read the saved WiFi password. That prompt comes from your own Mac, for your own network.

## How to connect on a phone

- **iPhone:** Open Camera, point at the QR, tap the WiFi prompt, tap Join.
- **Android:** Open Camera, or Settings, WiFi, tap the QR scan icon, scan, tap Connect.
- **If scanning fails:** Type the name and password shown on the card.

## Privacy and safety

- The QR code contains your WiFi password so a phone can join automatically. Treat a saved or printed card like the password itself. Do not post it publicly.
- This tool makes no network calls and sends nothing anywhere.
- The auto-detect scripts only read the WiFi profile already saved on your own computer, using built-in system commands.
- Enterprise WiFi with a login page, 802.1X or a certificate usually cannot be shared with a simple password QR. That is a limit of that network type, not this tool.

## Files

| File | Purpose |
|---|---|
| `index.html` | The main tool, single file, offline |
| `Show-My-WiFi.bat` | Windows one-click launcher |
| `Show-My-WiFi.ps1` | Windows auto-detect using `netsh` |
| `show-my-wifi-mac.sh` | macOS auto-detect |
| `show-my-wifi-linux.sh` | Linux auto-detect using `nmcli` |

## SEO and AI discoverability

The GitHub Pages site is built to be found by search engines and understood by AI assistants: keyword rich title and meta description, canonical URL, Open Graph and Twitter cards with a dedicated share image, JSON-LD structured data (WebApplication, HowTo, FAQPage matching the visible FAQ), semantic content sections (how it works, use cases, the WiFi QR format, FAQ), a robots.txt that welcomes search and AI crawlers (GPTBot, ClaudeBot, PerplexityBot, Google-Extended and others), sitemap.xml, llms.txt, a favicon and a web app manifest. Honest note: this makes the page fully eligible for indexing and citation. Rankings still depend on indexing time and links from other sites.

## License

MIT, see [LICENSE](LICENSE).
