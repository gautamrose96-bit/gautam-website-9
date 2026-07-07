# Comprehensive Fix for ALL Healing Quotes Products
$rootDir = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net"
$fixedCount = 0
$errorCount = 0

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "FIXING ALL HEALING QUOTES PRODUCTS" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

# Find all Healing Quotes folders
$healingFolders = Get-ChildItem -Path $rootDir -Recurse -Directory | Where-Object { $_.Name -like "*Healing Quote*" } | Sort-Object FullName

foreach ($folder in $healingFolders) {
    $folderName = $folder.Name
    
    # Extract number from folder name
    if ($folderName -match '-(\d+)$') {
        $number = $matches[1]
        $productName = "Healing Quotes Frame $number"
    } else {
        $productName = $folderName
        $number = ""
    }
    
    # Find HTML files
    $htmlFiles = Get-ChildItem -Path $folder.FullName -Filter "*.html" -File -ErrorAction SilentlyContinue
    
    foreach ($file in $htmlFiles) {
        try {
            $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
            $originalContent = $content
            $fileFixed = $false
            
            # FIX 1: Title containing Ayurveda/Patanjali terms
            if ($content -match '<title>.*(?:Patanjali|Divya|Amla|Harad|Bel|Gulkand|Murabba|neem|tulsi|face wash|baba ramdev|vrihat|shila|shuddh|ras|bhasma|churna|ghanvati|juice|kwath|oil).*</title>') {
                $content = $content -replace '<title>.*</title>', "<title>Buy Online $productName - Healing Art Quote</title>"
                $fileFixed = $true
            }
            
            # FIX 2: Meta description with Ayurveda terms
            if ($content -match 'name="description" content=".*(?:Patanjali|Divya|Amla|Harad|Bel|Gulkand|Murabba|neem|tulsi|face wash|vrihat|shila|shuddh|ras|bhasma|churna|ghanvati|juice|kwath|oil).*"') {
                $newDesc = "Buy $productName @gautamrose.net - Beautiful Healing Quotes Art Frames for Home Decor. Lowest Prices, Genuine Products, Free Shipping, COD available."
                $content = $content -replace 'name="description" content="[^"]*"', "name=\"description\" content=\"$newDesc\""
                $fileFixed = $true
            }
            
            # FIX 3: Meta keywords with Ayurveda terms
            if ($content -match 'name="keywords" content=".*(?:patanjali|ayurved|gulkand|murabba|amla|harad|bel|divya|neem|tulsi|bhasma|churna|ghanvati|juice|kwath|oil).*"') {
                $newKeywords = "healing quotes, art frames, wall decor, home decoration, healing art, quote frames, gautam rose, art gallery"
                $content = $content -replace 'name="keywords" content="[^"]*"', "name=\"keywords\" content=\"$newKeywords\""
                $fileFixed = $true
            }
            
            # FIX 4: Breadcrumb active item with Ayurveda terms
            if ($content -match '<li class="active">\s*(?:Patanjali|Divya|Amla|Harad|Bel|Gulkand|Murabba|Combo|NEEM|TULSI|face wash|vrihat|shila|shuddh|ras|bhasma|churna|ghanvati|juice|kwath|oil)') {
                $content = $content -replace '(?s)<li class="active">\s*[^<]*(?:Patanjali|Divya|Amla|Harad|Bel|Gulkand|Murabba|Combo|NEEM|TULSI|face wash|vrihat|shila|shuddh|ras|bhasma|churna|ghanvati|juice|kwath|oil)[^<]*</li>', "<li class=\"active\">$productName</li>"
                $fileFixed = $true
            }
            
            # FIX 5: H3 heading with Ayurveda terms
            if ($content -match '<h3>(?:Patanjali|Divya|Amla|Harad|Bel|Gulkand|Murabba|Combo|NEEM|TULSI|face wash|vrihat|shila|shuddh|ras|bhasma|churna|ghanvati|juice|kwath|oil)') {
                $content = $content -replace '(?s)<h3>.*?(?:Patanjali|Divya|Amla|Harad|Bel|Gulkand|Murabba|Combo|NEEM|TULSI|face wash|vrihat|shila|shuddh|ras|bhasma|churna|ghanvati|juice|kwath|oil).*?</h3>', "<h3>$productName - Inspirational Art Wall Decor</h3>"
                $fileFixed = $true
            }
            
            # FIX 6: Image alt with Ayurveda terms
            if ($content -match 'alt="(?:Patanjali|Divya|Amla|Harad|Bel|Gulkand|Murabba|Combo|NEEM|TULSI|face wash|vrihat|shila|shuddh|ras|bhasma)') {
                $content = $content -replace 'alt="[^"]*(?:Patanjali|Divya|Amla|Harad|Bel|Gulkand|Murabba|Combo|NEEM|TULSI|face wash|vrihat|shila|shuddh|ras|bhasma)[^"]*"', "alt=\"$productName\""
                $fileFixed = $true
            }
            
            # FIX 7: By line showing PATANJALI
            if ($content -match 'By:\s*PATANJALI') {
                $content = $content -replace 'By:\s*PATANJALI', 'By: gautam rose'
                $fileFixed = $true
            }
            
            # FIX 8: OG title with Ayurveda
            if ($content -match 'property="og:title" content="[^"]*(?:Patanjali|Divya|Amla|Harad|Bel|Gulkand|Murabba|Combo|NEEM|TULSI|face wash|vrihat|shila|shuddh|ras|bhasma)[^"]*"') {
                $content = $content -replace 'property="og:title" content="[^"]*"', "property=\"og:title\" content=\"$productName\""
                $fileFixed = $true
            }
            
            # FIX 9: OG description with Ayurveda
            if ($content -match 'property="og:description" content="[^"]*(?:Patanjali|Divya|Amla|Harad|Bel|Gulkand|Murabba|NEEM|TULSI|face wash|vrihat|shila|shuddh|ras|bhasma|churna|ghanvati|juice|kwath|oil)[^"]*"') {
                $newOGDesc = "$productName - Beautiful inspirational quote art for home decoration"
                $content = $content -replace 'property="og:description" content="[^"]*"', "property=\"og:description\" content=\"$newOGDesc\""
                $fileFixed = $true
            }
            
            # FIX 10: Description paragraph with Ayurveda
            if ($content -match '<p class="description">(?:Patanjali|Divya|Amla|Harad|Bel|Gulkand|Murabba|NEEM|TULSI|face wash|vrihat|shila|shuddh|ras|bhasma|churna|ghanvati|juice|kwath|oil)') {
                $newDescP = "<p class=\"description\">$productName - Beautiful inspirational quote art for home decoration<br>"
                $content = $content -replace '<p class="description">.*?</p>', $newDescP
                $fileFixed = $true
            }
            
            # FIX 11: Twitter share text
            if ($content -match 'text=Patanjali') {
                $content = $content -replace 'text=Patanjali%20Ayurved', 'text=Gautam%20Rose%20Art'
                $content = $content -replace 'hashtags=Patanjali', 'hashtags=HealingQuotes'
                $fileFixed = $true
            }
            
            # FIX 12: Social media links
            $content = $content -replace 'twitter\.com/pypayurved', 'twitter.com/gautamrose'
            $content = $content -replace 'pinterest\.com/patanjaliutpad', 'pinterest.com/gautamrose'
            
            # FIX 13: Google remarketing
            if ($content -match 'Google Code for Patanjali') {
                $content = $content -replace '<!-- Google Code for Patanjali_Ayurved_Remarketing -->[\s\S]*?</noscript>', '<!-- Gautam Rose Art Gallery - No Remarketing Code -->'
                $fileFixed = $true
            }
            
            # Save if changed
            if ($content -ne $originalContent) {
                $content | Out-File -FilePath $file.FullName -Encoding UTF8
                if ($fileFixed) {
                    Write-Host "FIXED: $folderName\$($file.Name)" -ForegroundColor Green
                    $fixedCount++
                }
            }
        }
        catch {
            Write-Host "ERROR: $folderName - $($_.Exception.Message)" -ForegroundColor Red
            $errorCount++
        }
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "COMPLETE! Fixed: $fixedCount files" -ForegroundColor Green
Write-Host "Errors: $errorCount" -ForegroundColor $(if ($errorCount -gt 0) { "Red" } else { "Green" })
Write-Host "========================================" -ForegroundColor Cyan
