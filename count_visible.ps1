$p = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net"
$visible = 0
$total = 0
Get-ChildItem $p -Recurse -Filter *.html | Where-Object { $_.FullName -notmatch 'waste submenu' } | ForEach-Object {
    $lines = Get-Content $_.FullName
    foreach ($line in $lines) {
        if ($line -match '(?i)patanjali|ayurvedic|natural-food') {
            $total++
            if ($line -notmatch 'Mirrored from|HTTrack|<!--' -and $line -notmatch 'patanjali-[a-z]') {
                $visible++
            }
        }
    }
}
Write-Host "Total patanjali lines: $total"
Write-Host "Visible (non-comment, non-folder-path): $visible"
