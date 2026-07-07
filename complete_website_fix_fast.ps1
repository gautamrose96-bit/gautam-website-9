# Master Fast Fix - Copy error-correct files, rename products, fix navigation & content
$ErrorActionPreference = "Continue"
$root = "c:\Users\Shree\Desktop\gautam website 9"
$errorCorrect = Join-Path $root "website product name and error correct"
$mainSite = Join-Path $root "gautamrose website\www.gautamrose.net"
$productSource = Join-Path $errorCorrect "product"
$productTarget = Join-Path $mainSite "product"

$stats = @{ Copied = 0; Products = 0; Nav = 0; Content = 0; Healing = 0; Removed = 0; Errors = 0 }

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GAUTAM ROSE - COMPLETE WEBSITE FIX" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# STEP 1: Copy all fixed HTML from error-correct folder to main site
Write-Host "`n[1/6] Copying fixed files from error-correct folder..." -ForegroundColor Yellow
$htmlFiles = Get-ChildItem -Path $errorCorrect -Filter "*.html" -Recurse -File
foreach ($file in $htmlFiles) {
    try {
        $relativePath = $file.FullName.Substring($errorCorrect.Length + 1)
        $destPath = Join-Path $mainSite $relativePath
        $destFolder = Split-Path -Parent $destPath
        if (-not (Test-Path $destFolder)) { New-Item -ItemType Directory -Path $destFolder -Force | Out-Null }
        Copy-Item -Path $file.FullName -Destination $destPath -Force
        $stats.Copied++
    } catch { $stats.Errors++; Write-Host "  ERROR: $($file.Name)" -ForegroundColor Red }
}
Write-Host "  Copied $($stats.Copied) files" -ForegroundColor Green

# STEP 2: Map Ayurveda product folders to Art names and copy to main site
Write-Host "`n[2/6] Renaming product folders (Ayurveda -> Art)..." -ForegroundColor Yellow
$folderMappings = @{
    "divya-amla-churna" = "Black Round Art"
    "divya-haridrakhand" = "Every Family Has A Story Wall Art"
    "divya-kutki-churna" = "Colorful Mandala Art Piece"
    "divya-mulethi-churna" = "Abstract Art 406"
    "divya-rasna-churna" = "Botanical Art Print"
    "divya-shuddh-shilajeet-sat" = "Light Pink Art Frame"
    "patanjali-kachi-ghani-mustard-oil" = "Dot Art Mandala Wall Decor"
    "patanjali-soya-chunks" = "Abstract Art Wall Decor"
    "patanjali-swet-mushli-churna" = "Floral Wall Art Frame"
    "patanjali-unpolished-urad-whole" = "Modern Wall Art Canvas"
    "love to our family" = "Krishna Maha Mantra Wall Art"
}

$rootFileMappings = @{
    "3331.html" = @{ Folder = "Healing Quotes-2"; File = "3331.html" }
    "3352.html" = @{ Folder = "Healing Quotes-1"; File = "3352.html" }
    "3353.html" = @{ Folder = "Healing Quotes-3"; File = "3353.html" }
    "3477.html" = @{ Folder = "Namo-2 Wall Art"; File = "3477.html" }
    "3478.html" = @{ Folder = "Namokar Mantra Wall Art"; File = "3478.html" }
}

foreach ($oldName in $folderMappings.Keys) {
    $newName = $folderMappings[$oldName]
    $src = Join-Path $productSource $oldName
    $dst = Join-Path $productTarget $newName
    if (Test-Path $src) {
        if (-not (Test-Path $dst)) { New-Item -ItemType Directory -Path $dst -Force | Out-Null }
        Get-ChildItem -Path $src -Filter "*.html" -Recurse | ForEach-Object {
            Copy-Item $_.FullName (Join-Path $dst $_.Name) -Force
            $stats.Products++
        }
    }
}

foreach ($fileName in $rootFileMappings.Keys) {
    $m = $rootFileMappings[$fileName]
    $src = Join-Path $productSource $fileName
    $dstFolder = Join-Path $productTarget $m.Folder
    if (Test-Path $src) {
        if (-not (Test-Path $dstFolder)) { New-Item -ItemType Directory -Path $dstFolder -Force | Out-Null }
        Copy-Item $src (Join-Path $dstFolder $m.File) -Force
        $stats.Products++
    }
}

