# Fix ALL remaining product pages - Patanjali/Divya/Ayurveda -> Gautam Rose Art
$ErrorActionPreference = "Continue"
$mainSite = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net"
$productBase = Join-Path $mainSite "product"

$ayurvedaPattern = '(?i)patanjali|divya|ayurved|baba\s*ramdev|chyawanprash|ghanvati|churna|bhasma|kwath|gomutra|godhan|pishti|murabba|gulkand|neem\s*tulsi|face\s*wash|dish\s*wash|detergent|dal\b|urad|mustard\s*oil|honey\b|ghee\b|coronil|swasari|shilaj|shilajeet|medohar|madhu|lipidom|cardiogrit|thyrogrit|orthogrit|narisudha|mukta.?vati|kayakalp|amrit\s*rasayan|jamun\s*sirka|cornflakes|nutrela|medicine|herbal\s*home'

function Get-CategoryFromPath([string]$path) {
    if ($path -match '\\mandala art\\') { return @{ Cat = "Mandala Art"; Sub = "Mandala Art and Handicraft" } }
    if ($path -match '\\art and craft\\') { return @{ Cat = "Art and Craft"; Sub = "Wall Art Home Decoration" } }
    if ($path -match '\\room and wall art\\') { return @{ Cat = "Room and Wall Art"; Sub = "Room Decor Art" } }
    if ($path -match '\\luxury room decor\\') { return @{ Cat = "Luxury Room Decor"; Sub = "Luxury Wall Art" } }
    if ($path -match 'Healing Quotes') { return @{ Cat = "Healing Quotes Art"; Sub = "Inspirational Wall Art" } }
    return @{ Cat = "Wall Art"; Sub = "Home Decor Art" }
}

function Get-ProductDisplayName([System.IO.FileInfo]$file) {
    $folder = $file.Directory.Name.Trim()
    $parent = $file.Directory.Parent.Name.Trim()

    if ($folder -match '^Healing Quotes-(\d+)$') { return "Healing Quotes Frame $($matches[1])" }
    if ($folder -match '(?i)healing quotes') { return $folder }
    if ($folder -match '(?i)^(item\s*no|mandala|namo|namokar|ganesha|krishna|welcome|good vibes)') { return $folder }
    if ($folder -match '(?i)^mandala') { return $folder }
    if ($folder -notmatch '^(?i)(patanjali|divya)-') { return $folder }

  $clean = ($folder -replace '^(?i)(patanjali|divya)-', '') -replace '-', ' '
    $title = (Get-Culture).TextInfo.ToTitleCase($clean)
    if ($parent -notmatch '^(?i)(patanjali|divya)-') {
        return "$parent - $title Art"
    }
    return "Wall Art - $title"
}

function Test-NeedsFix([string]$content) {
    return ($content -match $ayurvedaPattern) -or
           ($content -match 'patanjaliayurved') -or
           ($content -match 'Google Code for Patanjali') -or
           ($content -match 'Ayurvedic Medicine|Herbal Home Care|Natural Food') -or
           ($content -match 'name="author" content="gautam"') -or
           ($content -match 'By:\s*PATANJALI')
}

$stats = @{ Fixed = 0; Skipped = 0; Errors = 0 }
$htmlFiles = Get-ChildItem -Path $mainSite -Recurse -Filter "*.html" |
    Where-Object { $_.FullName -notmatch 'waste submenu' }

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "FIX ALL REMAINING PRODUCTS" -ForegroundColor Cyan
Write-Host "Scanning $($htmlFiles.Count) HTML files..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

