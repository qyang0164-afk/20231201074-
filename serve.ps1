$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://127.0.0.1:8000/")
try {
    $listener.Start()
} catch {
    Write-Error $_
    exit 1
}
Write-Host "Preview URL: http://127.0.0.1:8000/"
while ($true) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    $path = Join-Path (Get-Location) "index.html"
    if (-Not (Test-Path $path)) {
        $content = [Text.Encoding]::UTF8.GetBytes("<html><body><h1>index.html not found</h1></body></html>")
        $response.ContentType = "text/html; charset=utf-8"
        $response.ContentLength64 = $content.Length
        $response.OutputStream.Write($content, 0, $content.Length)
        $response.OutputStream.Close()
        continue
    }

    $bytes = [System.IO.File]::ReadAllBytes($path)
    $response.ContentType = "text/html; charset=utf-8"
    $response.ContentLength64 = $bytes.Length
    $response.OutputStream.Write($bytes, 0, $bytes.Length)
    $response.OutputStream.Close()
}