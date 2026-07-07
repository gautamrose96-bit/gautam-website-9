# Fix trailing spaces in folder paths across all HTML files
$rootDir = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net"
$errorLog = "c:\Users\Shree\Desktop\gautam website 9\fix_trailing_spaces_errors.txt"
$fixedCount = 0
$errorCount = 0

# Clear error log
"" | Out-File -FilePath $errorLog -Encoding UTF8

Write-Host "Starting fix for trailing spaces in folder paths..." -ForegroundColor Green
Write-Host "Root directory: $rootDir" -ForegroundColor Cyan

# Get all HTML files within www.gautamrose.net only
$htmlFiles = Get-ChildItem -Path "$rootDir\*.html" -Recurse -File
$totalFiles = $htmlFiles.Count
Write-Host "Found $totalFiles HTML files to process" -ForegroundColor Cyan

foreach ($file in $htmlFiles) {
    $content = $file.FullName
    try {
        $fileContent = Get-Content -Path $file -Raw -Encoding UTF8
        
        # Fix trailing spaces in folder paths using regex
        # Pattern matches: folder name followed by space and slash
        $originalContent = $fileContent
        
        # Fix category paths
        $fileContent = $fileContent -replace 'category/([a-zA-Z0-9 ]+) /', 'category/$1/'
        # Fix product paths
        $fileContent = $fileContent -replace 'product/([a-zA-Z0-9 ]+)/([a-zA-Z0-9 ]+) /', 'product/$1/$2/'
        # Fix blog paths
        $fileContent = $fileContent -replace 'blog/([a-zA-Z0-9 ]+) /', 'blog/$1/'
        
        # Only write if changed
        if ($fileContent -ne $originalContent) {
            $fileContent | Out-File -FilePath $file -Encoding UTF8
            $fixedCount++
            Write-Host "Fixed: $($file.FullName.Substring($rootDir.Length))" -ForegroundColor Yellow
        }
    }
    catch {
        $errorMsg = "Error processing $($file.FullName): $($_.Exception.Message)"
        $errorMsg | Out-File -FilePath $errorLog -Append -Encoding UTF8
        $errorCount++
        Write-Host "ERROR: $($file.FullName)" -ForegroundColor Red
    }
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "FIX COMPLETE" -ForegroundColor Green
Write-Host "Total files processed: $totalFiles" -ForegroundColor Cyan
Write-Host "Files fixed: $fixedCount" -ForegroundColor Green
Write-Host "Errors: $errorCount" -ForegroundColor $(if ($errorCount -gt 0) { "Red" } else { "Green" })
Write-Host "Error log: $errorLog" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Green
