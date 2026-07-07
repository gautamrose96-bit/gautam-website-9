Write-Host "Renaming and Fixing All Product Files" -ForegroundColor Cyan
$sourceFolder = "c:\Users\Shree\Desktop\gautam website 9\website product name and error correct"
$targetBase = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net\product"
$totalFixed = 0
$healingQuotesFiles = Get-ChildItem -Path $sourceFolder -Filter "Healing Quotes-*.html" | Sort-Object Name
Write-Host "Found $($healingQuotesFiles.Count) files to process" -ForegroundColor Yellow
foreach ($file in $healingQuotesFiles) {
    if ($file.Name -match 'Healing Quotes-(\d+)-(\d+)\.html') {
        $quoteNumber = $matches[1]
        $productId = $matches[2]
        $folderName = "Healing Quotes-$quoteNumber"
        Write-Host "Processing: $($file.Name)" -ForegroundColor Cyan
        $targetFolder = Join-Path $targetBase $folderName
        if (-not (Test-Path $targetFolder)) {
            New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null
        }
        $content = Get-Content -Path $file.FullName -Raw
        $content = $content -replace 'name="author" content="Gautam Rose">>', 'name="author" content="gautamrose">'
        $content = $content -replace 'name="author" content="patanjali"', 'name="author" content="gautamrose"'
        $targetFile = Join-Path $targetFolder "$productId.html"
        Set-Content -Path $targetFile -Value $content -Encoding UTF8 -Force
        Write-Host "  Created: $folderName\$productId.html" -ForegroundColor Green
        $totalFixed++
    }
}
Write-Host "Complete! Fixed $totalFixed files" -ForegroundColor Green
