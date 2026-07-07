# Fix ALL Remaining Healing Quotes Files
$rootDir = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net"
$fixedCount = 0
$totalCount = 0

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "FIXING ALL REMAINING HEALING QUOTES FILES" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

# Get all Healing Quotes HTML files
$healingFiles = Get-ChildItem -Path $rootDir -Recurse -File -Filter "*.html" | Where-Object { $_.DirectoryName -like "*Healing Quote*" } | Sort-Object FullName

foreach ($file in $healingFiles) {
    $totalCount++
    $folderName = $file.Directory.Name
    
    # Extract number from folder name
    if ($folderName -match '-(\d+)$') {
        $number = $matches[1]
        $productName = "Healing Quotes Frame $number"
    } else {
        $productName = $folderName -replace "healing quote-", "Healing Quotes Frame "
    }
    
    try {
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        $wasFixed = $false
        
        # Check if title contains Ayurveda terms and needs fixing
        if ($content -match '<title>.*(?:Patanjali|Divya|Amla|Harad|Bel|Gulkand|Murabba|noodles|masala|mehandi|hair oil|hand wash|sanitizer|face wash|neem|tulsi|daliya|besan|garam|herbal|kesh kanti|kanti).*</title>') {
            $content = $content -replace '<title>.*</title>', "<title>Buy Online $productName - Healing Art Quote</title>"
            $wasFixed = $true
        }
        
        # Check if description contains Ayurveda terms
        if ($content -match 'name="description" content=".*(?:Patanjali|Divya|Amla|Harad|Bel|Gulkand|Murabba|noodles|masala|mehandi|hair oil|hand wash|sanitizer|face wash|neem|tulsi|daliya|besan|garam|herbal|kesh kanti).*"') {
            $newDesc = "Buy $productName @gautamrose.net - Beautiful Healing Quotes Art Frames for Home Decor. Lowest Prices, Genuine Products, Free Shipping, COD available."
            $content = $content -replace 'name="description" content="[^"]*"', "name=\"description\" content=\"$newDesc\""
            $wasFixed = $true
        }
        
        # Check if keywords contain Ayurveda terms
        if ($content -match 'name="keywords" content=".*(?:patanjali|ayurved|gulkand|murabba|amla|harad|bel|divya|noodles|masala|mehandi|hair oil|hand wash|sanitizer|face wash|neem|tulsi|daliya|besan|garam|herbal|kesh kanti).*"') {
            $newKeywords = "healing quotes, art frames, wall decor, home decoration, healing art, quote frames, gautam rose, art gallery"
            $content = $content -replace 'name="keywords" content="[^"]*"', "name=\"keywords\" content=\"$newKeywords\""
            $wasFixed = $true
        }
        
        # Save if changed
        if ($content -ne $originalContent) {
            $content | Out-File -FilePath $file.FullName -Encoding UTF8
            if ($wasFixed) {
                Write-Host "FIXED: $folderName\$($file.Name)" -ForegroundColor Green
                $fixedCount++
            }
        } else {
            Write-Host "SKIPPED: $folderName (already fixed or no Ayurveda content)" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "ERROR: $folderName - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "COMPLETE! Processed: $totalCount files" -ForegroundColor Green
Write-Host "Fixed: $fixedCount files" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
