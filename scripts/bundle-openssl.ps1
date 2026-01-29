# Bundle OpenSSL libraries for Tlang installation (Windows)
# This script bundles OpenSSL libraries for Windows distribution

param(
    [Parameter(Mandatory=$false)]
    [string]$BundleDir = ".\bundled-openssl",
    
    [Parameter(Mandatory=$false)]
    [string]$Architecture = "x64"
)

Write-Host "=== Bundling OpenSSL Libraries (Windows) ===" -ForegroundColor Cyan
Write-Host "Target directory: $BundleDir" -ForegroundColor Green
Write-Host "Architecture: $Architecture" -ForegroundColor Green
Write-Host ""

# Create bundle directory
$libDir = Join-Path $BundleDir "lib"
$includeDir = Join-Path $BundleDir "include"
$binDir = Join-Path $BundleDir "bin"

New-Item -ItemType Directory -Force -Path $libDir | Out-Null
New-Item -ItemType Directory -Force -Path $includeDir | Out-Null
New-Item -ItemType Directory -Force -Path $binDir | Out-Null

# Check for OpenSSL in common locations
$opensslPaths = @(
    "C:\OpenSSL-Win64",
    "C:\Program Files\OpenSSL-Win64",
    "C:\OpenSSL",
    "$env:ProgramFiles\OpenSSL",
    "$env:VCPKG_ROOT\installed\$Architecture-windows"
)

$opensslFound = $false
$opensslPath = ""

foreach ($path in $opensslPaths) {
    if (Test-Path "$path\lib\libssl.lib") {
        Write-Host "Found OpenSSL at: $path" -ForegroundColor Green
        $opensslPath = $path
        $opensslFound = $true
        break
    }
}

if (-not $opensslFound) {
    Write-Host "Error: OpenSSL not found in common locations" -ForegroundColor Red
    Write-Host "Please install OpenSSL:" -ForegroundColor Yellow
    Write-Host "  1. Download from: https://slproweb.com/products/Win32OpenSSL.html" -ForegroundColor Yellow
    Write-Host "  2. Install to: C:\OpenSSL-Win64" -ForegroundColor Yellow
    Write-Host "  3. Or use vcpkg: vcpkg install openssl:$Architecture-windows" -ForegroundColor Yellow
    exit 1
}

# Copy libraries
Write-Host "Copying OpenSSL libraries..." -ForegroundColor Cyan
if (Test-Path "$opensslPath\lib\libssl.lib") {
    Copy-Item "$opensslPath\lib\libssl.lib" -Destination $libDir -Force
    Copy-Item "$opensslPath\lib\libcrypto.lib" -Destination $libDir -Force
    Write-Host "  - Static libraries copied" -ForegroundColor Green
}

# Copy DLLs if available
if (Test-Path "$opensslPath\bin\libssl-*.dll") {
    $dlls = Get-ChildItem "$opensslPath\bin\libssl-*.dll"
    foreach ($dll in $dlls) {
        Copy-Item $dll.FullName -Destination $binDir -Force
    }
    $dlls = Get-ChildItem "$opensslPath\bin\libcrypto-*.dll"
    foreach ($dll in $dlls) {
        Copy-Item $dll.FullName -Destination $binDir -Force
    }
    Write-Host "  - DLLs copied" -ForegroundColor Green
}

# Copy headers
Write-Host "Copying OpenSSL headers..." -ForegroundColor Cyan
if (Test-Path "$opensslPath\include\openssl") {
    Copy-Item "$opensslPath\include\openssl" -Destination $includeDir -Recurse -Force
    Write-Host "  - Headers copied" -ForegroundColor Green
}

# Verify bundled files
Write-Host ""
Write-Host "Bundled files:" -ForegroundColor Cyan
Get-ChildItem $libDir | ForEach-Object {
    Write-Host "  - $($_.Name)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "=== OpenSSL Bundling Complete ===" -ForegroundColor Green
Write-Host "Bundle directory: $BundleDir" -ForegroundColor Green
