# Fix remaining Ayurveda references in best-sellers.html
$file = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net\best-sellers.html"

$content = Get-Content -Path $file -Raw -Encoding UTF8
$originalContent = $content
Write-Host "Fixing best-sellers.html..." -ForegroundColor Cyan

# Fix cart button item names - Product 707 (Chyawanprash -> Five Quotes Art)
$content = $content -replace 'itemname="Patanjali Chyawanprash"', 'itemname="Five Quotes Art"'

# Fix cart button item names - Product 587 (Giloy Amla Juice -> Abstract Wall Art 3)
$content = $content -replace 'itemname="Patanjali Giloy Amla Juice"', 'itemname="Abstract Wall Art 3"'

# Fix cart button item names - Product 1632 (Hand Sanitizer -> Rose Art Frame)
$content = $content -replace 'itemname="Patanjali Hand Sanitizer "', 'itemname="Rose Art Frame"'

# Fix cart button item names - Product 655 (Herbal Hand Wash -> Lotus Art Frame)
$content = $content -replace 'itemname="Patanjali Herbal Hand Wash \(Anti Bacterial\)"', 'itemname="Lotus Art Frame"'

# Fix product display names and tooltips
$content = $content -replace 'data-original-title="Patanjali Chyawanprash">\s*Patanjali Chyawanprash</a>', 'data-original-title="Five Quotes Art">Five Quotes Art</a>'
$content = $content -replace 'data-original-title="Patanjali Giloy Amla Juice">\s*Patanjali Giloy Amla Juice</a>', 'data-original-title="Abstract Wall Art 3">Abstract Wall Art 3</a>'
$content = $content -replace 'data-original-title="Patanjali Hand Sanitizer">\s*Patanjali Hand Sanitizer</a>', 'data-original-title="Rose Art Frame">Rose Art Frame</a>'
$content = $content -replace 'data-original-title="Patanjali Herbal Hand Wash \(Anti Bacterial\)">\s*Patanjali Herbal Hand Wash \(Anti Bacterial\)</a>', 'data-original-title="Lotus Art Frame">Lotus Art Frame</a>'

# Fix image alt texts
$content = $content -replace 'alt="Patanjali Chyawanprash"', 'alt="Five Quotes Art"'
$content = $content -replace 'alt="Patanjali Giloy Amla Juice"', 'alt="Abstract Wall Art 3"'
$content = $content -replace 'alt="Patanjali Hand Sanitizer"', 'alt="Rose Art Frame"'
$content = $content -replace 'alt="Patanjali Herbal Hand Wash \(Anti Bacterial\)"', 'alt="Lotus Art Frame"'

# Check for changes
if ($content -ne $originalContent) {
    $content | Out-File -FilePath $file -Encoding UTF8
    Write-Host "FIXED: best-sellers.html updated successfully!" -ForegroundColor Green
} else {
    Write-Host "No changes needed or pattern not found" -ForegroundColor Yellow
}

# Also copy to error correct folder
$errorCorrectFile = "c:\Users\Shree\Desktop\gautam website 9\website product name and error correct\best-sellers.html"
if (Test-Path $errorCorrectFile) {
    Copy-Item -Path $file -Destination $errorCorrectFile -Force
    Write-Host "COPIED to error correct folder" -ForegroundColor Green
}
