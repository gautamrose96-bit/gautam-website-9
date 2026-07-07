# Fix Healing Quotes Product Names to Match Folder Names
$rootDir = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net"
$fixedCount = 0

# Find all Healing Quotes folders
$healingFolders = Get-ChildItem -Path $rootDir -Recurse -Directory | Where-Object { $_.Name -like "*Healing Quote*" } | Sort-Object FullName

foreach ($folder in $healingFolders) {
    $folderName = $folder.Name
    
    # Extract number
    if ($folderName -match '-(\d+)$') {
        $number = $matches[1]
        $productName = "Healing Quotes Frame $number"
        $seoName = "Healing Quotes $number"
    } else {
        $productName = $folderName
        $seoName = $folderName
    }
    
    # Find HTML files
    $htmlFiles = Get-ChildItem -Path $folder.FullName -Filter "*.html" -File -ErrorAction SilentlyContinue
    
    foreach ($file in $htmlFiles) {
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        
        # Fix title - extract current title and replace
        if ($content -match '<title>(.*?)</title>') {
            $currentTitle = $matches[1]
            if ($currentTitle -notlike "*Healing Quotes*") {
                $content = $content -replace '<title>.*?</title>', "<title>Buy Online $productName - Healing Art Quote</title>"
            }
        }
        
        # Fix meta description if it contains Ayurveda/Patanjali
        if ($content -match '<meta name="description" content="([^"]*)"') {
            $currentDesc = $matches[1]
            if ($currentDesc -match "patanjali|ayurved|gulkand|murabba|amla|harad|bel|divya") {
                $newDesc = "Buy $productName @gautamrose.net - Beautiful Healing Quotes Art Frames for Home Decor. Lowest Prices, Genuine Products, Free Shipping, COD available."
                $content = $content -replace '<meta name="description" content="[^"]*"', "<meta name=\"description\" content=\"$newDesc\""
            }
        }
        
        # Fix meta keywords if they contain Ayurveda
        if ($content -match '<meta name="keywords" content="([^"]*)"') {
            $currentKeywords = $matches[1]
            if ($currentKeywords -match "patanjali|ayurved|gulkand|murabba|amla|harad|bel|divya") {
                $newKeywords = "healing quotes, art frames, wall decor, home decoration, healing art, quote frames, $seoName, gautam rose, art gallery"
                $content = $content -replace '<meta name="keywords" content="[^"]*"', "<meta name=\"keywords\" content=\"$newKeywords\""
            }
        }
        
        # Fix breadcrumb active item (li class="active")
        $content = $content -replace '(?s)<li class="active">\s*[^<]*(?:Patanjali|Divya|Amla|Harad|Bel|Gulkand|Murabba)[^<]*</li>', "<li class=\"active\">$productName</li>"
        
        # Fix product detail h3 heading
        if ($content -match '<h3>(.*?Patanjali.*?</h3>)' -or $content -match '<h3>(.*?Divya.*?</h3>)' -or $content -match '<h3>(.*?Amla.*?</h3>)' -or $content -match '<h3>(.*?Gulkand.*?</h3>)') {
            $content = $content -replace '(?s)<h3>.*?(?:Patanjali|Divya|Amla|Harad|Bel|Gulkand|Murabba).*?</h3>', "<h3>$productName - Inspirational Art Wall Decor</h3>"
        }
        
        # Save if changed
        if ($content -ne $originalContent) {
            $content | Out-File -FilePath $file.FullName -Encoding UTF8
            Write-Host "FIXED NAMES: $folderName" -ForegroundColor Green
            $fixedCount++
        }
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "COMPLETE! Fixed $fixedCount product names" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
