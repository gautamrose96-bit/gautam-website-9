# Free Up Disk Space - Critical for C: drive
Write-Host "==========================================" -ForegroundColor Red
Write-Host "FREEING UP DISK SPACE - C: Drive Critical!" -ForegroundColor Red
Write-Host "==========================================" -ForegroundColor Red

$totalFreed = 0

# 1. Empty Recycle Bin
Write-Host "`nStep 1: Emptying Recycle Bin..." -ForegroundColor Yellow
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Host "  Recycle Bin emptied" -ForegroundColor Green

# 2. Clear Windows Update cache
Write-Host "`nStep 2: Clearing Windows Update cache..." -ForegroundColor Yellow
$windowsUpdatePath = "C:\Windows\SoftwareDistribution\Download"
if (Test-Path $windowsUpdatePath) {
    $size = (Get-ChildItem -Path $windowsUpdatePath -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    if ($size -gt 0) {
        $sizeMB = [math]::Round($size / 1MB, 2)
        Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$windowsUpdatePath\*" -Recurse -Force -ErrorAction SilentlyContinue
        Start-Service wuauserv -ErrorAction SilentlyContinue
        Write-Host "  Freed ~$sizeMB MB from Windows Update cache" -ForegroundColor Green
        $totalFreed += $sizeMB
    }
}

# 3. Clear Prefetch
Write-Host "`nStep 3: Clearing Prefetch folder..." -ForegroundColor Yellow
$prefetchPath = "C:\Windows\Prefetch"
if (Test-Path $prefetchPath) {
    $items = Get-ChildItem -Path $prefetchPath -File -ErrorAction SilentlyContinue | Where-Object { $_.CreationTime -lt (Get-Date).AddDays(-7) }
    $count = $items.Count
    if ($count -gt 0) {
        $items | Remove-Item -Force -ErrorAction SilentlyContinue
        Write-Host "  Cleared $count old prefetch files" -ForegroundColor Green
    }
}

# 4. Clear Crash Dumps
Write-Host "`nStep 4: Clearing crash dumps and logs..." -ForegroundColor Yellow
$crashPaths = @(
    "C:\Windows\Minidump",
    "C:\Windows\LiveKernelReports",
    "C:\ProgramData\Microsoft\Windows\WER"
)
foreach ($path in $crashPaths) {
    if (Test-Path $path) {
        $items = Get-ChildItem -Path $path -Recurse -ErrorAction SilentlyContinue
        $size = ($items | Measure-Object -Property Length -Sum).Sum
        if ($size -gt 0) {
            $sizeMB = [math]::Round($size / 1MB, 2)
            $items | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
            Write-Host "  Freed $sizeMB MB from $([System.IO.Path]::GetFileName($path))" -ForegroundColor Green
            $totalFreed += $sizeMB
        }
    }
}

# 5. Clear Browser caches
Write-Host "`nStep 5: Clearing browser caches..." -ForegroundColor Yellow
$chromeCache = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"
if (Test-Path $chromeCache) {
    $size = (Get-ChildItem -Path $chromeCache -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    if ($size -gt 0) {
        $sizeMB = [math]::Round($size / 1MB, 2)
        Remove-Item -Path "$chromeCache\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  Freed ~$sizeMB MB from Chrome cache" -ForegroundColor Green
        $totalFreed += $sizeMB
    }
}

# 6. Run Disk Cleanup (cleanmgr) silently
Write-Host "`nStep 6: Running Windows Disk Cleanup..." -ForegroundColor Yellow
Write-Host "  (This may take a few minutes...)" -ForegroundColor Yellow
Start-Process -FilePath "cleanmgr" -ArgumentList "/sagerun:1" -WindowStyle Hidden -Wait

# 7. Check disk space again
Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "Disk Space After Cleanup:" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
$disk = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='C:'"
$freeSpaceGB = [math]::Round($disk.FreeSpace / 1GB, 2)
$totalSpaceGB = [math]::Round($disk.Size / 1GB, 2)
$percentFree = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 1)

Write-Host "C: Drive - $freeSpaceGB GB free of $totalSpaceGB GB ($percentFree% free)" -ForegroundColor $(if ($percentFree -lt 10) { "Red" } else { "Green" })
Write-Host "`nApproximate space freed: $totalFreed MB" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan

if ($percentFree -lt 10) {
    Write-Host "`n⚠️ WARNING: C: drive is still critically low!" -ForegroundColor Red
    Write-Host "Recommendations:" -ForegroundColor Yellow
    Write-Host "  1. Uninstall unused programs" -ForegroundColor White
    Write-Host "  2. Move large files (movies, photos) to D: or F: drive" -ForegroundColor White
    Write-Host "  3. Use TreeSize Free to find what's taking space" -ForegroundColor White
    Write-Host "  4. Consider upgrading to larger SSD" -ForegroundColor White
}
