# Bundle GCC (MinGW-w64) for Tlang installation (Windows)
# This script bundles GCC compiler for Windows distribution

param(
    [Parameter(Mandatory=$false)]
    [string]$BundleDir = ".\bundled-gcc",
    
    [Parameter(Mandatory=$false)]
    [string]$Architecture = "x64"
)

Write-Host "=== Bundling GCC (MinGW-w64) for Windows ===" -ForegroundColor Cyan
Write-Host "Target directory: $BundleDir" -ForegroundColor Green
Write-Host "Architecture: $Architecture" -ForegroundColor Green
Write-Host ""

# Create bundle directory structure
$binDir = Join-Path $BundleDir "bin"
$libDir = Join-Path $BundleDir "lib"
$includeDir = Join-Path $BundleDir "include"
$libexecDir = Join-Path $BundleDir "libexec"

New-Item -ItemType Directory -Force -Path $binDir | Out-Null
New-Item -ItemType Directory -Force -Path $libDir | Out-Null
New-Item -ItemType Directory -Force -Path $includeDir | Out-Null
New-Item -ItemType Directory -Force -Path $libexecDir | Out-Null

# Check for MinGW/MinGW-w64 in common locations
# C:\MinGW\bin contains gcc.exe, g++.exe, etc.
$mingwPaths = @(
    "C:\MinGW",
    "C:\mingw",
    "C:\mingw64",
    "C:\msys64\mingw64",
    "C:\Program Files\mingw-w64",
    "C:\Program Files\MinGW",
    "$env:ProgramFiles\mingw-w64",
    "$env:ProgramFiles\MinGW",
    "$env:LOCALAPPDATA\Programs\mingw-w64",
    "C:\tools\mingw64"
)
# Optional: TLANG_MINGW_PATH env var overrides search (e.g. $env:TLANG_MINGW_PATH = "D:\tools\mingw")
if ($env:TLANG_MINGW_PATH -and (Test-Path "$env:TLANG_MINGW_PATH\bin\gcc.exe")) {
    $mingwPaths = @($env:TLANG_MINGW_PATH) + $mingwPaths
}

# Also check if gcc is in PATH and find its location
$gccInPath = Get-Command gcc -ErrorAction SilentlyContinue
if ($gccInPath) {
    $gccPath = Split-Path -Parent $gccInPath.Source
    $mingwRoot = $gccPath
    # Try to find the root (go up until we find mingw64 or similar)
    while ($mingwRoot -and -not (Test-Path (Join-Path $mingwRoot "bin\gcc.exe"))) {
        $parent = Split-Path -Parent $mingwRoot
        if ($parent -eq $mingwRoot) { break }
        $mingwRoot = $parent
    }
    if ($mingwRoot -and (Test-Path (Join-Path $mingwRoot "bin\gcc.exe"))) {
        $mingwPaths = @($mingwRoot) + $mingwPaths
    }
}

$mingwFound = $false
$mingwPath = ""

foreach ($path in $mingwPaths) {
    if (Test-Path "$path\bin\gcc.exe") {
        Write-Host "Found MinGW-w64 at: $path" -ForegroundColor Green
        $mingwPath = $path
        $mingwFound = $true
        break
    }
}