# Healing Quotes files from error-correct root
Get-ChildItem -Path $errorCorrect -Filter "Healing Quotes-*.html" | ForEach-Object {
    if ($_.Name -match 'Healing Quotes-(\d+)-(\d+)\.html') {
        $folder = "Healing Quotes-$($matches[1])"
        $fileId = "$($matches[2]).html"
        $dstFolder = Join-Path $productTarget $folder
        if (-not (Test-Path $dstFolder)) { New-Item -ItemType Directory -Path $dstFolder -Force | Out-Null }
        Copy-Item $_.FullName (Join-Path $dstFolder $fileId) -Force
        $stats.Products++
    }
}
Write-Host "  Processed $($stats.Products) product files" -ForegroundColor Green

# STEP 3: Remove duplicate old Ayurveda-named folders from main product dir
Write-Host "`n[3/6] Removing duplicate Ayurveda folders..." -ForegroundColor Yellow
foreach ($oldName in $folderMappings.Keys) {
    $newName = $folderMappings[$oldName]
    $oldPath = Join-Path $productTarget $oldName
    $newPath = Join-Path $productTarget $newName
    if ((Test-Path $oldPath) -and (Test-Path $newPath)) {
        Remove-Item -Path $oldPath -Recurse -Force
        $stats.Removed++
        Write-Host "  Removed: $oldName (art folder exists: $newName)" -ForegroundColor DarkGray
    }
}
Write-Host "  Removed $($stats.Removed) duplicate folders" -ForegroundColor Green

