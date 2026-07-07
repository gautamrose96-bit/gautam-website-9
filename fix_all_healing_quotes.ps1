# Fix ALL Healing Quotes Products
$rootDir = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net"
$fixedCount = 0
$errorCount = 0

# Find all Healing Quotes folders (case insensitive)
$healingFolders = Get-ChildItem -Path $rootDir -Recurse -Directory | Where-Object { $_.Name -like "*Healing Quote*" } | Sort-Object FullName

Write-Host "Found $($healingFolders.Count) Healing Quotes folders" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

foreach ($folder in $healingFolders) {
    try {
        # Get the folder name (e.g., "Healing Quotes-45")
        $folderName = $folder.Name
        
        # Extract number from folder name
        if ($folderName -match '-(\d+)$') {
            $number = $matches[1]
            $newProductName = "Healing Quotes Frame $number"
            $newKeywords = "healing quotes, art frames, wall decor, home decoration, healing art, quote frames, healing quotes $number, gautam rose, art gallery"
        } else {
            $newProductName = $folderName
            $newKeywords = "healing quotes, art frames, wall decor, home decoration, healing art, gautam rose, art gallery"
        }
        
        # Find HTML files in this folder
        $htmlFiles = Get-ChildItem -Path $folder.FullName -Filter "*.html" -File -ErrorAction SilentlyContinue
        
        foreach ($file in $htmlFiles) {
            Write-Host "Processing: $folderName\$($file.Name)" -ForegroundColor Yellow
            
            $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
            $originalContent = $content
            
            # Fix Google remarketing code
            $content = $content -replace '<!-- Google Code for Patanjali_Ayurved_Remarketing -->[\s\S]*?</noscript>', '<!-- Gautam Rose Art Gallery - No Remarketing Code -->'
            
            # Fix social media links
            $content = $content -replace 'https://twitter\.com/pypayurved', 'https://twitter.com/gautamrose'
            $content = $content -replace 'https://in\.pinterest\.com/patanjaliutpad', 'https://in.pinterest.com/gautamrose'
            
            # Fix author
            $content = $content -replace '<meta name="author" content="[^"]*"', '<meta name="author" content="Gautam Rose">'
            
            # Only save if changed
            if ($content -ne $originalContent) {
                $content | Out-File -FilePath $file.FullName -Encoding UTF8
                Write-Host "  FIXED: $folderName" -ForegroundColor Green
                $fixedCount++
            }
        }
    }
    catch {
        Write-Host "  ERROR: $($folder.FullName) - $($_.Exception.Message)" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "COMPLETE! Fixed: $fixedCount folders, Errors: $errorCount" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
