# Pass 2: Fix related products, share links, social media, visible Patanjali text
$ErrorActionPreference = "Continue"
$mainSite = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net"
$stats = @{ Fixed = 0; Errors = 0 }

function Convert-SlugToArtName([string]$slug) {
    $clean = ($slug -replace '^(?i)(patanjali|divya)-', '') -replace '-', ' '
    return "Wall Art " + (Get-Culture).TextInfo.ToTitleCase($clean)
}

$htmlFiles = Get-ChildItem $mainSite -Recurse -Filter "*.html" | Where-Object { $_.FullName -notmatch 'waste submenu' }

Write-Host "Pass 2: Fixing related products, shares, social links..." -ForegroundColor Cyan
Write-Host "Processing $($htmlFiles.Count) files..." -ForegroundColor Yellow

foreach ($file in $htmlFiles) {
    try {
        $content = [System.IO.File]::ReadAllText($file.FullName)
        $original = $content

        # Social media links sitewide
        $content = $content -replace 'https://www\.instagram\.com/patanjaliproducts', 'https://www.instagram.com/gautamrose'
        $content = $content -replace 'https://www\.youtube\.com/user/patanjaliayurveda', 'https://www.youtube.com/@gautamrose'
        $content = $content -replace 'https://www\.facebook\.com/patanjaliayurved', 'https://www.facebook.com/gautamrose'

        # Product-name links in related products section
        $content = [regex]::Replace($content, 'class="product-name">Patanjali ([^<]+)</a>', {
            param($m)
            $artName = Convert-SlugToArtName ($m.Groups[1].Value -replace '\s+', '-' -replace '(?i)^unpolished-', 'unpolished-')
            if ($m.Groups[1].Value -notmatch '-') {
                $artName = "Wall Art " + $m.Groups[1].Value.Trim()
            }
            "class=`"product-name`">$artName</a>"
        })

        $content = $content -replace 'class="product-name">Patanjali ([^<]+)</a>', 'class="product-name">Wall Art $1</a>'
        $content = $content -replace 'class="product-name">Divya ([^<]+)</a>', 'class="product-name">Art Craft $1</a>'

        # Generic visible Patanjali/Divya product names (not in URLs/comments only)
        $content = $content -replace '>Patanjali Unpolished ([^<]+)<', '>Wall Art $1<'
        $content = $content -replace '>Patanjali ([A-Z][^<]{3,60})<', '>Wall Art $1<'
        $content = $content -replace '>DIVYA ([^<]+)<', '>Art $1<'
        $content = $content -replace '>Divya ([^<]+)<', '>Art $1<'

        # Facebook share URLs with Patanjali in title param
        $content = $content -replace 'Patanjali%2B[^&%]+', 'Gautam%20Rose%20Wall%20Art'
        $content = $content -replace 'Patanjali\+[^&]+', 'Gautam+Rose+Wall+Art'

        # Remove Google Patanjali remarketing comment block (cosmetic)
        $content = $content -replace '(?s)<!-- Google Code for Patanjali_Ayurved_Remarketing -->.*?<!-- End Google Code for Patanjali.*?Remarketing.*?-->', '<!-- Gautam Rose Art Gallery -->'
        $content = $content -replace '<!-- Google Code for Patanjali_Ayurved_Remarketing -->', '<!-- Gautam Rose Art Gallery -->'

        # Category link fix
        $content = $content -replace 'category/patanjali-publication/', 'category/gautam rose publication/'

        # Fix alt text still saying patanjali in banners
        $content = $content -replace 'alt="patanjali[^"]*"', 'alt="gautam rose art products"'

        if ($content -ne $original) {
            [System.IO.File]::WriteAllText($file.FullName, $content)
            $stats.Fixed++
        }
    }
    catch { $stats.Errors++ }
}

Write-Host "Pass 2 complete: $($stats.Fixed) files updated, $($stats.Errors) errors" -ForegroundColor Green