foreach ($file in $htmlFiles) {
    try {
        $content = [System.IO.File]::ReadAllText($file.FullName)
        if (-not (Test-NeedsFix $content)) { $stats.Skipped++; continue }

        $original = $content
        $name = Get-ProductDisplayName $file
        $catInfo = Get-CategoryFromPath $file.FullName
        $category = $catInfo.Cat
        $subcategory = $catInfo.Sub
        $desc = "Buy $name online at gautamrose.net - Beautiful handcrafted wall art for home and office decoration. Genuine products, free shipping, COD available."
        $keywords = "wall art, home decor, $name, gautam rose, art gallery, paintings, mandala art"
        $title = "$name - Buy Online | gautamrose.net"

        # Meta tags
        if ($content -match '(?i)<title>[^<]*(?:patanjali|divya|ayurved|dal|churna|ghanvati|dish wash|detergent|gomutra|coronil|face wash|mustard|urad|honey|ghee|medicine)[^<]*</title>' -or
            $file.Directory.Name -match '^(?i)(patanjali|divya)-') {
            $content = $content -replace '(?s)<title>[^<]*</title>', "<title>$title</title>"
        }

        if ($content -match "(?i)name=`"description`" content=`"[^`"]*(?:patanjali|divya|ayurved|dal|churna|medicine|gomutra|dish|detergent)[^`"]*`"") {
            $content = $content -replace 'name="description" content="[^"]*"', "name=`"description`" content=`"$desc`""
        }

        if ($content -match "(?i)name=`"keywords`" content=`"[^`"]*(?:patanjali|divya|ayurved|dal|medicine|gomutra)[^`"]*`"") {
            $content = $content -replace 'name="keywords" content="[^"]*"', "name=`"keywords`" content=`"$keywords`""
        }

        $content = $content -replace 'name="author" content="gautam"', 'name="author" content="gautamrose"'
        $content = $content -replace 'name="author" content="patanjali"', 'name="author" content="gautamrose"'

        # OG tags
        if ($content -match "(?i)property=`"og:title`" content=`"[^`"]*(?:patanjali|divya|ayurved)[^`"]*`"") {
            $content = $content -replace 'property="og:title" content="[^"]*"', "property=`"og:title`" content=`"$name`""
        }
        if ($content -match "(?i)property=`"og:description`" content=`"[^`"]*(?:patanjali|divya|ayurved)[^`"]*`"") {
            $content = $content -replace 'property="og:description" content="[^"]*"', "property=`"og:description`" content=`"$desc`""
        }

        # Breadcrumb active item
        if ($content -match '(?i)<li class="active">\s*[^<]*(?:patanjali|divya|PATANJALI|URAD|DAL|CHURNA|GHANVATI|face wash|dish wash|coronil)[^<]*</li>') {
            $content = $content -replace '(?s)<li class="active">\s*[^<]*(?:patanjali|divya|PATANJALI|URAD|DAL|CHURNA|GHANVATI|face wash|dish wash|coronil)[^<]*</li>', "<li class=`"active`">$name</li>"
        }

        # H3 heading
        if ($content -match '(?i)<h3>[^<]*(?:patanjali|divya|PATANJALI|URAD|DAL|CHURNA|GHANVATI|face wash|dish wash|coronil|NEEM|TULSI)[^<]*</h3>') {
            $content = $content -replace '(?s)<h3>[^<]*(?:patanjali|divya|PATANJALI|URAD|DAL|CHURNA|GHANVATI|face wash|dish wash|coronil|NEEM|TULSI)[^<]*</h3>', "<h3>$name</h3>"
        }

        # Image alt
        $content = $content -replace '(?i)alt="[^"]*(?:patanjali|divya|PATANJALI|URAD DAL|CHURNA|GHANVATI|face wash|dish wash|coronil)[^"]*"', "alt=`"$name`""

        # Cart button itemname
        $content = $content -replace '(?i)itemname="[^"]*(?:patanjali|divya|PATANJALI|URAD|DAL|CHURNA|GHANVATI|face wash|dish wash)[^"]*"', "itemname=`"$name`""

        # By line
        $content = $content -replace 'By:\s*PATANJALI', 'By: gautam rose'
        $content = $content -replace 'By:\s*Patanjali', 'By: gautam rose'

        # JS product data
        $content = $content -replace '"category":\s*"Ayurvedic Medicine"', "`"category`": `"$category`""
        $content = $content -replace '"category":\s*"Herbal Home Care"', "`"category`": `"$category`""
        $content = $content -replace '"category":\s*"Natural Food Products"', "`"category`": `"$category`""
        $content = $content -replace '"category":\s*"Health and Wellness"', "`"category`": `"$category`""

        $content = $content -replace '"subcategory":\s*"Dishwash Bar and Gel"', "`"subcategory`": `"$subcategory`""
        $content = $content -replace '"subcategory":\s*"Ayurvedic Medicine"', "`"subcategory`": `"$subcategory`""
        $content = $content -replace '"subcategory":\s*"Pulses"', "`"subcategory`": `"$subcategory`""

        if ($content -match '(?i)"name":\s*"[^"]*(?:patanjali|divya|dish wash|scrub|detergent|urad|dal|churna)[^"]*"') {
            $content = $content -replace '(?i)"name":\s*"[^"]*(?:patanjali|divya|dish wash|scrub|detergent|urad|dal|churna)[^"]*"', "`"name`": `"$name`""
        }

        # URLs and domains
        $content = $content -replace 'www\.patanjaliayurved\.net', 'www.gautamrose.net'
        $content = $content -replace 'patanjaliayurved\.org', 'gautamrose.net'
        $content = $content -replace 'pypayurved@gmail\.com', 'gautamrose@gmail.com'
        $content = $content -replace 'care@patanjaliayurved\.org', 'gautamrose@gmail.com'

        # Related product name replacements (mandala/home care leftovers)
        $content = $content -replace 'Patanjali Super Scrub Pad', 'Mandala Art Wall Decor'
        $content = $content -replace 'patanjali-super-scrub-pad', 'mandala-art-wall-decor'
        $content = $content -replace 'Patanjali Super Dish Wash Bar', 'Handcrafted Mandala Piece'
        $content = $content -replace 'patanjali-super-dish-wash-bar', 'handcrafted-mandala-piece'
        $content = $content -replace 'Patanjali Super Steel Scrub', 'Mandala Art Frame'
        $content = $content -replace 'patanjali-super-steel-scrub', 'mandala-art-frame'
        $content = $content -replace 'Patanjali Green Flush Toilet Cleaner', 'Mandala Art Decor'
        $content = $content -replace 'patanjali-green-flush-toilet-cleaner', 'mandala-art-decor'
        $content = $content -replace 'Patanjali Herbal Hand Wash', 'Mandala Handicraft Art'
        $content = $content -replace 'patanjali-herbal-hand-wash', 'mandala-handicraft-art'
        $content = $content -replace 'Patanjali Herbo Wash', 'Mandala Wall Art'
        $content = $content -replace 'patanjali-herbo-wash', 'mandala-wall-art'
        $content = $content -replace 'Patanjali Superior Quality Detergent', 'Mandala Canvas Art'
        $content = $content -replace 'patanjali-superior-quality-detergent', 'mandala-canvas-art'
        $content = $content -replace 'Patanjali Germi X', 'Mandala Germ Art'
        $content = $content -replace 'patanjali-germi-x', 'mandala-germ-art'
        $content = $content -replace 'Patanjali Pain Reliever', 'Healing Art Frame'
        $content = $content -replace 'patanjali-pain-reliever', 'healing-art-frame'
        $content = $content -replace 'Divya Swasari Coronil', 'Healing Quotes Art Kit'
        $content = $content -replace 'divya-swasari-coronil', 'healing-quotes-art-kit'

        # Cleaning product descriptions -> art descriptions
        $content = $content -replace 'It act as a natural &amp; superior cleaning agent and disinfectant\.', 'Beautiful handcrafted artwork that adds peace and harmony to your living space.'
        $content = $content -replace 'Best before-60 months from manufacturing date\.', 'Each piece is handcrafted with care and attention to detail.'
        $content = $content -replace 'Lemon combined with wood ash[^"]*', "Beautiful mandala artwork - $name. Perfect for home and office decoration."

        # Twitter/pinterest
        $content = $content -replace 'text=Patanjali%20Ayurved', 'text=Gautam%20Rose%20Art'
        $content = $content -replace 'hashtags=Patanjali', 'hashtags=GautamRoseArt'

        # Description paragraph
        if ($content -match '(?i)<p class="description">[^<]*(?:patanjali|divya|dal|churna|medicine)[^<]*') {
            $content = $content -replace '(?s)<p class="description">[^<]*(?:patanjali|divya|dal|churna|medicine)[^<]*</p>', "<p class=`"description`">$desc</p>"
        }

        if ($content -ne $original) {
            [System.IO.File]::WriteAllText($file.FullName, $content)
            $stats.Fixed++
            if ($stats.Fixed % 100 -eq 0) {
                Write-Host "  Fixed $($stats.Fixed) files..." -ForegroundColor DarkGreen
            }
        }
    }
    catch {
        $stats.Errors++
        Write-Host "  ERROR: $($file.Name)" -ForegroundColor Red
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "COMPLETE!" -ForegroundColor Green
Write-Host "  Fixed:   $($stats.Fixed)" -ForegroundColor White
Write-Host "  Skipped: $($stats.Skipped) (already clean)" -ForegroundColor White
Write-Host "  Errors:  $($stats.Errors)" -ForegroundColor $(if ($stats.Errors -gt 0) { "Red" } else { "Green" })
Write-Host "========================================" -ForegroundColor Cyan
