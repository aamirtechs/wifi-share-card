# WiFi Share Card - Windows auto-detect launcher
# Reads the WiFi your laptop is connected to right now (name + saved password),
# creates My-WiFi-Card.html with those details already filled in, and opens it.
# No web page can read your WiFi by itself, browsers block that for security.
# This local script is what does the reading, using Windows' built-in netsh.
# Everything stays on your own laptop. Nothing is sent anywhere.
# Usage: Extract the zip first, then double-click Show-My-WiFi.bat

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "WiFi Share Card - Auto-detect" -ForegroundColor Cyan
Write-Host "----------------------------------" -ForegroundColor Cyan

try {
    # 1. Find the connected SSID
    $interfaces = netsh wlan show interfaces
    $ssidLine = $interfaces | Select-String -Pattern '^\s*SSID\s*:' | Select-Object -First 1
    if (-not $ssidLine) {
        throw "No connected WiFi found. Connect to a WiFi network first, then run this again."
    }
    $ssid = ($ssidLine.ToString() -split ':', 2)[1].Trim()
    Write-Host "Connected WiFi : $ssid"

    # 2. Read the saved profile to get the password and security type
    $profile = netsh wlan show profile name="$ssid" key=clear
    $keyLine = $profile | Select-String -Pattern 'Key Content\s*:' | Select-Object -First 1
    $authLine = $profile | Select-String -Pattern 'Authentication\s*:' | Select-Object -First 1

    $password = ""
    if ($keyLine) { $password = ($keyLine.ToString() -split ':', 2)[1].Trim() }

    $auth = "WPA"
    if ($authLine) {
        $authText = ($authLine.ToString() -split ':', 2)[1].Trim()
        if ($authText -match 'Open') { $auth = "nopass" }
        elseif ($authText -match 'WEP') { $auth = "WEP" }
        else { $auth = "WPA" }
    }
    if (-not $password -and $auth -ne "nopass") {
        Write-Host "Note: Windows did not return a password for this network." -ForegroundColor Yellow
        Write-Host "It may be an enterprise / office network. The card will open anyway, type the password there." -ForegroundColor Yellow
    } else {
        Write-Host "Password found : yes"
    }

    # 3. Find the card template next to this script, or download it if missing
    $candidates = @(
        "wifi-share-card-v1.2.0.html",
        "wifi-share-card-v1.1.0.html",
        "wifi-share-card-v1.0.0.html",
        "wifi-share-card.html",
        "index.html"
    )
    $htmlPath = $null
    foreach ($name in $candidates) {
        $candidate = Join-Path $PSScriptRoot $name
        if (Test-Path $candidate) { $htmlPath = $candidate; break }
    }
    if (-not $htmlPath) {
        Write-Host "Card file not found next to this script. Downloading it from the live site..."
        $htmlPath = Join-Path $PSScriptRoot "index.html"
        Invoke-WebRequest -UseBasicParsing -Uri "https://aamirtechs.github.io/wifi-share-card/" -OutFile $htmlPath
    }

    # 4. Create a filled copy: My-WiFi-Card.html
    $template = [System.IO.File]::ReadAllText($htmlPath)
    $marker = "window.WIFI_CARD_CONFIG=null;/*__WIFI_CONFIG__*/"
    $outPath = Join-Path $PSScriptRoot "My-WiFi-Card.html"

    if ($template.Contains($marker)) {
        $config = @{
            title    = "My WiFi"
            ssid     = $ssid
            password = $password
            auth     = $auth
        } | ConvertTo-Json -Compress
        $filled = $template.Replace($marker, "window.WIFI_CARD_CONFIG=$config;")
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($outPath, $filled, $utf8NoBom)
        Write-Host ""
        Write-Host "Created My-WiFi-Card.html with your WiFi filled in." -ForegroundColor Green
        Write-Host "That file contains your WiFi password. Keep it private, delete it on a shared computer."
        Write-Host "Opening it now. Scan the QR code with your phone camera to connect."
        Write-Host ""
        Start-Process $outPath
    } else {
        # Older template without the injection marker: fall back to URL parameters
        Write-Host "Note: This card file is the older version, opening it with URL parameters instead." -ForegroundColor Yellow
        $fileUrl = ([System.Uri]$htmlPath).AbsoluteUri
        $query = "?title=" + [uri]::EscapeDataString("My WiFi") +
                 "&ssid=" + [uri]::EscapeDataString($ssid) +
                 "&password=" + [uri]::EscapeDataString($password) +
                 "&auth=" + [uri]::EscapeDataString($auth)
        Start-Process ($fileUrl + $query)
    }
}
catch {
    Write-Host ""
    Write-Host "Problem: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Common fixes:" -ForegroundColor Yellow
    Write-Host "  1. Extract the zip first. Do not run the files from inside the zip."
    Write-Host "  2. Make sure you are connected to WiFi, then try again."
    Write-Host "  3. Or open the card HTML manually and type the WiFi name and password."
    Write-Host "     On Windows 11 you can see the password in Settings, Network and internet, WiFi, your network, View."
    Write-Host ""
    Pause
}
