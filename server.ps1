# Servidor local mínimo para el Observatorio de ventas.
# Permite que el navegador lea el Excel automáticamente. No requiere instalar nada.
# Para detenerlo, cierra esta ventana.

$port = 8765
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

try {
  $listener = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Loopback, $port)
  $listener.Start()
} catch {
  Write-Host "No se pudo iniciar el servidor en el puerto $port. Puede que ya esté en uso." -ForegroundColor Red
  Write-Host "Cierra la otra ventana del dashboard e inténtalo de nuevo."
  Read-Host "Pulsa Enter para salir"
  exit
}

Write-Host "============================================================"
Write-Host "  Observatorio de ventas - servidor local activo"
Write-Host "  URL:  http://localhost:$port/index.html"
Write-Host ""
Write-Host "  El navegador se abrio automaticamente." -ForegroundColor Green
Write-Host "  Cada vez que actualices el Excel, pulsa 'Recargar Excel'" -ForegroundColor Green
Write-Host "  en la pagina (o recarga con F5)." -ForegroundColor Green
Write-Host ""
Write-Host "  PARA CERRAR: cierra esta ventana." -ForegroundColor Yellow
Write-Host "============================================================"

Start-Process "http://localhost:$port/index.html"

while ($true) {
  $client = $listener.AcceptTcpClient()
  try {
    $ns = $client.GetStream()
    $sr = New-Object System.IO.StreamReader($ns)
    $line = $sr.ReadLine()
    if ($line) {
      $parts = $line.Split(' ')
      $url = [Uri]::UnescapeDataString($parts[1]).Split('?')[0]
      if ($url -eq '/') { $url = '/index.html' }
      $path = Join-Path $root ($url.TrimStart('/').Replace('/', '\'))
      if ((Test-Path $path -PathType Leaf) -and ($path.StartsWith($root))) {
        $bytes = [System.IO.File]::ReadAllBytes($path)
        $ext = [System.IO.Path]::GetExtension($path).ToLower()
        switch ($ext) {
          '.html' { $ct = 'text/html; charset=utf-8' }
          '.js'   { $ct = 'application/javascript; charset=utf-8' }
          '.css'  { $ct = 'text/css; charset=utf-8' }
          '.xlsx' { $ct = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }
          default { $ct = 'application/octet-stream' }
        }
        $head = "HTTP/1.1 200 OK`r`nContent-Type: $ct`r`nContent-Length: $($bytes.Length)`r`nCache-Control: no-store`r`nConnection: close`r`n`r`n"
        $hb = [System.Text.Encoding]::ASCII.GetBytes($head)
        $ns.Write($hb, 0, $hb.Length)
        $ns.Write($bytes, 0, $bytes.Length)
      } else {
        $body = [System.Text.Encoding]::UTF8.GetBytes('404 Not Found')
        $head = "HTTP/1.1 404 Not Found`r`nContent-Length: $($body.Length)`r`nConnection: close`r`n`r`n"
        $hb = [System.Text.Encoding]::ASCII.GetBytes($head)
        $ns.Write($hb, 0, $hb.Length)
        $ns.Write($body, 0, $body.Length)
      }
      $ns.Flush()
    }
  } catch {}
  finally { $client.Close() }
}
