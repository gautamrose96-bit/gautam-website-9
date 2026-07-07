# Fix products/all.html cards + link all product IDs to real file paths
$ErrorActionPreference = "Continue"
$root = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net"
$productRoot = Join-Path $root "product"
$allHtml = Join-Path $root "products\all.html"

$ayurvedaSlug = '(?i)^(patanjali|divya|kesar|moosli|aastha-|herbal|gulkand|vinegar|camphor|ghee|kalawa|haldi|peya|churna|ghanvati|juice|dal|urad|honey|chyawanprash|coronil|swasari|mustard|oil|tablet|capsule|kwath|bhasma|syrup|nutrela)'

function Get-ArtDisplayName([string]$folderName, [string]$productId, [string]$parentName) {
    if ($folderName -match '(?i)healing quotes-(\d+)') { return "Healing Quotes Frame $($matches[1])" }
    if ($folderName -match '(?i)^(item\s*no|mandala|namo|namokar|ganesha|krishna|small art|wall art|abstract|floral|botanical|healing)') {
        return (Get-Culture).TextInfo.ToTitleCase($folderName.ToLower())
    }
    if ($folderName -notmatch $ayurvedaSlug) {
        return (Get-Culture).TextInfo.ToTitleCase($folderName.ToLower())
    }
    if ($parentName -and $parentName -notmatch $ayurvedaSlug) {
        return (Get-Culture).TextInfo.ToTitleCase($parentName.ToLower()) + " Art $productId"
    }
    return "Wall Art $productId"
}

function Get-PathScore([string]$path) {
    $score = 0
    if ($path -match '(?i)patanjali|divya|kesar|aastha-|herbal-tea|god mantra|gulkand|vinegar|camphor|moosli|dal-pulses') { $score += 100 }
    if ($path -match '(?i)mandala art|luxury room|art and craft|room and wall|healing quotes|small art|item no') { $score -= 10 }
    return $score
}

Write-Host "Building product index..." -ForegroundColor Cyan
$productIndex = @{}
Get-ChildItem $productRoot -Recurse -Filter "*.html" -File | ForEach-Object {
    $id = $_.BaseName
    if ($id -notmatch '^\d+$') { return }
    $rel = $_.FullName.Substring($root.Length + 1) -replace '\\', '/'
    $webPath = "../$rel"
    $folder = $_.Directory.Name
    $parent = $_.Directory.Parent.Name
    $display = Get-ArtDisplayName $folder $id $parent

    $entry = @{ Path = $webPath; Display = $display; File = $_ }
    if (-not $productIndex.ContainsKey($id)) {
        $productIndex[$id] = $entry
    } else {
        $oldScore = Get-PathScore $productIndex[$id].Path
        $newScore = Get-PathScore $rel
        if ($newScore -lt $oldScore) { $productIndex[$id] = $entry }
    }
}
Write-Host "Indexed $($productIndex.Count) product IDs" -ForegroundColor Green

# Fix products/all.html cards
Write-Host "Fixing products/all.html cards..." -ForegroundColor Yellow
$content = [IO.File]::ReadAllText($allHtml)
$original = $content
$cardsFixed = 0

$content = [regex]::Replace($content, '(?s)<div class="col-xs-12 col-sm-3 col-md-2 mb-25">\s*<article class="product light">.*?</article>\s*</div>', {
    param($m)
    $card = $m.Value
    if ($card -notmatch 'itemid="(\d+)"') { return $card }

    $id = $matches[1]
    if (-not $productIndex.ContainsKey($id)) { return $card }

    $info = $productIndex[$id]
    $path = $info.Path
    $name = $info.Display
    $escapedName = [regex]::Escape($name)

    # Fix all hrefs in card to correct path
    $card = $card -replace 'href="[^"]*\.html"', "href=`"$path`""
    $card = $card -replace 'href=''[^'']*\.html''', "href='$path'"

    # Fix product name link and title
    $card = $card -replace '(?s)<a title="[^"]*" href="[^"]*" class=" product-name"[^>]*>[^<]*</a>', "<a title=`"$name`" href=`"$path`" class=`" product-name`"  style=`"`">$name</a>"

    # Fix image alt
    $card = $card -replace 'alt="[^"]*"', "alt=`"$name`""

    # Fix cart button itemname
    $card = $card -replace 'itemname="[^"]*"', "itemname=`"$name`""

    # Remove veg/non-veg food icons (art site)
    $card = $card -replace '(?s)\s*<div class="veg_icon">.*?</div>', ''
    $card = $card -replace '(?s)\s*<div class="non_veg_icon">.*?</div>', ''

    # Remove food weight units (gm, ml) left in block-name
    $card = $card -replace '(?s)(</a>)\s*\r?\n\s*\r?\n\s*(gm|ml|kg)\s*\r?\n', '$1' + "`n"

    $script:cardsFixed++
    return $card
})

