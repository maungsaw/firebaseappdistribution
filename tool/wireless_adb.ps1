# Wireless ADB helper for Flutter development (Android 11+)
# Usage:
#   .\tool\wireless_adb.ps1
#   .\tool\wireless_adb.ps1 -PairCode 123456 -PairAddress "192.168.1.5:37123" -ConnectAddress "192.168.1.5:41234"
#
# Phone steps:
#   Settings -> Developer options -> Wireless debugging -> ON
#   Tap "Pair device with pairing code" -> copy IP:port + 6-digit code
#   After pair, tap "Wireless debugging" main screen -> note IP address & port for connect

param(
    [string]$PairAddress,
    [string]$PairCode,
    [string]$ConnectAddress
)

$ErrorActionPreference = "Continue"

function Write-Step([string]$Message) {
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Ensure-Adb {
    $adb = Get-Command adb -ErrorAction SilentlyContinue
    if (-not $adb) {
        Write-Host "adb not found in PATH. Install Android platform-tools or scrcpy adb." -ForegroundColor Red
        exit 1
    }
    Write-Host "Using adb: $($adb.Source)"
}

Ensure-Adb

Write-Step "Discovering nearby wireless debugging devices (mDNS)"
adb mdns services

if (-not $PairAddress) {
    $PairAddress = Read-Host "Pair address from phone (example: 192.168.1.5:37123). Leave empty to skip pair"
}

if ($PairAddress -and -not $PairCode) {
    $PairCode = Read-Host "6-digit pairing code from phone"
}

if ($PairAddress -and $PairCode) {
    Write-Step "Pairing with $PairAddress"
    adb pair $PairAddress $PairCode
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Pair failed. Check Wi-Fi, pairing code expiry, and same network." -ForegroundColor Red
    }
}

if (-not $ConnectAddress) {
    $ConnectAddress = Read-Host "Connect address from Wireless debugging screen (example: 192.168.1.5:41234)"
}

if ($ConnectAddress) {
    Write-Step "Connecting to $ConnectAddress"
    adb connect $ConnectAddress
    Start-Sleep -Seconds 2
}

Write-Step "Connected devices"
adb devices -l

Write-Step "Flutter devices"
flutter devices

Write-Host "`nDone. Run app with:" -ForegroundColor Green
$deviceLine = (adb devices | Select-String "device$" | Select-Object -First 1)
if ($deviceLine) {
    $serial = ($deviceLine -split "\s+")[0]
    Write-Host "  flutter run -d $serial"
} else {
    Write-Host "  flutter run -d <device_id>"
    Write-Host "Tips:" -ForegroundColor Yellow
    Write-Host "  - Phone and PC must use the same Wi-Fi"
    Write-Host "  - Keep Wireless debugging ON on phone"
    Write-Host "  - Xiaomi/Huawei: enable USB debugging (Security settings) + Install via USB"
    Write-Host "  - Re-run this script if connection drops"
}
