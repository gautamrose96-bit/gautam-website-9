# PowerShell Script to Fix Mandala Art Product Pages
# This script fixes product names, meta tags, and related products in all mandala art HTML files

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Fixing Mandala Art Product Pages" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$productBasePath = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net\product\mandala art"
$fixedCount = 0
$errorCount = 0

# Get all HTML files in mandala art product directory
$htmlFiles = Get-ChildItem -Path $productBasePath -Recurse -Filter "*.html" -ErrorAction SilentlyContinue

Write-Host "Found $($htmlFiles.Count) HTML files to process" -ForegroundColor Yellow

foreach ($file in $htmlFiles) {
    try {
        $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        $modified = $false
        $fileName = $file.Name
        $folderName = $file.Directory.Name
        
        # Extract product name from folder name (e.g., "Mandala Art5- Item No-4")
        $productName = $folderName
        
        # Fix 1: Update meta author from patanjali to gautamrose
        if ($content -match 'name="author" content="patanjali"') {
            $content = $content -replace 'name="author" content="patanjali"', 'name="author" content="gautamrose"'
            $modified = $true
        }
        
        # Fix 2: Update title tag if it's generic or wrong
        if ($content -match '<title>\s*Online\s*</title>' -or 
            $content -match '<title>[^<]*Patanjali[^<]*</title>' -or
            $content -match '<title>[^<]*Dish Wash[^<]*</title>' -or
            $content -match '<title>[^<]*Super[^<]*</title>' -or
            $content -match '<title>[^<]*Ayurved[^<]*</title>') {
            $newTitle = "<title>$productName - Buy Mandala Art Online | gautamrose.net</title>"
            $content = $content -replace '<title>[^<]*</title>', $newTitle
            $modified = $true
        }
        
        # Fix 3: Update meta description - remove Ayurveda references
        if ($content -match 'name="description" content="[^"]*(?:Patanjali|Ayurved|herbal|medicine|dish wash|super scrub)[^"]*"') {
            $newDesc = 'name="description" content="Beautiful mandala art piece - ' + $productName + '. Handcrafted with love for your home and office decoration. Buy authentic mandala artwork from gautamrose.net"'
            $content = $content -replace 'name="description" content="[^"]*"', $newDesc
            $modified = $true
        }
        
        # Fix 4: Update meta keywords - remove Ayurveda terms
        if ($content -match 'name="keywords" content="[^"]*(?:patanjali|ayurved|medicine|dal|grocery|health)[^"]*"') {
            $newKeywords = 'name="keywords" content="mandala art, wall art, home decor, handmade crafts, ' + $productName + ', gautamrose, art and craft"'
            $content = $content -replace 'name="keywords" content="[^"]*"', $newKeywords
            $modified = $true
        }
        
        # Fix 5: Update OG title meta tags for Facebook sharing
        if ($content -match 'property="og:title" content="[^"]*(?:Patanjali|Dish Wash|Super Scrub)[^"]*"') {
            $content = $content -replace 'property="og:title" content="[^"]*"', "property=`"og:title`" content=`"$productName`""
            $modified = $true
        }
        
        # Fix 6: Update JavaScript product data - change category from "Herbal Home Care" to "Mandala Art"
        if ($content -match '"category":\s*"Herbal Home Care"') {
            $content = $content -replace '"category":\s*"Herbal Home Care"', '"category": "Mandala Art"'
            $modified = $true
        }
        
        # Fix 7: Update subcategory in JavaScript
        if ($content -match '"subcategory":\s*"Dishwash Bar and Gel"') {
            $content = $content -replace '"subcategory":\s*"Dishwash Bar and Gel"', '"subcategory": "Mandala Art and Handicraft"'
            $modified = $true
        }
        
        # Fix 8: Update JavaScript product name
        if ($content -match '"name":\s*"Super Dish Wash Bar[^"]*"') {
            $content = $content -replace '"name":\s*"Super Dish Wash Bar[^"]*"', "`"name`": `"$productName`""
            $modified = $true
        }
        
        # Fix 9: Update smartech product description
        if ($content -match '"description":\s*"Lemon combined with wood ash[^"]*"') {
            $newDesc = "Beautiful mandala artwork - " + $productName + ". Perfect for home and office decoration."
            $content = $content -replace '"description":\s*"Lemon combined with wood ash[^"]*"', "`"description`": `"$newDesc`""
            $modified = $true
        }
        
        # Fix 10: Remove old Ayurveda product links in related products section
        # These links point to non-existent Ayurveda products
        if ($content -match 'patanjali-super-scrub-pad|patanjali-super-dish-wash|patanjali-super-steel-scrub') {
            # We'll update the related products section to use proper mandala art product names
            # Replace specific Ayurveda product names with art product names
            $content = $content -replace 'Patanjali Super Scrub Pad', 'Mandala Art Wall Decor'
            $content = $content -replace 'patanjali-super-scrub-pad', 'mandala-art-wall-decor'
            $content = $content -replace 'Patanjali Super Dish Wash Tub Plus Scrub Pad', 'Mandala Wall Art Canvas'
            $content = $content -replace 'patanjali-super-dish-wash-tub-plus-scrub-pad', 'mandala-wall-art-canvas'
            $content = $content -replace 'Patanjali Super Dish Wash Bar', 'Handcrafted Mandala Piece'
            $content = $content -replace 'patanjali-super-dish-wash-bar', 'handcrafted-mandala-piece'
            $content = $content -replace 'Patanjali Super Steel Scrub', 'Mandala Art Frame'
            $content = $content -replace 'patanjali-super-steel-scrub', 'mandala-art-frame'
            $content = $content -replace 'Patanjali Super Steel Scrub With Scrub Pad', 'Mandala Decor Art'
            $content = $content -replace 'patanjali-super-steel-scrub-with-scrub-pad', 'mandala-decor-art'
            $modified = $true
        }
        
        # Fix 11: Update product URL in smartech script from patanjaliayurved to gautamrose
        if ($content -match 'www\.patanjaliayurved\.net') {
            $content = $content -replace 'www\.patanjaliayurved\.net', 'www.gautamrose.net'
            $modified = $true
        }
        
        # Fix 12: Update benefits section content if it has Ayurveda info
        if ($content -match 'It act as a natural &amp; superior cleaning agent') {
            $content = $content -replace 'It act as a natural &amp; superior cleaning agent and disinfectant.', 'Beautiful mandala artwork that adds peace and harmony to your living space. Perfect for meditation rooms and home decor.'
            $modified = $true
        }
        
        # Fix 13: Update ingredients section to describe art materials
        if ($content -match 'Soda Ash Light\(Sodium Carbonate\)') {
            $content = $content -replace '<p><font size="3" face="georgia">Soda Ash Light\(Sodium Carbonate\)<br></font><font size="3" face="georgia">Labsa\(Dodecylbenzene Sulfonic Acid\)<br></font><font size="3" face="georgia">Lemon Peel Oil \(Citrus Limon\)<br></font><font size="3" face="georgia">Neem Extract \(Azadirachta Indica\)<br></font><font size="3" face="georgia">Wood Ash</font></p>', '<p><font size="3" face="georgia">High-quality art materials</font></p>'
            $modified = $true
        }
        
        # Fix 14: Update "Other Product Info" section
        if ($content -match 'Best before-60 months from manufacturing date') {
            $content = $content -replace 'Best before-60 months from manufacturing date.', 'Each piece is handcrafted with care and attention to detail.'
            $modified = $true
        }
        
        # Save the file if modified
        if ($modified) {
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -Force
            Write-Host "Fixed: $($file.FullName.Replace($productBasePath, '...'))" -ForegroundColor Green
            $fixedCount++
        }
    }
    catch {
        Write-Host "Error processing $($file.FullName): $($_.Exception.Message)" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "Fix Complete!" -ForegroundColor Cyan
Write-Host "Files Fixed: $fixedCount" -ForegroundColor Green
Write-Host "Errors: $errorCount" -ForegroundColor $(if ($errorCount -gt 0) { "Red" } else { "Green" })
Write-Host "==========================================" -ForegroundColor Cyan

# Pause to see results
Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
