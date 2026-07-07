# Fix Healing Quotes Products
$rootDir = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net"

# Find all Healing Quotes product folders
$healingFolders = Get-ChildItem -Path $rootDir -Recurse -Directory -Filter "*Healing Quotes*" | Sort-Object FullName

Write-Host "Found $($healingFolders.Count) Healing Quotes folders" -ForegroundColor Cyan

foreach ($folder in $healingFolders) {
    # Get the folder name (e.g., "Healing Quotes-45")
    $folderName = $folder.Name
    
    # Find HTML files in this folder
    $htmlFiles = Get-ChildItem -Path $folder.FullName -Filter "*.html" -File
    
    foreach ($file in $htmlFiles) {
        Write-Host "Processing: $folderName\$($file.Name)" -ForegroundColor Yellow
        
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        
        # Extract number from folder name (e.g., "45" from "Healing Quotes-45")
        $number = $folderName -replace '.*-(\d+)$', '$1'
        $newProductName = "Healing Quotes Frame $number"
        
        # Fix title
        $content = $content -replace '<title>.*</title>', "<title>Buy Online $newProductName - Healing Art Quote Frame</title>"
        
        # Fix meta description  
        $content = $content -replace '<meta name="description" content="[^"]*"', "<meta name=\"description\" content=\"Buy $newProductName @gautamrose.net - Beautiful Healing Quotes Art Frames for Home Decor. Lowest Prices, Genuine Products, Free Shipping, COD available.\""
        
        # Fix meta keywords
        $content = $content -replace '<meta name="keywords" content="[^"]*"', "<meta name=\"keywords\" content=\"healing quotes, art frames, wall decor, home decoration, healing art, quote frames, healing quotes $number, gautam rose, art gallery\""
        
        # Fix author
        $content = $content -replace '<meta name="author" content="[^"]*"', '<meta name="author" content="Gautam Rose">'
        
        # Fix h1/h2 product titles in the content
        $content = $content -replace '(?s)<h1[^>]*>.*?</h1>', "<h1 class='product-name'>$newProductName</h1>"
        
        # Fix itemname in cart buttons
        $content = $content -replace 'itemname="[^"]*"', "itemname=\"$newProductName\""
        
        # Only save if changed
        if ($content -ne $originalContent) {
            $content | Out-File -FilePath $file.FullName -Encoding UTF8
            Write-Host "  FIXED: $folderName" -ForegroundColor Green
        }
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Healing Quotes Products Fixed!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
