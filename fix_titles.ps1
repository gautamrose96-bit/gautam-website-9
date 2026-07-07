$food = 'Unpolished|Urad|Dal|Pulses|Masur|Moong|Chana|Chilka|Dhuli|Rajma|Chyawanprash|Ghanvati|Churna|Juice|Ghee|Honey|Detergent|Coronil|Swasari|Mustard|Tablet|Capsule|Kwath|Bhasma|Medohar|Madhu|Lipidom'
$n = 0
Get-ChildItem "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net" -Recurse -Filter *.html | ForEach-Object {
    $c = [IO.File]::ReadAllText($_.FullName)
    if ($c -match "<title>[^<]*($food)[^<]*</title>") {
        $id = $_.BaseName
        $parent = $_.Directory.Parent.Name
        $t = "$parent - Wall Art $id | gautamrose.net"
        $c2 = $c -replace '(?s)<title>[^<]*</title>', "<title>$t</title>"
        if ($c2 -ne $c) { [IO.File]::WriteAllText($_.FullName, $c2); $n++ }
    }
}
Write-Host "Fixed $n titles"
