# Comprehensive Fix Script for Error Correct Folder
# This script fixes all Ayurveda/Patanjali references in all HTML files

$rootDir = "c:\Users\Shree\Desktop\gautam website 9\website product name and error correct"
$mainSiteDir = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net"

# Get all HTML files
$htmlFiles = Get-ChildItem -Path $rootDir -Filter "*.html" -Recurse -File
$totalFiles = $htmlFiles.Count
$fixedCount = 0
$errorCount = 0

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "FIXING ALL HTML FILES IN ERROR CORRECT FOLDER" -ForegroundColor Cyan
Write-Host "Total files found: $totalFiles" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

foreach ($file in $htmlFiles) {
    try {
        $fileContent = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        $originalContent = $fileContent
        $changes = @()
        
        # Social Media Links
        $fileContent = $fileContent -replace 'https://twitter.com/pypayurved', 'https://twitter.com/gautamrose'
        $fileContent = $fileContent -replace 'https://in.pinterest.com/patanjaliutpad', 'https://in.pinterest.com/gautamrose'
        
        # Product Names (Image Alt Text, Cart Item Names, etc.)
        $fileContent = $fileContent -replace 'alt="Patanjali Giloy Ghanvati', 'alt="Wall Art Piece'
        $fileContent = $fileContent -replace 'itemname="Patanjali Giloy Ghanvati', 'itemname="Wall Art Piece'
        $fileContent = $fileContent -replace 'alt="Patanjali Giloy Juice"', 'alt="Focus on Good"'
        $fileContent = $fileContent -replace 'alt="Patanjali Special Chyawanprash"', 'alt="Five Quotes Art"'
        $fileContent = $fileContent -replace 'alt="Patanjali Tulsi Ghanvati"', 'alt="Shree Ganesha Mantra"'
        $fileContent = $fileContent -replace 'alt="Patanjali Kachi Ghani Mustard Oil"', 'alt="Black Round Art"'
        $fileContent = $fileContent -replace 'alt="Divya Kutki Churna"', 'alt="Abstract Art 400"'
        $fileContent = $fileContent -replace 'alt="Divya Rasna Churna"', 'alt="Botanical Art Print"'
        $fileContent = $fileContent -replace 'alt="Divya Mulethi Churna"', 'alt="Abstract Art 406"'
        $fileContent = $fileContent -replace 'alt="Divya Amla Churna"', 'alt="Black Round Art"'
        $fileContent = $fileContent -replace 'alt="Divya Haridrakhand"', 'alt="Every Family Has A Story"'
        $fileContent = $fileContent -replace 'alt="Patanjali Swet Mushli Churna"', 'alt="Floral Wall Art"'
        $fileContent = $fileContent -replace 'alt="Patanjali Unpolished Urad Whole"', 'alt="Dot Art Design"'
        $fileContent = $fileContent -replace 'alt="Patanjali Soya Chunks"', 'alt="Mandala Art Design"'
        $fileContent = $fileContent -replace 'alt="Divya Shuddh Shilajeet"', 'alt="Abstract Botanical Art"'
        
        # Only write if changed
        if ($fileContent -ne $originalContent) {
            $fileContent | Out-File -FilePath $file.FullName -Encoding UTF8
            $fixedCount++
            $relativePath = $file.FullName.Substring($rootDir.Length + 1)
            Write-Host "FIXED: $relativePath" -ForegroundColor Green
        }
    }
    catch {
        $errorCount++
        Write-Host "ERROR: $($file.FullName) - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "FIX COMPLETE" -ForegroundColor Green
Write-Host "Files fixed: $fixedCount" -ForegroundColor Green
Write-Host "Errors: $errorCount" -ForegroundColor $(if ($errorCount -gt 0) { "Red" } else { "Green" })
Write-Host "========================================" -ForegroundColor Cyan
