# PowerShell Script to Fix Navigation Links in All HTML Files
# This script replaces old Ayurveda navigation links with Art navigation links

$basePath = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net"

# Get all HTML files (excluding the waste folder)
$htmlFiles = Get-ChildItem -Path $basePath -Recurse -Filter "*.html" | 
    Where-Object { $_.FullName -notmatch "waste submenu" }

Write-Host "Found $($htmlFiles.Count) HTML files to process..." -ForegroundColor Green

# Define replacements
$replacements = @(
    # Category links
    @{ Old = '"../natural-food-products/2.html"'; New = '"../room and wall art /2.html"' },
    @{ Old = '"../../category/natural-food-products/2.html"'; New = '"../../category/room and wall art /2.html"' },
    @{ Old = '"../../../category/natural-food-products/2.html"'; New = '"../../../category/room and wall art /2.html"' },
    
    @{ Old = '"../ayurvedic-medicine/4.html"'; New = '"../art and craft/4.html"' },
    @{ Old = '"../../category/ayurvedic-medicine/4.html"'; New = '"../../category/art and craft/4.html"' },
    @{ Old = '"../../../category/ayurvedic-medicine/4.html"'; New = '"../../../category/art and craft/4.html"' },
    
    @{ Old = '"../herbal-home-care/6.html"'; New = '"../mandala art/6.html"' },
    @{ Old = '"../../category/herbal-home-care/6.html"'; New = '"../../category/mandala art/6.html"' },
    @{ Old = '"../../../category/herbal-home-care/6.html"'; New = '"../../../category/mandala art/6.html"' },
    
    # Sub-category links - Room and wall art
    @{ Old = '"../biscuits-and-cookies/3.html"'; New = '"../Living room and wall art/3.html"' },
    @{ Old = '"../../category/biscuits-and-cookies/3.html"'; New = '"../../category/Living room and wall art/3.html"' },
    @{ Old = '"../../../category/biscuits-and-cookies/3.html"'; New = '"../../../category/Living room and wall art/3.html"' },
    
    @{ Old = '"../spices/11.html"'; New = '"../Living room wall art two /11.html"' },
    @{ Old = '"../../category/spices/11.html"'; New = '"../../category/Living room wall art two /11.html"' },
    @{ Old = '"../../../category/spices/11.html"'; New = '"../../../category/Living room wall art two /11.html"' },
    
    @{ Old = '"../candy/12.html"'; New = '"../Living room wall art three /12.html"' },
    @{ Old = '"../../category/candy/12.html"'; New = '"../../category/Living room wall art three /12.html"' },
    @{ Old = '"../../../category/candy/12.html"'; New = '"../../../category/Living room wall art three /12.html"' },
    
    @{ Old = '"../herbal-tea/13.html"'; New = '"../Happy place art/13.html"' },
    @{ Old = '"../../category/herbal-tea/13.html"'; New = '"../../category/Happy place art/13.html"' },
    
    @{ Old = '"../jam/14.html"'; New = '"../Kids room art/14.html"' },
    @{ Old = '"../../category/jam/14.html"'; New = '"../../category/Kids room art/14.html"' },
    
    @{ Old = '"../murabba/15.html"'; New = '"../Healing quotes art work/15.html"' },
    @{ Old = '"../../category/murabba/15.html"'; New = '"../../category/Healing quotes art work/15.html"' },
    
    @{ Old = '"../corn-flakes/183.html"'; New = '"../Corn Flakes Art/183.html"' },
    @{ Old = '"../../category/corn-flakes/183.html"'; New = '"../../category/Corn Flakes Art/183.html"' },
    
    @{ Old = '"../oats/191.html"'; New = '"../Abstract wall art three/191.html"' },
    @{ Old = '"../../category/oats/191.html"'; New = '"../../category/Abstract wall art three/191.html"' },
    
    @{ Old = '"../papad/192.html"'; New = '"../Abstract wall art four/192.html"' },
    @{ Old = '"../../category/papad/192.html"'; New = '"../../category/Abstract wall art four/192.html"' },
    
    @{ Old = '"../namkeen/193.html"'; New = '"../Abstract wall art five/193.html"' },
    @{ Old = '"../../category/namkeen/193.html"'; New = '"../../category/Abstract wall art five/193.html"' },
    
    # Art and craft sub-categories
    @{ Old = '"../kwath/5.html"'; New = '"../Home wall decoration paintings/5.html"' },
    @{ Old = '"../../category/kwath/5.html"'; New = '"../../category/Home wall decoration paintings/5.html"' },
    
    @{ Old = '"../packages-for-diseases/10.html"'; New = '"../Happy place craft decor/10.html"' },
    @{ Old = '"../../category/packages-for-diseases/10.html"'; New = '"../../category/Happy place craft decor/10.html"' },
    
    @{ Old = '"../bhasma/17.html"'; New = '"../Bhasma Art/17.html"' },
    @{ Old = '"../../category/bhasma/17.html"'; New = '"../../category/Bhasma Art/17.html"' },
    
    @{ Old = '"../churna/18.html"'; New = '"../home craft decor/18.html"' },
    @{ Old = '"../../category/churna/18.html"'; New = '"../../category/home craft decor/18.html"' },
    
    @{ Old = '"../guggul/19.html"'; New = '"../Home craft decor two /19.html"' },
    @{ Old = '"../../category/guggul/19.html"'; New = '"../../category/Home craft decor two /19.html"' },
    
    @{ Old = '"../parpati-ras/134.html"'; New = '"../Home craft decor three /134.html"' },
    @{ Old = '"../../category/parpati-ras/134.html"'; New = '"../../category/Home craft decor three /134.html"' },
    
    @{ Old = '"../light pink art/135.html"'; New = '"../Light pink art /135.html"' },
    @{ Old = '"../../category/light pink art/135.html"'; New = '"../../category/Light pink art /135.html"' },
    
    @{ Old = '"../arishta/178.html"'; New = '"../home craft decor three /178.html"' },
    @{ Old = '"../../category/arishta/178.html"'; New = '"../../category/home craft decor three /178.html"' },
    
    @{ Old = '"../asava/179.html"'; New = '"../colour art/179.html"' },
    @{ Old = '"../../category/asava/179.html"'; New = '"../../category/colour art/179.html"' },
    
    @{ Old = '"../syrup/181.html"'; New = '"../home craft/181.html"' },
    @{ Old = '"../../category/syrup/181.html"'; New = '"../../category/home craft/181.html"' },
    
    # Luxury room decor sub-categories
    @{ Old = '"../health-and-wellness/139.html"'; New = '"../Home decor art two/139.html"' },
    @{ Old = '"../../category/health-and-wellness/139.html"'; New = '"../../category/Home decor art two/139.html"' },
    
    @{ Old = '"../chyawanprash/150.html"'; New = '"../home decor art three/150.html"' },
    @{ Old = '"../../category/chyawanprash/150.html"'; New = '"../../category/home decor art three/150.html"' },
    
    @{ Old = '"../ghee/152.html"'; New = '"../Home decor art five/152.html"' },
    @{ Old = '"../../category/ghee/152.html"'; New = '"../../category/Home decor art five/152.html"' },
    
    @{ Old = '"../honey/153.html"'; New = '"../Home decor art six/153.html"' },
    @{ Old = '"../../category/honey/153.html"'; New = '"../../category/Home decor art six/153.html"' },
    
    @{ Old = '"../health-drinks/177.html"'; New = '"../home decor art seven/177.html"' },
    @{ Old = '"../../category/health-drinks/177.html"'; New = '"../../category/home decor art seven/177.html"' },
    
    @{ Old = '"../diet-food/218.html"'; New = '"../Pink Art two/218.html"' },
    @{ Old = '"../../category/diet-food/218.html"'; New = '"../../category/Pink Art two/218.html"' },
    
    # Menu headers
    @{ Old = '>Natural Food Products<'; New = '>Room and Wall Art<' },
    @{ Old = '>Ayurvedic Medicine<'; New = '>Art and Craft<' },
    @{ Old = '>Herbal Home Care<'; New = '>Mandala Art<' }
)

$fixedCount = 0

foreach ($file in $htmlFiles) {
    $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
    $originalContent = $content
    
    foreach ($replacement in $replacements) {
        $content = $content -replace [regex]::Escape($replacement.Old), $replacement.New
    }
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        $fixedCount++
        Write-Host "Fixed: $($file.FullName.Replace($basePath, ''))" -ForegroundColor Yellow
    }
}

Write-Host "`n===================================" -ForegroundColor Green
Write-Host "Navigation Fix Complete!" -ForegroundColor Green
Write-Host "Total files fixed: $fixedCount" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green
