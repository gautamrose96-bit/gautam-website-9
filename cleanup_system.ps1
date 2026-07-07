# System Cleanup Script - Frees up memory and CPU
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "System Cleanup - Speed Up Your Laptop" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Stop heavy processes that aren't needed
$processesToStop = @(
    "Grammarly.Desktop",
    "Grammarly",
    "chrome",  # Will close Chrome - save work first!
    "ollama",
    "ollama app"
)

Write-Host "`nStep 1: Stopping heavy background processes..." -ForegroundColor Yellow

foreach ($procName in $processesToStop) {
    $processes = Get-Process -Name $procName -ErrorAction SilentlyContinue
    if ($processes) {
        Write-Host "  Stopping $procName..." -ForegroundColor Red
        $processes | Stop-Process -Force
    }
}

# Clear temp files
Write-Host "`nStep 2: Clearing temporary files..." -ForegroundColor Yellow
$tempPaths = @(
    $env:TEMP,
    "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
    "$env:LOCALAPPDATA\Temp"
)

foreach ($path in $tempPaths) {
    if (Test-Path $path) {
        $items = Get-ChildItem -Path $path -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First 100
        $count = $items.Count
        if ($count -gt 0) {
            Write-Host "  Clearing $count temp files from $path..." -ForegroundColor Green
            $items | Remove-Item -Force -ErrorAction SilentlyContinue
        }
    }
}

# Clear DNS cache
Write-Host "`nStep 3: Flushing DNS cache..." -ForegroundColor Yellow
ipconfig /flushdns | Out-Null
Write-Host "  DNS cache cleared" -ForegroundColor Green

# Release and renew IP (optional, might disconnect briefly)
# Write-Host "`nStep 4: Renewing network connection..." -ForegroundColor Yellow
# ipconfig /release | Out-Null
# ipconfig /renew | Out-Null
# Write-Host "  Network renewed" -ForegroundColor Green

# Check disk space
Write-Host "`nStep 4: Checking disk space..." -ForegroundColor Yellow
$disks = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"
foreach ($disk in $disks) {
    $freeSpaceGB = [math]::Round($disk.FreeSpace / 1GB, 2)
    $totalSpaceGB = [math]::Round($disk.Size / 1GB, 2)
    $percentFree = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 1)
    Write-Host "  Drive $($disk.DeviceID) - $freeSpaceGB GB free of $totalSpaceGB GB ($percentFree% free)" -ForegroundColor $(if ($percentFree -lt 10) { "Red" } else { "Green" })
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "Cleanup Complete!" -ForegroundColor Green
Write-Host "Your system should be faster now." -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "`nTip: To start a light website server, run:" -ForegroundColor Yellow
Write-Host "  start_local_server.ps1" -ForegroundColor White
