$source = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net\product\Healing Quotes-1\3352.html"
$target = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net\product\Healing Quotes-32\3343.html"
$content = Get-Content -Path $source -Raw
$content = $content -replace "Healing Quotes-1", "Healing Quotes-32"
$content = $content -replace "Healing Quotes-one", "Healing Quotes-32"
$content = $content -replace "3352", "3343"
Set-Content -Path $target -Value $content -Encoding UTF8
Write-Host "File copied and fixed"
