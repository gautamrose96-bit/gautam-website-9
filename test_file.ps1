Start-Sleep 2
try {
    $wc = New-Object System.Net.WebClient
    $result = $wc.DownloadString("http://localhost:8080/product/Healing%20Quotes-32/3343.html")
    if ($result -match "Healing Quotes-32") {
        Write-Host "SUCCESS: File is running correctly!" -ForegroundColor Green
        Write-Host "File size: $($result.Length) characters"
    } else {
        Write-Host "ERROR: File content not correct" -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
}