# STEP 4: Fix navigation links across all HTML
Write-Host "`n[4/6] Fixing navigation links..." -ForegroundColor Yellow
$navReplacements = @(
    @{ Old = '"../natural-food-products/2.html"'; New = '"../room and wall art /2.html"' }
    @{ Old = '"../../category/natural-food-products/2.html"'; New = '"../../category/room and wall art /2.html"' }
    @{ Old = '"../../../category/natural-food-products/2.html"'; New = '"../../../category/room and wall art /2.html"' }
    @{ Old = '"../ayurvedic-medicine/4.html"'; New = '"../art and craft/4.html"' }
    @{ Old = '"../../category/ayurvedic-medicine/4.html"'; New = '"../../category/art and craft/4.html"' }
    @{ Old = '"../../../category/ayurvedic-medicine/4.html"'; New = '"../../../category/art and craft/4.html"' }
    @{ Old = '"../herbal-home-care/6.html"'; New = '"../mandala art/6.html"' }
    @{ Old = '"../../category/herbal-home-care/6.html"'; New = '"../../category/mandala art/6.html"' }
    @{ Old = '"../../../category/herbal-home-care/6.html"'; New = '"../../../category/mandala art/6.html"' }
    @{ Old = '"../biscuits-and-cookies/3.html"'; New = '"../Living room and wall art/3.html"' }
    @{ Old = '"../../category/biscuits-and-cookies/3.html"'; New = '"../../category/Living room and wall art/3.html"' }
    @{ Old = '"../spices/11.html"'; New = '"../Living room wall art two /11.html"' }
    @{ Old = '"../../category/spices/11.html"'; New = '"../../category/Living room wall art two /11.html"' }
    @{ Old = '"../candy/12.html"'; New = '"../Living room wall art three /12.html"' }
    @{ Old = '"../../category/candy/12.html"'; New = '"../../category/Living room wall art three /12.html"' }
    @{ Old = '"../herbal-tea/13.html"'; New = '"../Happy place art/13.html"' }
    @{ Old = '"../../category/herbal-tea/13.html"'; New = '"../../category/Happy place art/13.html"' }
    @{ Old = '"../jam/14.html"'; New = '"../Kids room art/14.html"' }
    @{ Old = '"../../category/jam/14.html"'; New = '"../../category/Kids room art/14.html"' }
    @{ Old = '"../murabba/15.html"'; New = '"../Healing quotes art work/15.html"' }
    @{ Old = '"../../category/murabba/15.html"'; New = '"../../category/Healing quotes art work/15.html"' }
    @{ Old = '"../corn-flakes/183.html"'; New = '"../Corn Flakes Art/183.html"' }
    @{ Old = '"../../category/corn-flakes/183.html"'; New = '"../../category/Corn Flakes Art/183.html"' }
    @{ Old = '"../oats/191.html"'; New = '"../Abstract wall art three/191.html"' }
    @{ Old = '"../../category/oats/191.html"'; New = '"../../category/Abstract wall art three/191.html"' }
    @{ Old = '"../papad/192.html"'; New = '"../Abstract wall art four/192.html"' }
    @{ Old = '"../../category/papad/192.html"'; New = '"../../category/Abstract wall art four/192.html"' }
    @{ Old = '"../namkeen/193.html"'; New = '"../Abstract wall art five/193.html"' }
    @{ Old = '"../../category/namkeen/193.html"'; New = '"../../category/Abstract wall art five/193.html"' }
    @{ Old = '"../kwath/5.html"'; New = '"../Home wall decoration paintings/5.html"' }
    @{ Old = '"../../category/kwath/5.html"'; New = '"../../category/Home wall decoration paintings/5.html"' }
    @{ Old = '"../packages-for-diseases/10.html"'; New = '"../Happy place craft decor/10.html"' }
    @{ Old = '"../../category/packages-for-diseases/10.html"'; New = '"../../category/Happy place craft decor/10.html"' }
    @{ Old = '"../bhasma/17.html"'; New = '"../Bhasma Art/17.html"' }
    @{ Old = '"../../category/bhasma/17.html"'; New = '"../../category/Bhasma Art/17.html"' }
    @{ Old = '"../churna/18.html"'; New = '"../home craft decor/18.html"' }
    @{ Old = '"../../category/churna/18.html"'; New = '"../../category/home craft decor/18.html"' }
    @{ Old = '"../guggul/19.html"'; New = '"../Home craft decor two /19.html"' }
    @{ Old = '"../../category/guggul/19.html"'; New = '"../../category/Home craft decor two /19.html"' }
    @{ Old = '"../parpati-ras/134.html"'; New = '"../Home craft decor three /134.html"' }
    @{ Old = '"../../category/parpati-ras/134.html"'; New = '"../../category/Home craft decor three /134.html"' }
    @{ Old = '"../light pink art/135.html"'; New = '"../Light pink art /135.html"' }
    @{ Old = '"../../category/light pink art/135.html"'; New = '"../../category/Light pink art /135.html"' }
    @{ Old = '"../arishta/178.html"'; New = '"../home craft decor three /178.html"' }
    @{ Old = '"../../category/arishta/178.html"'; New = '"../../category/home craft decor three /178.html"' }
    @{ Old = '"../asava/179.html"'; New = '"../colour art/179.html"' }
    @{ Old = '"../../category/asava/179.html"'; New = '"../../category/colour art/179.html"' }
    @{ Old = '"../syrup/181.html"'; New = '"../home craft/181.html"' }
    @{ Old = '"../../category/syrup/181.html"'; New = '"../../category/home craft/181.html"' }
    @{ Old = '"../health-and-wellness/139.html"'; New = '"../Home decor art two/139.html"' }
    @{ Old = '"../../category/health-and-wellness/139.html"'; New = '"../../category/Home decor art two/139.html"' }
    @{ Old = '"../chyawanprash/150.html"'; New = '"../home decor art three/150.html"' }
    @{ Old = '"../../category/chyawanprash/150.html"'; New = '"../../category/home decor art three/150.html"' }
    @{ Old = '"../ghee/152.html"'; New = '"../Home decor art five/152.html"' }
    @{ Old = '"../../category/ghee/152.html"'; New = '"../../category/Home decor art five/152.html"' }
    @{ Old = '"../honey/153.html"'; New = '"../Home decor art six/153.html"' }
    @{ Old = '"../../category/honey/153.html"'; New = '"../../category/Home decor art six/153.html"' }
    @{ Old = '"../health-drinks/177.html"'; New = '"../home decor art seven/177.html"' }
    @{ Old = '"../../category/health-drinks/177.html"'; New = '"../../category/home decor art seven/177.html"' }
    @{ Old = '"../diet-food/218.html"'; New = '"../Pink Art two/218.html"' }
    @{ Old = '"../../category/diet-food/218.html"'; New = '"../../category/Pink Art two/218.html"' }
    @{ Old = '>Natural Food Products<'; New = '>Room and Wall Art<' }
    @{ Old = '>Ayurvedic Medicine<'; New = '>Art and Craft<' }
    @{ Old = '>Herbal Home Care<'; New = '>Mandala Art<' }
)

