@echo off
title Install WiFi Share Card
setlocal

rem WiFi Share Card installer for Windows (v1.3)
rem Downloads the tool files from GitHub Pages into %LOCALAPPDATA%\WiFiShareCard
rem and creates Desktop and Start Menu shortcuts. No admin rights needed.

set "BASE=https://aamirtechs.github.io/wifi-share-card"
set "DIR=%LOCALAPPDATA%\WiFiShareCard"

echo.
echo Installing WiFi Share Card...
echo Folder: %DIR%
echo.

if not exist "%DIR%" mkdir "%DIR%"
if not exist "%DIR%" (
  echo Could not create the install folder. Installation stopped.
  pause
  exit /b 1
)

echo Downloading files from %BASE% ...
curl -fL "%BASE%/index.html" -o "%DIR%\index.html"
if not exist "%DIR%\index.html" (
  echo Download failed. Check your internet connection and try again.
  pause
  exit /b 1
)
curl -fL "%BASE%/Show-My-WiFi.ps1" -o "%DIR%\Show-My-WiFi.ps1"
curl -fL "%BASE%/Show-My-WiFi.bat" -o "%DIR%\Show-My-WiFi.bat"
curl -fL "%BASE%/favicon.svg" -o "%DIR%\favicon.svg"
curl -fL "%BASE%/site.webmanifest" -o "%DIR%\site.webmanifest"

if not exist "%DIR%\Show-My-WiFi.bat" (
  echo The launcher files did not download fully. Try again.
  pause
  exit /b 1
)

echo Creating shortcuts...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ws = New-Object -ComObject WScript.Shell; $desk = [Environment]::GetFolderPath('Desktop'); $s = $ws.CreateShortcut($desk + '\WiFi Share Card.lnk'); $s.TargetPath = '%DIR%\Show-My-WiFi.bat'; $s.WorkingDirectory = '%DIR%'; $s.Description = 'Show a QR code for my connected WiFi'; $s.Save(); $prog = [Environment]::GetFolderPath('Programs'); $s2 = $ws.CreateShortcut($prog + '\WiFi Share Card.lnk'); $s2.TargetPath = '%DIR%\Show-My-WiFi.bat'; $s2.WorkingDirectory = '%DIR%'; $s2.Description = 'Show a QR code for my connected WiFi'; $s2.Save()"

> "%DIR%\Uninstall-WiFiShareCard.bat" echo @echo off
>> "%DIR%\Uninstall-WiFiShareCard.bat" echo title Uninstall WiFi Share Card
>> "%DIR%\Uninstall-WiFiShareCard.bat" echo del "%%USERPROFILE%%\Desktop\WiFi Share Card.lnk" 2^>nul
>> "%DIR%\Uninstall-WiFiShareCard.bat" echo del "%%APPDATA%%\Microsoft\Windows\Start Menu\Programs\WiFi Share Card.lnk" 2^>nul
>> "%DIR%\Uninstall-WiFiShareCard.bat" echo echo Shortcuts removed. Deleting the app folder...
>> "%DIR%\Uninstall-WiFiShareCard.bat" echo start "" /min cmd /c "ping -n 2 127.0.0.1 ^>nul ^& rmdir /s /q "%%LOCALAPPDATA%%\WiFiShareCard""
>> "%DIR%\Uninstall-WiFiShareCard.bat" echo echo WiFi Share Card uninstalled.
>> "%DIR%\Uninstall-WiFiShareCard.bat" echo pause

echo.
echo Installed. Look for "WiFi Share Card" on your Desktop and in the Start Menu.
echo Clicking it detects your connected WiFi and opens your QR card.
echo To uninstall later, run Uninstall-WiFiShareCard.bat inside the install folder.
echo.
set /p RUNNOW="Create your first WiFi card now? (Y/N): "
if /i "%RUNNOW%"=="Y" call "%DIR%\Show-My-WiFi.bat"
echo.
pause
endlocal
