# Pass 3: Clean up related product display names (remove food/dal terms)
$mainSite = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net"
$foodTerms = @('Unpolished','Dal','Pulses','Masur','Moong','Chana','Urad','Rajma','Chilka','Dhuli','Juice','Churna','Ghanvati','Vati','Tablet','Capsule','Oil','Ghee','Honey','Chyawanprash','Detergent','Dish Wash','Scrub','Hand Wash','Toilet','Combo','Coronil','Swasari','Kwath','Bhasma','Syrup','Pishti')
$fixed = 0

Get-ChildItem $mainSite -Recurse -Filter *.html | Where-Object { $_.FullName -notmatch 'waste submenu' } | ForEach-Object {
    $content = [System.IO.File]::ReadAllText($_.FullName)
    $orig = $content

    # Related products: use file ID from href for clean art name
    $content = [regex]::Replace($content, 'href="\.\./([^/"]+)/(\d+)\.html"\s+class="product-name">[^<]+</a>', {
        param($m)
        $id = $m.Groups[2].Value
        "href=`"../$($m.Groups[1].Value)/$id.html`" class=`"product-name`">Wall Art Piece $id</a>"
    })

    foreach ($term in $foodTerms) {
        $content = $content -replace "Wall Art $term\s*", 'Wall Art '
        $content = $content -replace ">Wall Art ([^<]*$term[^<]*)<", '>Wall Art Decor<'
    }

    $content = $content -replace 'class="product-name">Wall Art\s+</a>', 'class="product-name">Wall Art Decor</a>'
    $content = $content -replace 'class="product-name">Art Craft\s+</a>', 'class="product-name">Art Craft Decor</a>'

    # Size options: dal weights -> art sizes
    $content = $content -replace '<option[^>]*>\s*500gm\s*</option>', '<option>Small Size</option>'
    $content = $content -replace '<option[^>]*>\s*1kg\s*</option>', '<option>Large Size</option>'
    $content = $content -replace '<option[^>]*>\s*250gm\s*</option>', '<option>Medium Size</option>'

    if ($content -ne $orig) {
        [System.IO.File]::WriteAllText($_.FullName, $content)
        $fixed++
    }
}
Write-Host "Pass 3: Cleaned $fixed files" -ForegroundColor Green
