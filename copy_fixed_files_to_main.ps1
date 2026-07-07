# Copy all fixed files from error correct folder to main website
$sourceDir = "c:\Users\Shree\Desktop\gautam website 9\website product name and error correct"
$destDir = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net"

$htmlFiles = Get-ChildItem -Path $sourceDir -Filter "*.html" -Recurse -File
$totalFiles = $htmlFiles.Count
$copiedCount = 0
$errorCount = 0

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "COPYING FIXED FILES TO MAIN WEBSITE" -ForegroundColor Cyan
Write-Host "Total files to copy: $totalFiles" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

foreach ($file in $htmlFiles) {
    try {
        # Calculate relative path from source
        $relativePath = $file.FullName.Substring($sourceDir.Length + 1)
        $destPath = Join-Path $destDir $relativePath
        
        # Create destination directory if it doesn't exist
        $destFolder = Split-Path -Parent $destPath
        if (!(Test-Path $destFolder)) {
            New-Item -ItemType Directory -Path $destFolder -Force | Out-Null
        }
        
        # Copy the file
        Copy-Item -Path $file.FullName -Destination $destPath -Force
        $copiedCount++
        Write-Host "COPIED: $relativePath" -ForegroundColor Green
    }
    catch {
        $errorCount++
        Write-Host "ERROR copying $($file.FullName): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "COPY COMPLETE" -ForegroundColor Green
Write-Host "Files copied: $copiedCount" -ForegroundColor Green
Write-Host "Errors: $errorCount" -ForegroundColor $(if ($errorCount -gt 0) { "Red" } else { "Green" })
Write-Host "========================================" -ForegroundColor Cyan