if (-not $mingwFound) {
    Write-Host "MinGW-w64 not found in common locations." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Options to get MinGW-w64:" -ForegroundColor Yellow
    Write-Host "  1. Download from: https://www.mingw-w64.org/downloads/" -ForegroundColor Yellow
    Write-Host "  2. Or use MSYS2: https://www.msys2.org/" -ForegroundColor Yellow
    Write-Host "  3. Or use Chocolatey: choco install mingw" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "For automated download, we can use WinLibs:" -ForegroundColor Cyan
    Write-Host "  https://winlibs.com/" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host ""
    Write-Host "GCC bundling is optional but recommended for Windows." -ForegroundColor Yellow
    Write-Host "Without bundled GCC, users must install MinGW-w64 separately." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "Would you like to download MinGW-w64 automatically?" -ForegroundColor Cyan
    Write-Host "  [Y]es - Download and bundle GCC (recommended, ~100MB download)" -ForegroundColor Green
    Write-Host "  [N]o  - Skip GCC bundling (you'll need to install GCC separately)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Default: Yes (auto-proceeds in 10 seconds if no input)" -ForegroundColor Gray
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
    # Use Read-Host with a simple approach - PowerShell doesn't support timeout natively
    # So we'll use a job with timeout
    $job = Start-Job -ScriptBlock {
        $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    $timeout = 10
    $response = ""
    if (Wait-Job $job -Timeout $timeout) {
        $key = Receive-Job $job
        Stop-Job $job
        Remove-Job $job
        if ($key.Character -eq "y" -or $key.Character -eq "Y") {
            $response = "y"
            Write-Host "y" -ForegroundColor Green
        } elseif ($key.Character -eq "n" -or $key.Character -eq "N") {
            $response = "n"
            Write-Host "n" -ForegroundColor Yellow
        } else {
            $response = "y"  # Default to yes for Enter or other keys
            Write-Host "y (auto-selected)" -ForegroundColor Green
        }
    } else {
        Stop-Job $job -ErrorAction SilentlyContinue
        Remove-Job $job -ErrorAction SilentlyContinue
        $response = "y"  # Default to yes after timeout
        Write-Host "y (auto-selected after timeout)" -ForegroundColor Green
    }
    if ($response -eq "y" -or $response -eq "Y" -or [string]::IsNullOrEmpty($response)) {
        Write-Host ""
        Write-Host "Downloading MinGW-w64 from WinLibs..." -ForegroundColor Cyan
        Write-Host "Note: This is a large download (~100MB). Please be patient." -ForegroundColor Yellow
        Write-Host ""
        
        # Download MinGW-w64 portable (latest release from WinLibs)
        # Using a stable version URL - update this if needed
        $downloadUrl = "https://github.com/brechtsanders/winlibs_mingw/releases/download/13.2.0-16.0.6-11.0.0-ucrt-r1/winlibs-x86_64-posix-seh-gcc-13.2.0-mingw-w64ucrt-11.0.0-r1.zip"
        $zipFile = Join-Path $env:TEMP "mingw-w64.zip"
        
        try {
            Write-Host "Downloading from: $downloadUrl" -ForegroundColor Cyan
            Write-Host "This may take a few minutes (~100MB download)..." -ForegroundColor Yellow
            Write-Host ""
            # Show progress bar during download
            try {
                $ProgressPreference = 'Continue'  # Show progress bar
                $webClient = New-Object System.Net.WebClient
                $webClient.DownloadFile($downloadUrl, $zipFile)
                Write-Host ""
                Write-Host "✓ Download complete!" -ForegroundColor Green
            } catch {
                Write-Host ""
                Write-Host "Error downloading MinGW-w64: $_" -ForegroundColor Red
                throw
            } finally {
                if ($webClient) { $webClient.Dispose() }
            }
            
            Write-Host ""
            Write-Host "Extracting MinGW-w64 (this may take a few minutes)..." -ForegroundColor Cyan
            $extractDir = Join-Path $env:TEMP "mingw-w64-extract"
            if (Test-Path $extractDir) {
                Remove-Item -Recurse -Force $extractDir -ErrorAction SilentlyContinue
            }
            # Show progress during extraction
            $ProgressPreference = 'Continue'
            Expand-Archive -Path $zipFile -DestinationPath $extractDir -Force
            Write-Host "✓ Extraction complete!" -ForegroundColor Green
            
            # Find the mingw64 directory in the extracted files
            $extractedMingw = Get-ChildItem -Path $extractDir -Recurse -Directory -Filter "mingw64" | Select-Object -First 1
            if ($extractedMingw -and (Test-Path (Join-Path $extractedMingw.FullName "bin\gcc.exe"))) {
                $mingwPath = $extractedMingw.FullName
                $mingwFound = $true
                Write-Host "Found MinGW-w64 in downloaded archive" -ForegroundColor Green
            } else {
                # Try to find any directory with gcc.exe
                $gccDir = Get-ChildItem -Path $extractDir -Recurse -File -Filter "gcc.exe" | Select-Object -First 1
                if ($gccDir) {
                    $mingwPath = Split-Path -Parent (Split-Path -Parent $gccDir.FullName)
                    $mingwFound = $true
                    Write-Host "Found MinGW-w64 in downloaded archive" -ForegroundColor Green
                }
            }
            
            # Cleanup
            Remove-Item $zipFile -Force -ErrorAction SilentlyContinue
            Remove-Item -Recurse -Force $extractDir -ErrorAction SilentlyContinue
        } catch {
            Write-Host "Error downloading MinGW-w64: $_" -ForegroundColor Red
            Write-Host ""
            Write-Host "Please install MinGW-w64 manually:" -ForegroundColor Yellow
            Write-Host "  1. Download from: https://winlibs.com/" -ForegroundColor Yellow
            Write-Host "  2. Extract to: C:\mingw64" -ForegroundColor Yellow
            Write-Host "  3. Run this script again" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "Or skip GCC bundling (users will need to install GCC separately)" -ForegroundColor Yellow
            exit 0  # Exit with 0 to allow installation to continue
        }
    } else {
        Write-Host "Skipping GCC bundling. Installation will require GCC to be in PATH." -ForegroundColor Yellow
        Write-Host "Users can install MinGW-w64 separately or use MSVC." -ForegroundColor Yellow
        exit 0  # Exit with 0 to allow installation to continue
    }
}

if (-not $mingwFound) {
    Write-Host "Error: Could not find or download MinGW-w64" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Copying GCC binaries..." -ForegroundColor Cyan

# Essential binaries to copy
$essentialBinaries = @(
    "gcc.exe",
    "g++.exe",
    "ar.exe",
    "as.exe",
    "ld.exe",
    "objcopy.exe",
    "objdump.exe",
    "ranlib.exe",
    "strip.exe",
    "windres.exe"
)

$binSource = Join-Path $mingwPath "bin"
foreach ($binary in $essentialBinaries) {
    $sourceFile = Join-Path $binSource $binary
    if (Test-Path $sourceFile) {
        Copy-Item $sourceFile -Destination $binDir -Force
        Write-Host "  - $binary" -ForegroundColor Gray
    }
}

# Copy required DLLs (these are usually in the bin directory)
Write-Host "Copying required DLLs..." -ForegroundColor Cyan
$dlls = Get-ChildItem -Path $binSource -Filter "*.dll" -ErrorAction SilentlyContinue
foreach ($dll in $dlls) {
    Copy-Item $dll.FullName -Destination $binDir -Force
    Write-Host "  - $($dll.Name)" -ForegroundColor Gray
}

# Copy libgcc and other essential libraries
Write-Host "Copying essential libraries..." -ForegroundColor Cyan
$libSource = Join-Path $mingwPath "lib"
if (Test-Path $libSource) {
    # Copy libgcc, libstdc++, and other essential libs
    $essentialLibs = @(
        "libgcc*.a",
        "libstdc++*.a",
        "libgcc_s*.dll",
        "libstdc++*.dll",
        "libwinpthread*.dll",
        "libwinpthread*.a"
    )
    
    foreach ($libPattern in $essentialLibs) {
        $libs = Get-ChildItem -Path $libSource -Filter $libPattern -ErrorAction SilentlyContinue
        foreach ($lib in $libs) {
            Copy-Item $lib.FullName -Destination $libDir -Force
            Write-Host "  - $($lib.Name)" -ForegroundColor Gray
        }
    }
}

# Copy essential headers (minimal set)
Write-Host "Copying essential headers..." -ForegroundColor Cyan
$includeSource = Join-Path $mingwPath "include"
if (Test-Path $includeSource) {
    # Copy only essential header directories to keep size down
    $essentialIncludes = @(
        "stdio.h",
        "stdlib.h",
        "string.h",
        "stddef.h",
        "stdint.h",
        "limits.h",
        "float.h",
        "math.h"
    )
    
    # Create include directory structure
    foreach ($header in $essentialIncludes) {
        $headerPath = Join-Path $includeSource $header
        if (Test-Path $headerPath) {
            Copy-Item $headerPath -Destination $includeDir -Force
        }
    }
    
    # Copy sys directory if it exists (for basic system headers)
    if (Test-Path (Join-Path $includeSource "sys")) {
        $sysDir = Join-Path $includeDir "sys"
        New-Item -ItemType Directory -Force -Path $sysDir | Out-Null
        Copy-Item (Join-Path $includeSource "sys\*") -Destination $sysDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Verify bundled files
Write-Host ""
Write-Host "Bundled GCC files:" -ForegroundColor Cyan
Write-Host "  Binaries: $((Get-ChildItem $binDir).Count) files" -ForegroundColor Gray
Write-Host "  Libraries: $((Get-ChildItem $libDir -ErrorAction SilentlyContinue).Count) files" -ForegroundColor Gray
Write-Host "  Headers: $((Get-ChildItem $includeDir -Recurse -ErrorAction SilentlyContinue).Count) files" -ForegroundColor Gray

# Test if bundled GCC works
$bundledGcc = Join-Path $binDir "gcc.exe"
if (Test-Path $bundledGcc) {
    Write-Host ""
    Write-Host "Testing bundled GCC..." -ForegroundColor Cyan
    $gccVersion = & $bundledGcc --version 2>&1 | Select-Object -First 1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  $gccVersion" -ForegroundColor Green
        Write-Host "  GCC is working!" -ForegroundColor Green
    } else {
        Write-Host "  Warning: Could not verify GCC version" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=== GCC Bundling Complete ===" -ForegroundColor Green
Write-Host "Bundle directory: $BundleDir" -ForegroundColor Green
Write-Host ""
Write-Host "Note: This is a minimal GCC bundle. For full functionality," -ForegroundColor Yellow
Write-Host "      users may need to install the complete MinGW-w64 package." -ForegroundColor Yellow
