$p = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net"
$count = 0
Get-ChildItem $p -Recurse -Filter *.html | Where-Object { $_.FullName -notmatch 'waste submenu' } | ForEach-Object {
    if (Select-String -Path $_.FullName -Pattern 'patanjali|ayurvedic|natural-food-products' -Quiet) { $count++ }
}
Write-Host "Files with old refs remaining: $count"
