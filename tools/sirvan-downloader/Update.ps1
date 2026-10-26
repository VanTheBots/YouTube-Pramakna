$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'
$bin = Join-Path $PSScriptRoot 'bin'
New-Item -ItemType Directory -Path $bin -Force | Out-Null
$temp = Join-Path $bin ([guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $temp | Out-Null
try {
    # Resolve a release once so the executable and checksum always share one version.
    $release = Invoke-WebRequest -UseBasicParsing -Uri 'https://github.com/yt-dlp/yt-dlp/releases/latest' -TimeoutSec 60
    $releaseUrl = if ($release.BaseResponse.ResponseUri) { $release.BaseResponse.ResponseUri.AbsoluteUri } else { $release.BaseResponse.RequestMessage.RequestUri.AbsoluteUri }
    if ($releaseUrl -notmatch '/yt-dlp/yt-dlp/releases/tag/([A-Za-z0-9._-]+)$') { throw 'Tidak bisa membaca versi rilis resmi. Coba lagi nanti.' }
    $tag = $Matches[1]
    $base = "https://github.com/yt-dlp/yt-dlp/releases/download/$tag"
    $sumFile = Join-Path $temp 'SHA2-256SUMS'
    $exeFile = Join-Path $temp 'yt-dlp.exe'
    Write-Output "Mengunduh yt-dlp $tag dari GitHub resmi..."
    Invoke-WebRequest -UseBasicParsing -Uri "$base/SHA2-256SUMS" -OutFile $sumFile -TimeoutSec 90
    Invoke-WebRequest -UseBasicParsing -Uri "$base/yt-dlp.exe" -OutFile $exeFile -TimeoutSec 300
    $match = [regex]::Match([IO.File]::ReadAllText($sumFile), '(?m)^([a-fA-F0-9]{64})\s+\*?yt-dlp\.exe\s*$')
    if (-not $match.Success) { throw 'Checksum resmi tidak ditemukan. Instalasi dihentikan.' }
    if ((Get-FileHash -LiteralPath $exeFile -Algorithm SHA256).Hash -ne $match.Groups[1].Value) { throw 'Verifikasi file gagal. File tidak dipasang.' }
    $version = & $exeFile --version
    if ($LASTEXITCODE -ne 0) { throw 'Mesin pengunduh tidak dapat dijalankan pada Windows ini.' }
    Move-Item -LiteralPath $exeFile -Destination (Join-Path $bin 'yt-dlp.exe') -Force
    Write-Output "Siap. Versi $version; SHA256 cocok dengan rilis resmi."
} finally {
    Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue
}
