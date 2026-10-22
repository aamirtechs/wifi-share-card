# WiFi Share Card - Windows auto-detect launcher
# Reads the WiFi your laptop is connected to right now (name + saved password)
# and opens wifi-share-card-v1.0.0.html already filled in, with a scannable QR.
# Everything stays on your own laptop. Nothing is sent anywhere.
# Usage: Right-click > Run with PowerShell, or double-click Show-My-WiFi.bat

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "WiFi Share Card - Auto-detect" -ForegroundColor Cyan
Write-Host "-----------------------------" -ForegroundColor Cyan

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
        Write-Host "It may be an enterprise / office network, or the profile may not store the key." -ForegroundColor Yellow
        Write-Host "The card will open anyway, you can type the password there." -ForegroundColor Yellow
    } else {
        Write-Host "Password found : yes (hidden here, it will show on your private card)"
    }

    # 3. Find the HTML card file next to this script
    $candidates = @(
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
        throw "Could not find the WiFi card HTML file next to this script. Keep Show-My-WiFi.ps1 and wifi-share-card-v1.0.0.html in the same folder."
    }

    # 4. Build a file URL with the details as query parameters and open it
    $fileUrl = ([System.Uri]$htmlPath).AbsoluteUri
    $query = "?title=" + [uri]::EscapeDataString("My WiFi") +
             "&ssid=" + [uri]::EscapeDataString($ssid) +
             "&password=" + [uri]::EscapeDataString($password) +
             "&auth=" + [uri]::EscapeDataString($auth)

    $url = $fileUrl + $query
    Write-Host ""
    Write-Host "Opening your WiFi card in your browser..." -ForegroundColor Green
    Write-Host "Scan the QR code there with your phone camera to connect."
    Write-Host ""
    Start-Process $url
}
catch {
    Write-Host ""
    Write-Host "Problem: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Tip: You can still open wifi-share-card-v1.0.0.html manually and type the WiFi name and password."
    Write-Host ""
    Pause
}
