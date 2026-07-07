# PowerShell Script to Fix Art and Craft Product Pages
# This script fixes product names, meta tags, and related products in all art and craft HTML files

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Fixing Art and Craft Product Pages" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$productBasePath = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net\product\art and craft"
$fixedCount = 0
$errorCount = 0

# Get all HTML files in art and craft product directory
$htmlFiles = Get-ChildItem -Path $productBasePath -Recurse -Filter "*.html" -ErrorAction SilentlyContinue

Write-Host "Found $($htmlFiles.Count) HTML files to process" -ForegroundColor Yellow

foreach ($file in $htmlFiles) {
    try {
        $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        $modified = $false
        $fileName = $file.Name
        $folderName = $file.Directory.Name
        
        # Extract product name from folder name
        $productName = $folderName
        
        # Fix 1: Update meta author from patanjali to gautamrose
        if ($content -match 'name="author" content="patanjali"') {
            $content = $content -replace 'name="author" content="patanjali"', 'name="author" content="gautamrose"'
            $modified = $true
        }
        
        # Fix 2: Update title tag if it contains Ayurveda terms
        if ($content -match '<title>[^<]*(?:Godhan|Gomutra|Cow Urine|Ayurved|Patanjali|Divya|Nari Sudha|Syrup|Pishti)[^<]*</title>') {
            $newTitle = "<title>$productName - Buy Art and Craft Online | gautamrose.net</title>"
            $content = $content -replace '<title>[^<]*</title>', $newTitle
            $modified = $true
        }
        
        # Fix 3: Update meta description - remove Ayurveda references
        if ($content -match 'name="description" content="[^"]*(?:Patanjali|Ayurved|herbal|medicine|godhan|gomutra|cow urine|syrup|pishti)[^"]*"') {
            $newDesc = 'name="description" content="Beautiful art and craft piece - ' + $productName + '. Handcrafted with love for your home and office decoration. Buy authentic artwork from gautamrose.net"'
            $content = $content -replace 'name="description" content="[^"]*"', $newDesc
            $modified = $true
        }
        
        # Fix 4: Update meta keywords - remove Ayurveda terms
        if ($content -match 'name="keywords" content="[^"]*(?:patanjali|ayurved|medicine|godhan|gomutra|cow urine|baba ramdev)[^"]*"') {
            $newKeywords = 'name="keywords" content="art and craft, wall art, home decor, handmade crafts, ' + $productName + ', gautamrose, artwork"'
            $content = $content -replace 'name="keywords" content="[^"]*"', $newKeywords
            $modified = $true
        }
        
        # Fix 5: Update OG title meta tags
        if ($content -match 'property="og:title" content="[^"]*(?:Godhan|Gomutra|Ayurved|Patanjali)[^"]*"') {
            $content = $content -replace 'property="og:title" content="[^"]*"', "property=`"og:title`" content=`"$productName`""
            $modified = $true
        }
        
        # Fix 6: Update JavaScript product data - change category
        if ($content -match '"category":\s*"Ayurvedic Medicine"') {
            $content = $content -replace '"category":\s*"Ayurvedic Medicine"', '"category": "Art and Craft"'
            $modified = $true
        }
        
        # Fix 7: Update product URL in smartech script from patanjaliayurved to gautamrose
        if ($content -match 'www\.patanjaliayurved\.net') {
            $content = $content -replace 'www\.patanjaliayurved\.net', 'www.gautamrose.net'
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
