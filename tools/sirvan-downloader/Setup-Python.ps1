$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'
function Find-Python {
    $candidates = @((Join-Path $env:LOCALAPPDATA 'Programs\Python\Python314\python.exe'))
    foreach ($hive in @('HKCU:\Software\Python\PythonCore','HKLM:\Software\Python\PythonCore')) {
        if (Test-Path $hive) {
            foreach ($key in Get-ChildItem $hive) {
                $ip = Join-Path $key.PSPath 'InstallPath'
                if (Test-Path $ip) {
                    $reg = Get-Item $ip
                    $candidate = $reg.GetValue('ExecutablePath')
                    if (-not $candidate -and $reg.GetValue('')) { $candidate = Join-Path $reg.GetValue('') 'python.exe' }
                    if ($candidate) { $candidates += $candidate }
                }
            }
        }
    }
    foreach ($candidate in ($candidates | Select-Object -Unique)) {
        if (-not (Test-Path -LiteralPath $candidate)) { continue }
        $sig = Get-AuthenticodeSignature -LiteralPath $candidate
        if ($sig.Status -ne 'Valid' -or $sig.SignerCertificate.Subject -notmatch 'O=Python Software Foundation(?:,|$)') { continue }
        try {
            & $candidate -I -c 'import sys,struct; sys.exit(0 if sys.version_info >= (3,10) and sys.maxsize > 2**32 else 1)' | Out-Null
            if ($LASTEXITCODE -eq 0) { return $candidate }
        } catch { continue }
    }
    return $null
}
$python = Find-Python
if (-not $python) {
    $temp = Join-Path $env:TEMP ('SirVanPython-' + [guid]::NewGuid().ToString())
    New-Item -ItemType Directory -Path $temp | Out-Null
    try {
        $installer = Join-Path $temp 'python-3.14.7-amd64.exe'
        Write-Output 'Mengunduh pemasang Python resmi. Ini bisa memerlukan beberapa menit...'
        Invoke-WebRequest -UseBasicParsing -Uri 'https://www.python.org/ftp/python/3.14.7/python-3.14.7-amd64.exe' -OutFile $installer -TimeoutSec 300
        # SHA256 from Microsoft's winget manifest for Python.Python.3.14 3.14.7, x64.
        $expected = '9D9EB2709EF81BF5CD30DB3C2096BDBC4EA10087C22E62F27D356B36F6AE9649'
        if ((Get-FileHash -LiteralPath $installer -Algorithm SHA256).Hash -ne $expected) { throw 'Checksum pemasang Python tidak cocok. Instalasi dihentikan.' }
        $signature = Get-AuthenticodeSignature -LiteralPath $installer
        if ($signature.Status -ne 'Valid' -or $signature.SignerCertificate.Subject -notmatch 'O=Python Software Foundation(?:,|$)') { throw 'Tanda tangan Python tidak valid. Instalasi dihentikan.' }
        Write-Output 'Tanda tangan Python valid. Memasang untuk pengguna ini...'
        $installLog = Join-Path $PSScriptRoot 'python-install.log'
        $arguments = '/passive InstallAllUsers=0 PrependPath=0 Include_launcher=0 Include_test=0 Include_doc=0 Include_pip=1 /log "' + $installLog + '"'
        $proc = Start-Process -FilePath $installer -ArgumentList $arguments -PassThru -Wait
        if ($proc.ExitCode -notin @(0,3010)) { throw "Pemasangan Python gagal (kode $($proc.ExitCode)). Lihat python-install.log." }
        $python = Find-Python
        if (-not $python) { throw 'Python belum dapat dijalankan. Jika Windows memblokirnya, jangan ubah perlindungan; kirim screenshot pesan.' }
    } finally { Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue }
}
$venv = Join-Path $PSScriptRoot 'venv'
$venvPython = Join-Path $venv 'Scripts\python.exe'
if (-not (Test-Path -LiteralPath $venvPython)) {
    Write-Output 'Menyiapkan lingkungan aplikasi...'
    & $python -I -m venv $venv
    if ($LASTEXITCODE -ne 0) { throw 'Gagal menyiapkan lingkungan Python aplikasi.' }
}
& $venvPython -I -c 'import sys; print(sys.version.split()[0])'
if ($LASTEXITCODE -ne 0) { throw 'Python aplikasi diblokir atau gagal dijalankan. Kirim pesan ini untuk diperiksa.' }