$allHtml = Get-ChildItem -Path $mainSite -Recurse -Filter "*.html" | Where-Object { $_.FullName -notmatch "waste submenu" }
foreach ($file in $allHtml) {
    $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    $original = $content
    foreach ($r in $navReplacements) {
        $content = $content.Replace($r.Old, $r.New)
    }
    if ($content -ne $original) {
        Set-Content -Path $file.FullName -Value $content -NoNewline -Encoding UTF8
        $stats.Nav++
    }
}
Write-Host "  Fixed navigation in $($stats.Nav) files" -ForegroundColor Green

# STEP 5: Global content fixes (author, social, common text)
Write-Host "`n[5/6] Fixing content (author, social, product text)..." -ForegroundColor Yellow
foreach ($file in $allHtml) {
    try {
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        $original = $content

        $content = $content -replace 'name="author" content="patanjali"', 'name="author" content="gautamrose"'
        $content = $content -replace 'name="author" content="Gautam Rose">>', 'name="author" content="gautamrose">'
        $content = $content -replace 'https://twitter.com/pypayurved', 'https://twitter.com/gautamrose'
        $content = $content -replace 'https://in.pinterest.com/patanjaliutpad', 'https://in.pinterest.com/gautamrose'
        $content = $content -replace 'alt="patanjali products"', 'alt="gautam rose art products"'
        $content = $content -replace 'By:\s*PATANJALI', 'By: gautam rose'
        $content = $content -replace 'By:\s*Patanjali', 'By: gautam rose'
        $content = $content -replace 'pypayurved@gmail.com', 'gautamrose@gmail.com'
        $content = $content -replace 'care@patanjaliayurved.org', 'gautamrose@gmail.com'

        if ($content -ne $original) {
            Set-Content -Path $file.FullName -Value $content -NoNewline -Encoding UTF8
            $stats.Content++
        }
    } catch { $stats.Errors++ }
}
Write-Host "  Fixed content in $($stats.Content) files" -ForegroundColor Green

# STEP 6: Fix Healing Quotes product pages
Write-Host "`n[6/6] Fixing Healing Quotes product pages..." -ForegroundColor Yellow
$healingFolders = Get-ChildItem -Path $productTarget -Directory | Where-Object { $_.Name -like "Healing Quotes-*" }
foreach ($folder in $healingFolders) {
    if ($folder.Name -match 'Healing Quotes-(\d+)') { $num = $matches[1]; $productName = "Healing Quotes Frame $num" } else { continue }
    Get-ChildItem -Path $folder.FullName -Filter "*.html" -File | ForEach-Object {
        $content = Get-Content $_.FullName -Raw -Encoding UTF8
        $original = $content
        if ($content -match '(?i)patanjali|divya|ayurved|face wash|chyawanprash|ghanvati|churna|bhasma|kwath|gulkand|murabba') {
            $content = $content -replace '(?s)<title>[^<]*(?:Patanjali|Divya|face wash|NEEM|TULSI)[^<]*</title>', "<title>Buy Online $productName - Healing Art Quote</title>"
            $content = $content -replace 'name="author" content="[^"]*"', 'name="author" content="gautamrose"'
            $content = $content -replace 'By:\s*PATANJALI', 'By: gautam rose'
            if ($content -match '(?i)<h3>[^<]*(?:Patanjali|Divya|NEEM|TULSI|face wash)') {
                $content = $content -replace '(?s)<h3>[^<]*(?:Patanjali|Divya|NEEM|TULSI|face wash)[^<]*</h3>', "<h3>$productName - Inspirational Art Wall Decor</h3>"
            }
        }
        if ($content -ne $original) {
            Set-Content $_.FullName $content -NoNewline -Encoding UTF8
            $stats.Healing++
        }
    }
}
Write-Host "  Fixed $($stats.Healing) Healing Quotes files" -ForegroundColor Green

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "COMPLETE!" -ForegroundColor Green
Write-Host "  Files copied:      $($stats.Copied)" -ForegroundColor White
Write-Host "  Products fixed:    $($stats.Products)" -ForegroundColor White
Write-Host "  Duplicates removed:$($stats.Removed)" -ForegroundColor White
Write-Host "  Navigation fixed:  $($stats.Nav)" -ForegroundColor White
Write-Host "  Content fixed:     $($stats.Content)" -ForegroundColor White
Write-Host "  Healing Quotes:    $($stats.Healing)" -ForegroundColor White
Write-Host "  Errors:            $($stats.Errors)" -ForegroundColor $(if ($stats.Errors -gt 0) { "Red" } else { "Green" })
Write-Host "========================================" -ForegroundColor Cyan
