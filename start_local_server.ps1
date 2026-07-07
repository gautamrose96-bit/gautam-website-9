# Simple HTTP Server for Local Website Preview
# This starts a lightweight server so you can view the website in any browser

$websitePath = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net"
$port = 8080

Write-Host "==========================================" -ForegroundColor Green
Write-Host "Starting Local Website Server" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Website URL: http://localhost:$port" -ForegroundColor Cyan
Write-Host ""
Write-Host "To view your website:" -ForegroundColor Yellow
Write-Host "  1. Open any web browser" -ForegroundColor White
Write-Host "  2. Go to: http://localhost:$port" -ForegroundColor White
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Red
Write-Host "==========================================" -ForegroundColor Green

# Change to the website directory and start Python HTTP server
Set-Location -Path $websitePath
try {
    python -m http.server $port
} catch {
    Write-Host "Python not found. Trying with PowerShell..." -ForegroundColor Yellow
    # Fallback to PowerShell HTTP listener (simpler)
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add("http://localhost:$port/")
    $listener.Start()
    Write-Host "Server started at http://localhost:$port" -ForegroundColor Green
    Write-Host "Press Ctrl+C to stop..." -ForegroundColor Yellow
    
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $localPath = Join-Path $websitePath $request.Url.LocalPath.TrimStart('/')
        if (Test-Path $localPath -PathType Container) {
            $localPath = Join-Path $localPath "index.html"
        }
        
        if (Test-Path $localPath) {
            $content = [System.IO.File]::ReadAllBytes($localPath)
            $response.ContentType = "text/html"
            if ($localPath -match '\.css$') { $response.ContentType = "text/css" }
            if ($localPath -match '\.js$') { $response.ContentType = "application/javascript" }
            if ($localPath -match '\.jpg$|\.jpeg$') { $response.ContentType = "image/jpeg" }
            if ($localPath -match '\.png$') { $response.ContentType = "image/png" }
            $response.OutputStream.Write($content, 0, $content.Length)
        } else {
            $response.StatusCode = 404
        }
        $response.Close()
    }
}