# Fix page title
$content = $content -replace '<title>[^<]*</title>', '<title>All Art Products - Buy Online | gautamrose.net</title>'
$content = $content -replace '<li class="active">All Products</li>', '<li class="active">All Art Products</li>'

if ($content -ne $original) {
    [IO.File]::WriteAllText($allHtml, $content)
    Write-Host "Fixed $cardsFixed product cards in all.html" -ForegroundColor Green
} else {
    Write-Host "No card changes in all.html" -ForegroundColor Yellow
}

# Fix individual product pages for IDs mentioned + any with bad titles/descriptions
Write-Host "Fixing individual product pages..." -ForegroundColor Yellow
$pagesFixed = 0
$foodWords = '(?i)kesar|saffron|camphor|ghee|vinegar|gulkand|peya|moosli|haldi|kalawa|dal\b|urad|churna|patanjali|divya|ayurved|medicine|gm\b|ml\b'

foreach ($id in @('1187','1035','41','826','1528','1043','2386','1036','1267','812','815')) {
    if (-not $productIndex.ContainsKey($id)) { continue }
    $file = $productIndex[$id].File
    $name = $productIndex[$id].Display
    $c = [IO.File]::ReadAllText($file.FullName)
    $orig = $c

    $c = $c -replace '(?s)<title>[^<]*</title>', "<title>$name - Buy Online | gautamrose.net</title>"
    if ($c -match '(?i)name="description" content="[^"]*(?:kesar|saffron|camphor|vinegar|gulkand|peya|moosli|ayurved|patanjali|divya|medicine|dal)[^"]*"') {
        $desc = "Buy $name online at gautamrose.net - Beautiful handcrafted wall art for home and office decoration."
        $c = $c -replace 'name="description" content="[^"]*"', "name=`"description`" content=`"$desc`""
    }
    if ($c -match '(?i)<h3>[^<]*(?:kesar|camphor|vinegar|gulkand|peya|moosli|patanjali|divya)[^<]*</h3>') {
        $c = $c -replace '(?s)<h3>[^<]*</h3>', "<h3>$name</h3>"
    }
    $c = $c -replace 'itemname="[^"]*"', "itemname=`"$name`""
    $c = $c -replace '(?s)\s*<div class="veg_icon">.*?</div>', ''
    $c = $c -replace '(?s)\s*<div class="non_veg_icon">.*?</div>', ''
    $c = $c -replace 'By:\s*PATANJALI', 'By: gautam rose'

    if ($c -ne $orig) {
        [IO.File]::WriteAllText($file.FullName, $c)
        $pagesFixed++
        Write-Host "  Fixed product $id -> $name" -ForegroundColor Green
    }
}

# Fix all product pages still showing food/ayurveda in h3 or title
Get-ChildItem $productRoot -Recurse -Filter "*.html" -File | ForEach-Object {
    $id = $_.BaseName
    if ($id -notmatch '^\d+$') { return }
    $c = [IO.File]::ReadAllText($_.FullName)
    if ($c -notmatch $foodWords) { return }
    $orig = $c
    $folder = $_.Directory.Name
    $parent = $_.Directory.Parent.Name
    $name = Get-ArtDisplayName $folder $id $parent

    if ($c -match '(?i)<title>[^<]*(?:kesar|camphor|vinegar|gulkand|peya|moosli|patanjali|divya|dal|urad|ghee|haldi)[^<]*</title>') {
        $c = $c -replace '(?s)<title>[^<]*</title>', "<title>$name - Buy Online | gautamrose.net</title>"
    }
    if ($c -match '(?i)<h3>[^<]*(?:kesar|camphor|vinegar|gulkand|peya|moosli|patanjali|divya|dal|urad|ghee)[^<]*</h3>') {
        $c = $c -replace '(?s)<h3>[^<]*</h3>', "<h3>$name</h3>"
    }
    $c = $c -replace '(?s)\s*<div class="veg_icon">.*?</div>', ''
    if ($c -ne $orig) {
        [IO.File]::WriteAllText($_.FullName, $c)
        $pagesFixed++
    }
}

Write-Host "`nDone! Cards: $cardsFixed | Product pages: $pagesFixed" -ForegroundColor Cyan
