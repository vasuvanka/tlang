# Tlang Installation Script for Windows
# Run from repo: powershell -ExecutionPolicy Bypass -File install.ps1
# Single-link:   iwr -useb https://raw.githubusercontent.com/vasuvanka/tlang/main/install.ps1 | iex

# Bootstrap: if not run from repo, clone and re-run install.ps1 from clone
if (-not (Test-Path "Cargo.toml") -or -not (Test-Path "install.ps1")) {
    $RepoUrl = if ($env:TLANG_REPO_URL) { $env:TLANG_REPO_URL } else { "https://github.com/vasuvanka/tlang.git" }
    $Branch = if ($env:TLANG_BRANCH) { $env:TLANG_BRANCH } else { "main" }
    $CloneDir = Join-Path $env:TEMP "tlang-install-$PID"
    Write-Host "=== Tlang single-link install ===" -ForegroundColor Cyan
    Write-Host "Cloning $RepoUrl (branch: $Branch)..." -ForegroundColor Gray
    $git = Get-Command git -ErrorAction SilentlyContinue
    if (-not $git) {
        Write-Host "Error: git is required. Install Git for Windows and try again." -ForegroundColor Red
        exit 1
    }
    & git clone --depth 1 --branch $Branch $RepoUrl $CloneDir
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    Set-Location $CloneDir
    & "$CloneDir\install.ps1" @args
    exit $LASTEXITCODE
}

Write-Host "=== Tlang Installation Script ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will:" -ForegroundColor Cyan
Write-Host "  1. Clean any existing Tlang installation" -ForegroundColor Gray
Write-Host "  2. Bundle GCC compiler (Windows only)" -ForegroundColor Gray
Write-Host "  3. Bundle OpenSSL libraries" -ForegroundColor Gray
Write-Host "  4. Build Tlang compiler from source" -ForegroundColor Gray
Write-Host "  5. Install binaries and create wrapper script" -ForegroundColor Gray
Write-Host "  6. Configure PATH (if needed)" -ForegroundColor Gray
Write-Host ""

# Detect installation directory
# Default to user directory (no admin required)
# Use SYSTEM_INSTALL=1 for system-wide installation to ProgramFiles
if ($env:SYSTEM_INSTALL -eq "1") {
    $InstallDir = $env:ProgramFiles
    if (-not (Test-Path $InstallDir)) {
        $InstallDir = "$env:LOCALAPPDATA\Programs"
    }
    
    # All Tlang executables go to tlang/bin for better organization
    $TlangBinDir = "$InstallDir\tlang\bin"
    # Wrapper script goes to standard bin for PATH access
    $WrapperBinDir = "$InstallDir\bin"
    $TlangBin = "$TlangBinDir\tlangc.exe"
    $TlangWrapper = "$WrapperBinDir\tlang.ps1"
    
    # Check for admin privileges ONCE at the beginning
    # All admin operations will be done in this single elevated session
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        Write-Host "Note: Installing to $InstallDir requires administrator privileges." -ForegroundColor Yellow
        Write-Host "To install to user directory, run: ./install.ps1 (without SYSTEM_INSTALL)" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "This script will request admin privileges ONCE for the entire installation." -ForegroundColor Cyan
        Write-Host "All operations (bundling, copying files, etc.) will run in the same elevated session." -ForegroundColor Cyan
        Write-Host ""
        $response = Read-Host "Continue with admin privileges? (y/n)"
        if ($response -ne "y" -and $response -ne "Y") {
            Write-Host "Installation cancelled." -ForegroundColor Yellow
            exit 1
        }
        # Request elevation - this will restart the script with admin privileges
        # All subsequent operations will run in this elevated session
        Write-Host ""
        Write-Host "Requesting administrator privileges..." -ForegroundColor Cyan
        Write-Host "A new PowerShell window will open. Please approve the UAC prompt ONCE." -ForegroundColor Yellow
        Write-Host "After approval, all installation steps will complete without additional prompts." -ForegroundColor Yellow
        Write-Host ""
        Start-Sleep -Seconds 2
        Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Wait
        exit $LASTEXITCODE
    }
    
    # From this point on, we have admin privileges for the entire script
    # No additional elevation needed
} else {
    # User installation (default) - no admin required
    $InstallDir = "$env:LOCALAPPDATA\Programs"
    # All Tlang executables go to tlang/bin for better organization
    $TlangBinDir = "$InstallDir\tlang\bin"
    # Wrapper script goes to standard bin for PATH access
    $WrapperBinDir = "$env:LOCALAPPDATA\Programs\bin"
    $TlangBin = "$TlangBinDir\tlangc.exe"
    $TlangWrapper = "$WrapperBinDir\tlang.ps1"
}

Write-Host "Installing to: $InstallDir" -ForegroundColor Green
Write-Host "Tlang executables: $TlangBinDir" -ForegroundColor Green
Write-Host "Wrapper script: $TlangWrapper" -ForegroundColor Green
Write-Host ""

# ============================================================================
# Clean existing installation if it exists
# ============================================================================
# Before installing, remove any existing Tlang installation to ensure a clean
# setup. This prevents conflicts from old binaries, libraries, or bundled tools.
# ============================================================================
$needsCleanup = $false
# Check for existing installation components
if (Test-Path $TlangWrapper) { $needsCleanup = $true }
if (Test-Path $TlangBin) { $needsCleanup = $true }
if (Test-Path "$TlangBinDir\tlangc.exe") { $needsCleanup = $true }
if (Test-Path "$TlangBinDir\tlang-build.exe") { $needsCleanup = $true }
if (Test-Path "$TlangBinDir\tlang-port.exe") { $needsCleanup = $true }
# Check old locations for backward compatibility
if (Test-Path "$WrapperBinDir\tlangc.exe") { $needsCleanup = $true }
if (Test-Path "$InstallDir\tlang") { $needsCleanup = $true }

if ($needsCleanup) {
    Write-Host "Existing Tlang installation detected. Cleaning up..." -ForegroundColor Yellow
    Write-Host ""
    
    # ------------------------------------------------------------------------
    # Remove wrapper script and binaries
    # ------------------------------------------------------------------------
    # Remove the main wrapper script (tlang.ps1 command)
    if (Test-Path $TlangWrapper) {
        Write-Host "  Removing: $TlangWrapper" -ForegroundColor Gray
        Remove-Item -Force -Path $TlangWrapper -ErrorAction SilentlyContinue
    }
    
    # Remove compiler binary (tlangc.exe) from both old and new locations
    if (Test-Path "$TlangBinDir\tlangc.exe") {
        Write-Host "  Removing: $TlangBinDir\tlangc.exe" -ForegroundColor Gray
        Remove-Item -Force -Path "$TlangBinDir\tlangc.exe" -ErrorAction SilentlyContinue
    }
    # Check old location for backward compatibility
    $oldBinDir = "$InstallDir\bin"
    if (Test-Path "$oldBinDir\tlangc.exe") {
        Write-Host "  Removing: $oldBinDir\tlangc.exe" -ForegroundColor Gray
        Remove-Item -Force -Path "$oldBinDir\tlangc.exe" -ErrorAction SilentlyContinue
    }
    
    # Remove build system binary (tlang-build.exe) from both old and new locations
    if (Test-Path "$TlangBinDir\tlang-build.exe") {
        Write-Host "  Removing: $TlangBinDir\tlang-build.exe" -ForegroundColor Gray
        Remove-Item -Force -Path "$TlangBinDir\tlang-build.exe" -ErrorAction SilentlyContinue
    }
    if (Test-Path "$oldBinDir\tlang-build.exe") {
        Write-Host "  Removing: $oldBinDir\tlang-build.exe" -ForegroundColor Gray
        Remove-Item -Force -Path "$oldBinDir\tlang-build.exe" -ErrorAction SilentlyContinue
    }
    
    # Remove porting tool binary (tlang-port.exe) from both old and new locations
    if (Test-Path "$TlangBinDir\tlang-port.exe") {
        Write-Host "  Removing: $TlangBinDir\tlang-port.exe" -ForegroundColor Gray
        Remove-Item -Force -Path "$TlangBinDir\tlang-port.exe" -ErrorAction SilentlyContinue
    }
    if (Test-Path "$oldBinDir\tlang-port.exe") {
        Write-Host "  Removing: $oldBinDir\tlang-port.exe" -ForegroundColor Gray
        Remove-Item -Force -Path "$oldBinDir\tlang-port.exe" -ErrorAction SilentlyContinue
    }
    
    # Remove wrapper script (tlang.ps1) from both old and new locations
    if (Test-Path $TlangWrapper) {
        Write-Host "  Removing: $TlangWrapper" -ForegroundColor Gray
        Remove-Item -Force -Path $TlangWrapper -ErrorAction SilentlyContinue
    }
    if (Test-Path "$TlangBinDir\tlang.ps1") {
        Write-Host "  Removing: $TlangBinDir\tlang.ps1" -ForegroundColor Gray
        Remove-Item -Force -Path "$TlangBinDir\tlang.ps1" -ErrorAction SilentlyContinue
    }
    if (Test-Path "$oldBinDir\tlang.ps1") {
        Write-Host "  Removing: $oldBinDir\tlang.ps1" -ForegroundColor Gray
        Remove-Item -Force -Path "$oldBinDir\tlang.ps1" -ErrorAction SilentlyContinue
    }
    
    # ------------------------------------------------------------------------
    # Remove Tlang directory and all its contents
    # ------------------------------------------------------------------------
    # This includes:
    #   - lib\     : Bundled OpenSSL libraries and other dependencies
    #   - mingw\   : Bundled GCC compiler (Windows only)
    #   - include\ : Header files (if any)
    if (Test-Path "$InstallDir\tlang") {
        Write-Host "  Removing: $InstallDir\tlang" -ForegroundColor Gray
        Remove-Item -Recurse -Force -Path "$InstallDir\tlang" -ErrorAction SilentlyContinue
    }
    
    Write-Host "  ✓ Cleanup complete" -ForegroundColor Green
    Write-Host ""
}

# Define library directory
$LibDir = "$InstallDir\tlang\lib"
$BundleTempDir = ".\bundled-openssl-temp"
$GccBundleTempDir = ".\bundled-gcc-temp"

# Bundle GCC (MinGW) - Windows only. Uses deps\windows\mingw from repo (no lookup/download).
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "Step 1/6: Bundling GCC (MinGW) compiler..." -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
$bundledGCC = $false
$depsMingw = "deps\windows\mingw"
if (Test-Path "$depsMingw\bin\gcc.exe") {
    Write-Host "  Using prebuilt MinGW from $depsMingw" -ForegroundColor Gray
    New-Item -ItemType Directory -Force -Path $GccBundleTempDir | Out-Null
    Copy-Item -Path "$depsMingw\*" -Destination $GccBundleTempDir -Recurse -Force -ErrorAction SilentlyContinue
    if (Test-Path "$GccBundleTempDir\bin\gcc.exe") {
        Write-Host "✓ GCC compiler bundled from deps" -ForegroundColor Green
        $bundledGCC = $true
    }
}
if (-not $bundledGCC) {
    Write-Host "  No deps\windows\mingw found. Copy from C:\MinGW to deps\windows\mingw (see docs\MINGW_BUNDLE_COPY.md)" -ForegroundColor Yellow
    Write-Host "  Will require system GCC in PATH." -ForegroundColor Yellow
}

# Bundle OpenSSL
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "Step 2/6: Bundling OpenSSL libraries..." -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
$bundledOpenSSL = $false
if (Test-Path "scripts\bundle-openssl.ps1") {
    try {
        & powershell -ExecutionPolicy Bypass -File "scripts\bundle-openssl.ps1" -BundleDir $BundleTempDir
        if ($LASTEXITCODE -eq 0 -and (Test-Path "$BundleTempDir\lib\libssl.lib")) {
            Write-Host "OpenSSL libraries bundled successfully" -ForegroundColor Green
            $bundledOpenSSL = $true
        } else {
            Write-Host "Warning: OpenSSL bundling produced no libraries. Will use system OpenSSL." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Warning: Could not bundle OpenSSL. Will use system OpenSSL." -ForegroundColor Yellow
    }
}

# Check for OpenSSL (fallback to system)
Write-Host ""
Write-Host "Step 3/6: Checking for OpenSSL..." -ForegroundColor Cyan
$opensslFound = $false

# Check if OpenSSL is available via vcpkg
if (Test-Path "$env:VCPKG_ROOT\installed\x64-windows\lib\libssl.lib") {
    Write-Host "OpenSSL found via vcpkg" -ForegroundColor Green
    $opensslFound = $true
}

# Check if OpenSSL is in common locations
$opensslPaths = @(
    "C:\OpenSSL-Win64",
    "C:\Program Files\OpenSSL-Win64",
    "C:\OpenSSL",
    "$env:ProgramFiles\OpenSSL"
)

foreach ($path in $opensslPaths) {
    if (Test-Path "$path\lib\libssl.lib") {
        Write-Host "OpenSSL found at: $path" -ForegroundColor Green
        $env:OPENSSL_DIR = $path
        $opensslFound = $true
        break
    }
}

if (-not $opensslFound) {
    Write-Host "OpenSSL not found. Continuing without OpenSSL (some features may not work)" -ForegroundColor Yellow
    Write-Host "  Install from: https://slproweb.com/products/Win32OpenSSL.html or vcpkg install openssl:x64-windows" -ForegroundColor Gray
    Write-Host ""
}

# Check for pkg-config (optional on Windows, but helpful)
if (-not (Get-Command pkg-config -ErrorAction SilentlyContinue)) {
    Write-Host "Note: pkg-config not found (optional on Windows)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "Step 4/6: Building Tlang compiler from source..." -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "This may take a few minutes (downloading Rust dependencies and compiling)..." -ForegroundColor Yellow
Write-Host ""

# Ensure Rust/Cargo is available (auto-install if missing, no prompts)
if (-not (Get-Command cargo -ErrorAction SilentlyContinue)) {
    Write-Host "Rust not found. Installing rustup (non-interactive)..." -ForegroundColor Gray
    try {
        $rustupExe = "$env:TEMP\rustup-init.exe"
        Invoke-WebRequest -Uri "https://win.rustup.rs/x86_64" -OutFile $rustupExe -UseBasicParsing -ErrorAction Stop
        & $rustupExe -y -q --default-toolchain stable 2>$null
        $env:Path = "$env:USERPROFILE\.cargo\bin;$env:Path"
    } catch {
        Write-Host "Error: Rust required. Install from https://rustup.rs" -ForegroundColor Red
        exit 1
    }
}
if (-not (Get-Command cargo -ErrorAction SilentlyContinue)) {
    $env:Path = "$env:USERPROFILE\.cargo\bin;$env:Path"
}
if (-not (Get-Command cargo -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Rust/cargo not found. Add to PATH: `$env:USERPROFILE\.cargo\bin" -ForegroundColor Red
    exit 1
}

# Use cargo with verbose output to show progress
$ProgressPreference = 'Continue'  # Show progress
cargo build --release

if (-not (Test-Path "target\release\tlangc.exe") -or -not (Test-Path "target\release\tlang-build.exe") -or -not (Test-Path "target\release\tlang-port.exe")) {
    Write-Host "Error: Build failed or binaries not found" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Build completed successfully" -ForegroundColor Green
Write-Host ""

# Create directories
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "Step 5/6: Installing binaries and creating directories..." -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  Creating installation directories..." -ForegroundColor Gray
# Create directories for Tlang installation
# All executables go to tlang/bin for better organization
New-Item -ItemType Directory -Force -Path $TlangBinDir | Out-Null
New-Item -ItemType Directory -Force -Path $WrapperBinDir | Out-Null
New-Item -ItemType Directory -Force -Path $LibDir | Out-Null

# Install bundled GCC if available
if ($bundledGCC -and (Test-Path "$GccBundleTempDir\bin")) {
    Write-Host "  Installing bundled GCC compiler..." -ForegroundColor Gray
    $GccDir = "$InstallDir\tlang\mingw"
    # GCC executables go to tlang/bin for unified location
    $GccBinDir = $TlangBinDir
    $GccLibDir = "$GccDir\lib"
    $GccIncludeDir = "$GccDir\include"
    
    New-Item -ItemType Directory -Force -Path $GccBinDir | Out-Null
    New-Item -ItemType Directory -Force -Path $GccLibDir | Out-Null
    New-Item -ItemType Directory -Force -Path $GccIncludeDir | Out-Null
    
    # Copy GCC binaries to tlang/bin (unified executable location)
    Copy-Item "$GccBundleTempDir\bin\*" -Destination $GccBinDir -Recurse -Force -ErrorAction SilentlyContinue
    if (Test-Path "$GccBundleTempDir\lib") {
        Copy-Item "$GccBundleTempDir\lib\*" -Destination $GccLibDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    if (Test-Path "$GccBundleTempDir\include") {
        Copy-Item "$GccBundleTempDir\include\*" -Destination $GccIncludeDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    # Cleanup temp directory
    Remove-Item -Recurse -Force $GccBundleTempDir -ErrorAction SilentlyContinue
    
    Write-Host ""
    Write-Host "✓ GCC compiler successfully installed!" -ForegroundColor Green
    Write-Host "  Installation path: $GccDir" -ForegroundColor Gray
    Write-Host "  GCC will be automatically used by tlang wrapper script" -ForegroundColor Gray
    
    # Verify and display GCC version
    $bundledGccExe = Join-Path $GccBinDir "gcc.exe"
    if (Test-Path $bundledGccExe) {
        try {
            $gccVersion = & $bundledGccExe --version 2>&1 | Select-Object -First 1
            Write-Host "  Installed GCC version: $gccVersion" -ForegroundColor Cyan
        } catch {
            Write-Host "  GCC installed and ready to use" -ForegroundColor Green
        }
    }
    Write-Host ""
}

# Install bundled OpenSSL if available
if ($bundledOpenSSL -and (Test-Path "$BundleTempDir\lib")) {
    Write-Host "  Installing bundled OpenSSL libraries..." -ForegroundColor Gray
    Copy-Item "$BundleTempDir\lib\*" -Destination $LibDir -Force -ErrorAction SilentlyContinue
    if (Test-Path "$BundleTempDir\bin") {
        Copy-Item "$BundleTempDir\bin\*" -Destination $LibDir -Force -ErrorAction SilentlyContinue
    }
    if (Test-Path "$BundleTempDir\include") {
        $includeDir = "$InstallDir\tlang\include"
        New-Item -ItemType Directory -Force -Path $includeDir | Out-Null
        Copy-Item "$BundleTempDir\include\*" -Destination $includeDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    # Cleanup temp directory
    Remove-Item -Recurse -Force $BundleTempDir -ErrorAction SilentlyContinue
    Write-Host "Bundled OpenSSL libraries installed to: $LibDir" -ForegroundColor Green
}

# Install binaries to tlang/bin (unified executable location)
Write-Host "  Installing tlangc compiler..." -ForegroundColor Gray
Copy-Item "target\release\tlangc.exe" -Destination $TlangBin -Force
Write-Host "    ✓ tlangc installed to $TlangBinDir" -ForegroundColor Green

Write-Host "  Installing tlang-build tool..." -ForegroundColor Gray
$TlangBuildBin = "$TlangBinDir\tlang-build.exe"
Copy-Item "target\release\tlang-build.exe" -Destination $TlangBuildBin -Force
Write-Host "    ✓ tlang-build installed to $TlangBinDir" -ForegroundColor Green

Write-Host "  Installing tlang-port tool..." -ForegroundColor Gray
$TlangPortBin = "$TlangBinDir\tlang-port.exe"
Copy-Item "target\release\tlang-port.exe" -Destination $TlangPortBin -Force
Write-Host "    ✓ tlang-port installed to $TlangBinDir" -ForegroundColor Green

# Create tlang wrapper script
Write-Host "  Creating tlang wrapper script..." -ForegroundColor Gray
$wrapperScript = @'
# Tlang wrapper script for Windows
# Usage: tlang [command] [options]

param(
    [Parameter(Position=0)]
    [string]$Command,
    
    [Parameter(Position=1)]
    [string[]]$Arguments
)

if (-not $Command) {
    Write-Host "Usage: tlang [command] [options]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  compile [file.tl] [output]     - Compile Tlang file to executable binary"
    Write-Host "  run [file.tl] [args]          - Compile and run Tlang file (auto-detects adhi.tl/main.tl if not specified)"
    Write-Host "  test [file.tl]                - Run tests in Tlang file"
    Write-Host "  build [dir]                   - Build project (compile once, run anywhere)"
    Write-Host "  init [app_name] [dir]         - Initialize new project with config.toml"
    Write-Host "  clean [dir]                   - Clean build artifacts"
    Write-Host "  add [package]@[version] [dir]  - Add a package dependency"
    Write-Host "  get [git|url] [dir]           - Fetch package from Git or URL and add to project"
    Write-Host "  remove [package] [dir]        - Remove a package dependency"
    Write-Host "  upgrade [package|.|*] [dir]   - Upgrade package(s) to latest version"
    Write-Host "  port [url|package|file] [dest]- Convert Go/Rust to Tlang"
    Write-Host "  version                       - Show installed version"
    Write-Host "  help [command]                - Show help (optionally for a command)"
    Write-Host ""
    Write-Host "Flags:"
    Write-Host "  --version, -v                - Show version"
    Write-Host ""
    exit 1
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
# Find binaries in tlang/bin directory (unified executable location)
$installBase = Split-Path $scriptDir -Parent
$tlangBinDir = Join-Path $installBase "tlang\bin"
# Try tlang/bin first, then fallback to script directory (for backward compatibility)
$tlangc = Join-Path $tlangBinDir "tlangc.exe"
if (-not (Test-Path $tlangc)) {
    $tlangc = Join-Path $scriptDir "tlangc.exe"
}
$tlangBuild = Join-Path $tlangBinDir "tlang-build.exe"
if (-not (Test-Path $tlangBuild)) {
    $tlangBuild = Join-Path $scriptDir "tlang-build.exe"
}
$tlangPort = Join-Path $tlangBinDir "tlang-port.exe"
if (-not (Test-Path $tlangPort)) {
    $tlangPort = Join-Path $scriptDir "tlang-port.exe"
}
$installDir = Split-Path -Parent $scriptDir
$libDir = Join-Path $installDir "lib"
$gccDir = Join-Path $installDir "mingw"
# GCC executables are now in tlang/bin (unified location)
$bundledGcc = Join-Path $tlangBinDir "gcc.exe"

# Function to find C compiler (check bundled GCC first, then system)
function Find-Compiler {
    # Check bundled GCC first
    if (Test-Path $bundledGcc) {
        return $bundledGcc
    }
    
    # Check system GCC
    $gcc = Get-Command gcc -ErrorAction SilentlyContinue
    if ($gcc) {
        return $gcc.Source
    }
    
    # Check system MSVC
    $cl = Get-Command cl -ErrorAction SilentlyContinue
    if ($cl) {
        return $cl.Source
    }
    
    return $null
}

# Handle version flags first (before switch statement)
if ($Command -eq "--version" -or $Command -eq "-v" -or $Command -eq "version") {
    & $tlangc --version
    exit 0
}

# Common OpenSSL paths (for fallback)
$opensslPaths = @(
    "C:\OpenSSL-Win64",
    "C:\Program Files\OpenSSL-Win64",
    "C:\OpenSSL",
    "$env:ProgramFiles\OpenSSL"
)

switch ($Command) {
    "compile" {
        if ($Arguments.Count -eq 0) {
            Write-Host "Error: No file specified" -ForegroundColor Red
            exit 1
        }
        $file = $Arguments[0]
        if (-not (Test-Path $file)) {
            Write-Host "Error: File not found: $file" -ForegroundColor Red
            exit 1
        }
        
        # Determine output binary name
        if ($Arguments.Count -ge 2) {
            $outputBin = $Arguments[1]
        } else {
            # Remove .tl extension and use as binary name
            $outputBin = $file -replace '\.tl$', ''
            if ($outputBin -eq $file) {
                $outputBin = "$file.exe"
            } else {
                $outputBin = "$outputBin.exe"
            }
        }
        
        # Determine target directory (use execution directory)
        $execDir = Get-Location
        $targetDir = Join-Path $execDir "target"
        $fileBase = [System.IO.Path]::GetFileNameWithoutExtension($file)
        
        # Create target directory if it doesn't exist
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
        }
        
        # Compile Tlang to C file in target directory
        $cFile = Join-Path $targetDir "$fileBase.c"
        Write-Host "Compiling to: $cFile" -ForegroundColor Gray
        & $tlangc $file $cFile
        if ($LASTEXITCODE -ne 0) {
            exit $LASTEXITCODE
        }
        
        # Find C compiler (bundled GCC first, then system)
        $compilerPath = Find-Compiler
        if (-not $compilerPath) {
            Write-Host "Error: No C compiler found (gcc or cl)" -ForegroundColor Red
            Write-Host "Please install MinGW-w64 or MSVC Build Tools" -ForegroundColor Yellow
            exit 1
        }
        
        $compilerName = Split-Path -Leaf $compilerPath
        $isGcc = $compilerName -eq "gcc.exe" -or $compilerName -eq "gcc"
        $isBundled = $compilerPath -eq $bundledGcc
        
        if ($isGcc) {
            # Setup library paths for bundled GCC
            $libPaths = @()
            if ($isBundled) {
                $libPaths += "-L$gccDir\lib"
            }
            
            # Try bundled OpenSSL first, then system
            $opensslLibs = ""
            if (Test-Path "$libDir\libssl.a") {
                $opensslLibs = "-L$libDir -lssl -lcrypto -Wl,-rpath,$libDir"
            } elseif (Test-Path "$libDir\libssl.dll.a") {
                $opensslLibs = "-L$libDir -lssl -lcrypto -Wl,-rpath,$libDir"
            } else {
                foreach ($path in $opensslPaths) {
                    if (Test-Path "$path\lib") {
                        $opensslLibs = "-L$path\lib -lssl -lcrypto"
                        break
                    }
                }
                if ($opensslLibs -eq "") {
                    $opensslLibs = "-lssl -lcrypto"
                }
            }
            
            # Build compiler arguments
            $compilerArgs = @("-DUSE_OPENSSL", "-o", $outputBin, $cFile, "-lm") + $libPaths
            if ($opensslLibs) {
                $compilerArgs += $opensslLibs.Split(" ")
            }
            
            & $compilerPath $compilerArgs
        } else {
            # MSVC - try bundled OpenSSL first, then system
            $opensslLibPath = ""
            if (Test-Path "$libDir\libssl.lib") {
                $opensslLibPath = $libDir
            } else {
                foreach ($path in $opensslPaths) {
                    if (Test-Path "$path\lib\libssl.lib") {
                        $opensslLibPath = "$path\lib"
                        break
                    }
                }
            }
            if ($opensslLibPath -ne "") {
                & $compilerPath /DUSE_OPENSSL $cFile /Fe:$outputBin /link /LIBPATH:$opensslLibPath libssl.lib libcrypto.lib
            } else {
                & $compilerPath /DUSE_OPENSSL $cFile /Fe:$outputBin /link libssl.lib libcrypto.lib
            }
        }
        
        $compileResult = $LASTEXITCODE
        
        if ($compileResult -eq 0) {
            Write-Host "Compilation successful!" -ForegroundColor Green
            Write-Host "  C file: $cFile" -ForegroundColor Gray
            Write-Host "  Executable: $outputBin" -ForegroundColor Gray
        } else {
            Write-Host "Error: Failed to compile C to binary" -ForegroundColor Red
            Write-Host "C file saved at: $cFile" -ForegroundColor Yellow
            exit 1
        }
    }
    "run" {
        # Auto-detect entry file if not specified
        $file = $null
        $remainingArgs = @()
        
        # Check if first argument is a file (ends with .tl) or just arguments
        if ($Arguments.Count -eq 0) {
            # No arguments - try to auto-detect entry file
            $file = $null
        } elseif (Test-Path $Arguments[0] -PathType Leaf -ErrorAction SilentlyContinue) {
            # First argument is a file
            $file = $Arguments[0]
            $remainingArgs = $Arguments[1..($Arguments.Count-1)]
        } elseif ($Arguments[0] -match '\.tl$') {
            # Looks like a file path (even if doesn't exist yet)
            $file = $Arguments[0]
            $remainingArgs = $Arguments[1..($Arguments.Count-1)]
        } else {
            # First argument doesn't look like a file - treat as program arguments
            # Auto-detect entry file
            $remainingArgs = $Arguments
        }
        
        # Auto-detect entry file if not set
        if (-not $file) {
            # Try to find entry file in current directory
            # Priority: 1) config.toml entry_file, 2) adhi.tl, 3) main.tl
            if (Test-Path "config.toml") {
                $configContent = Get-Content "config.toml" -Raw
                if ($configContent -match 'entry_file\s*=\s*["'']([^"'']+)["'']') {
                    $entryFile = $matches[1]
                    if (Test-Path $entryFile) {
                        $file = $entryFile
                    }
                }
            }
            
            # Fallback to common entry file names
            if (-not $file) {
                if (Test-Path "adhi.tl") {
                    $file = "adhi.tl"
                } elseif (Test-Path "main.tl") {
                    $file = "main.tl"
                } elseif (Test-Path "src\adhi.tl") {
                    $file = "src\adhi.tl"
                } elseif (Test-Path "src\main.tl") {
                    $file = "src\main.tl"
                }
            }
            
            if (-not $file) {
                Write-Host "Error: No file specified and no entry file found" -ForegroundColor Red
                Write-Host "Looking for: adhi.tl, main.tl, src\adhi.tl, src\main.tl, or entry_file in config.toml"
                exit 1
            }
        }
        
        if (-not (Test-Path $file)) {
            Write-Host "Error: File not found: $file" -ForegroundColor Red
            exit 1
        }
        
        # Determine target directory (use execution directory)
        $execDir = Get-Location
        $targetDir = Join-Path $execDir "target"
        $fileBase = [System.IO.Path]::GetFileNameWithoutExtension($file)
        
        # Create target directory if it doesn't exist
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
        }
        
        # Compile to C file in target directory (quiet mode like Go)
        $cFile = Join-Path $targetDir "$fileBase.c"
        $binFile = Join-Path $targetDir "$fileBase.exe"
        
        # Compile Tlang to C (quiet, only show errors)
        $compileOutput = & $tlangc $file $cFile 2>&1
        if ($LASTEXITCODE -ne 0) {
            # Show errors if compilation fails
            Write-Host $compileOutput -ForegroundColor Red
            exit $LASTEXITCODE
        }
        # Find C compiler (bundled GCC first, then system)
        $compilerPath = Find-Compiler
        if (-not $compilerPath) {
            Write-Host "Error: No C compiler found (gcc or cl)" -ForegroundColor Red
            Write-Host "Please install MinGW-w64 or MSVC Build Tools" -ForegroundColor Yellow
            exit 1
        }
        
        $compilerName = Split-Path -Leaf $compilerPath
        $isGcc = $compilerName -eq "gcc.exe" -or $compilerName -eq "gcc"
        $isBundled = $compilerPath -eq $bundledGcc
        
        if ($isGcc) {
            # Setup library paths for bundled GCC
            $libPaths = @()
            if ($isBundled) {
                $libPaths += "-L$gccDir\lib"
            }
            
            # Try bundled OpenSSL first, then system
            $opensslLibs = ""
            if (Test-Path "$libDir\libssl.a") {
                $opensslLibs = "-L$libDir -lssl -lcrypto -Wl,-rpath,$libDir"
            } elseif (Test-Path "$libDir\libssl.dll.a") {
                $opensslLibs = "-L$libDir -lssl -lcrypto -Wl,-rpath,$libDir"
            } else {
                foreach ($path in $opensslPaths) {
                    if (Test-Path "$path\lib") {
                        $opensslLibs = "-L$path\lib -lssl -lcrypto"
                        break
                    }
                }
                if ($opensslLibs -eq "") {
                    $opensslLibs = "-lssl -lcrypto"
                }
            }
            
            # Build compiler arguments
            $compilerArgs = @("-DUSE_OPENSSL", "-o", $binFile, $cFile, "-lm") + $libPaths
            if ($opensslLibs) {
                $compilerArgs += $opensslLibs.Split(" ")
            }
            
            # Compile C to binary (quiet mode, only show errors)
            $cCompileOutput = & $compilerPath $compilerArgs 2>&1
        } else {
            # MSVC - try bundled OpenSSL first, then system
            $opensslLibPath = ""
            if (Test-Path "$libDir\libssl.lib") {
                $opensslLibPath = $libDir
            } else {
                foreach ($path in $opensslPaths) {
                    if (Test-Path "$path\lib\libssl.lib") {
                        $opensslLibPath = "$path\lib"
                        break
                    }
                }
            }
            if ($opensslLibPath -ne "") {
                $cCompileOutput = & $compilerPath /DUSE_OPENSSL $cFile /Fe:$binFile /link /LIBPATH:$opensslLibPath libssl.lib libcrypto.lib 2>&1
            } else {
                $cCompileOutput = & $compilerPath /DUSE_OPENSSL $cFile /Fe:$binFile /link libssl.lib libcrypto.lib 2>&1
            }
        }
        if ($LASTEXITCODE -ne 0) {
            # Show compilation errors (like Go does)
            Write-Host $cCompileOutput -ForegroundColor Red
            Write-Host "Error: C compilation failed" -ForegroundColor Red
            Write-Host "C file saved at: $cFile" -ForegroundColor Yellow
            exit 1
        }
        
        # Run binary with remaining arguments (if any) - like go run
        if ($remainingArgs.Count -gt 0) {
            & $binFile $remainingArgs
        } else {
            & $binFile
        }
        $exitCode = $LASTEXITCODE
        
        # Clean up binary after running (like go run does)
        # Keep C file for debugging, but remove binary to mimic go run behavior
        Remove-Item -Force $binFile -ErrorAction SilentlyContinue
        
        exit $exitCode
    }
    "test" {
        if ($Arguments.Count -eq 0) {
            Write-Host "Error: No file specified" -ForegroundColor Red
            exit 1
        }
        $file = $Arguments[0]
        if (-not (Test-Path $file)) {
            Write-Host "Error: File not found: $file" -ForegroundColor Red
            exit 1
        }
        
        # Determine target directory (use execution directory)
        $execDir = Get-Location
        $targetDir = Join-Path $execDir "target"
        $fileBase = [System.IO.Path]::GetFileNameWithoutExtension($file)
        
        # Create target directory if it doesn't exist
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
        }
        
        # Compile and run test file
        $cFile = Join-Path $targetDir "$fileBase.c"
        $binFile = Join-Path $targetDir "$fileBase.exe"
        
        Write-Host "Compiling to: $cFile" -ForegroundColor Gray
        & $tlangc $file $cFile
        if ($LASTEXITCODE -ne 0) {
            exit $LASTEXITCODE
        }
        # Find C compiler (bundled GCC first, then system)
        $compilerPath = Find-Compiler
        if (-not $compilerPath) {
            Write-Host "Error: No C compiler found (gcc or cl)" -ForegroundColor Red
            Write-Host "Please install MinGW-w64 or MSVC Build Tools" -ForegroundColor Yellow
            exit 1
        }
        
        $compilerName = Split-Path -Leaf $compilerPath
        $isGcc = $compilerName -eq "gcc.exe" -or $compilerName -eq "gcc"
        $isBundled = $compilerPath -eq $bundledGcc
        
        if ($isGcc) {
            # Setup library paths for bundled GCC
            $libPaths = @()
            if ($isBundled) {
                $libPaths += "-L$gccDir\lib"
            }
            
            $opensslLibs = ""
            if (Test-Path "$libDir\libssl.a") {
                $opensslLibs = "-L$libDir -lssl -lcrypto -Wl,-rpath,$libDir"
            } elseif (Test-Path "$libDir\libssl.dll.a") {
                $opensslLibs = "-L$libDir -lssl -lcrypto -Wl,-rpath,$libDir"
            } else {
                foreach ($path in $opensslPaths) {
                    if (Test-Path "$path\lib") {
                        $opensslLibs = "-L$path\lib -lssl -lcrypto"
                        break
                    }
                }
                if ($opensslLibs -eq "") {
                    $opensslLibs = "-lssl -lcrypto"
                }
            }
            
            # Build compiler arguments
            $compilerArgs = @("-DUSE_OPENSSL", "-o", $binFile, $cFile, "-lm") + $libPaths
            if ($opensslLibs) {
                $compilerArgs += $opensslLibs.Split(" ")
            }
            
            & $compilerPath $compilerArgs
        } else {
            $opensslLibPath = ""
            if (Test-Path "$libDir\libssl.lib") {
                $opensslLibPath = $libDir
            } else {
                foreach ($path in $opensslPaths) {
                    if (Test-Path "$path\lib\libssl.lib") {
                        $opensslLibPath = "$path\lib"
                        break
                    }
                }
            }
            if ($opensslLibPath -ne "") {
                & $compilerPath /DUSE_OPENSSL $cFile /Fe:$binFile /link /LIBPATH:$opensslLibPath libssl.lib libcrypto.lib
            } else {
                & $compilerPath /DUSE_OPENSSL $cFile /Fe:$binFile /link libssl.lib libcrypto.lib
            }
        }
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error: C compilation failed" -ForegroundColor Red
            Write-Host "C file saved at: $cFile" -ForegroundColor Yellow
            exit 1
        }
        & $binFile
        $exitCode = $LASTEXITCODE
        # Note: C file and binary are kept in target/ directory for debugging
        exit $exitCode
    }
    "build" {
        # Build project - use provided directory or current directory
        $projectDir = if ($Arguments.Count -gt 0) { $Arguments[0] } else { "." }
        if (-not (Test-Path $projectDir -PathType Container)) {
            Write-Host "Error: Directory not found: $projectDir" -ForegroundColor Red
            exit 1
        }
        Push-Location $projectDir
        try {
            & $tlangBuild build
        } finally {
            Pop-Location
        }
    }
    "init" {
        # Initialize project - app_name [directory]
        # If first arg is a directory (exists or starts with . or \), treat as directory
        # Otherwise treat as app name
        $appName = $null
        $projectDir = "."
        
        if ($Arguments.Count -gt 0) {
            $firstArg = $Arguments[0]
            if ((Test-Path $firstArg -PathType Container) -or $firstArg.StartsWith(".") -or $firstArg.StartsWith("\") -or ($firstArg -match "^[A-Za-z]:\\")) {
                # First arg looks like a directory
                $projectDir = $firstArg
            } else {
                # First arg is app name
                $appName = $firstArg
                $projectDir = if ($Arguments.Count -gt 1) { $Arguments[1] } else { "." }
            }
        }
        
        if (-not (Test-Path $projectDir -PathType Container)) {
            New-Item -ItemType Directory -Force -Path $projectDir | Out-Null
        }
        Push-Location $projectDir
        try {
            if ($appName) {
                & $tlangBuild init $appName
            } else {
                & $tlangBuild init
            }
        } finally {
            Pop-Location
        }
    }
    "clean" {
        # Clean project - use provided directory or current directory
        $projectDir = if ($Arguments.Count -gt 0) { $Arguments[0] } else { "." }
        if (-not (Test-Path $projectDir -PathType Container)) {
            Write-Host "Error: Directory not found: $projectDir" -ForegroundColor Red
            exit 1
        }
        Push-Location $projectDir
        try {
            & $tlangBuild clean
        } finally {
            Pop-Location
        }
    }
    "add" {
        # Add package - package@version [directory]
        if ($Arguments.Count -eq 0) {
            Write-Host "Error: Package name required" -ForegroundColor Red
            Write-Host "Usage: tlang add [package]@[version] [directory]" -ForegroundColor Yellow
            exit 1
        }
        $packageSpec = $Arguments[0]
        $projectDir = if ($Arguments.Count -gt 1) { $Arguments[1] } else { "." }
        if (-not (Test-Path $projectDir -PathType Container)) {
            Write-Host "Error: Directory not found: $projectDir" -ForegroundColor Red
            exit 1
        }
        Push-Location $projectDir
        try {
            & $tlangBuild add $packageSpec
        } finally {
            Pop-Location
        }
    }
    "get" {
        # Fetch package from Git or URL and add to project - url [directory]
        if ($Arguments.Count -eq 0) {
            Write-Host "Error: URL required" -ForegroundColor Red
            Write-Host "Usage: tlang get [git|url] [directory]" -ForegroundColor Yellow
            Write-Host "  Example: tlang get https://github.com/user/repo" -ForegroundColor Gray
            exit 1
        }
        $packageUrl = $Arguments[0]
        $projectDir = if ($Arguments.Count -gt 1) { $Arguments[1] } else { "." }
        if (-not (Test-Path $projectDir -PathType Container)) {
            Write-Host "Error: Directory not found: $projectDir" -ForegroundColor Red
            exit 1
        }
        Push-Location $projectDir
        try {
            & $tlangBuild add $packageUrl
        } finally {
            Pop-Location
        }
    }
    "remove" {
        # Remove package - package [directory]
        if ($Arguments.Count -eq 0) {
            Write-Host "Error: Package name required" -ForegroundColor Red
            Write-Host "Usage: tlang remove [package] [directory]" -ForegroundColor Yellow
            exit 1
        }
        $packageName = $Arguments[0]
        $projectDir = if ($Arguments.Count -gt 1) { $Arguments[1] } else { "." }
        if (-not (Test-Path $projectDir -PathType Container)) {
            Write-Host "Error: Directory not found: $projectDir" -ForegroundColor Red
            exit 1
        }
        Push-Location $projectDir
        try {
            & $tlangBuild remove $packageName
        } finally {
            Pop-Location
        }
    }
    "upgrade" {
        # Upgrade package - package|.|* [directory]
        if ($Arguments.Count -eq 0) {
            Write-Host "Error: Package name required (use '.' or '*' for all packages)" -ForegroundColor Red
            Write-Host "Usage: tlang upgrade [package|.|*] [directory]" -ForegroundColor Yellow
            exit 1
        }
        $packageSpec = $Arguments[0]
        $projectDir = if ($Arguments.Count -gt 1) { $Arguments[1] } else { "." }
        if (-not (Test-Path $projectDir -PathType Container)) {
            Write-Host "Error: Directory not found: $projectDir" -ForegroundColor Red
            exit 1
        }
        Push-Location $projectDir
        try {
            & $tlangBuild upgrade $packageSpec
        } finally {
            Pop-Location
        }
    }
    "version" {
        # Show version (handled above, but keep for consistency)
        & $tlangc --version
    }
    default {
        Write-Host "Unknown command: $Command" -ForegroundColor Red
        Write-Host "Run 'tlang' for usage information"
        exit 1
    }
}
'@

Set-Content -Path $TlangWrapper -Value $wrapperScript

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "Step 6/6: Configuring PATH..." -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  Checking if $WrapperBinDir and $TlangBinDir are in PATH..." -ForegroundColor Gray

# Check current PATH first
$currentSessionPath = $env:Path
$wrapperInPath = $currentSessionPath -like "*$WrapperBinDir*"
$tlangBinInPath = $currentSessionPath -like "*$TlangBinDir*"

if (-not $wrapperInPath) {
    Write-Host "  $WrapperBinDir is not in your current PATH (for tlang wrapper)" -ForegroundColor Yellow
} else {
    Write-Host "  $WrapperBinDir is already in current PATH" -ForegroundColor Green
}

if (-not $tlangBinInPath) {
    Write-Host "  $TlangBinDir is not in your current PATH (for all executables)" -ForegroundColor Yellow
} else {
    Write-Host "  $TlangBinDir is already in current PATH" -ForegroundColor Green
}

# Add to PATH
if ($env:SYSTEM_INSTALL -eq "1") {
    # System installation - add to machine PATH
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    if ($null -eq $currentPath) { $currentPath = "" }
    $pathAdded = $false
    
    if ($currentPath -notlike "*$WrapperBinDir*") {
        Write-Host "  Adding $WrapperBinDir to system PATH..." -ForegroundColor Gray
        try {
            $currentPath = "$currentPath;$WrapperBinDir"
            $pathAdded = $true
        } catch {
            Write-Host "    ⚠ Warning: Could not prepare PATH update" -ForegroundColor Yellow
        }
    }
    
    if ($currentPath -notlike "*$TlangBinDir*") {
        Write-Host "  Adding $TlangBinDir to system PATH..." -ForegroundColor Gray
        try {
            $currentPath = "$currentPath;$TlangBinDir"
            $pathAdded = $true
        } catch {
            Write-Host "    ⚠ Warning: Could not prepare PATH update" -ForegroundColor Yellow
        }
    }
    
    if ($pathAdded) {
        try {
            [Environment]::SetEnvironmentVariable("Path", $currentPath, "Machine")
            # Verify it was set
            $verifyPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
            if ($verifyPath -like "*$TlangBinDir*") {
                Write-Host "    ✓ PATH configured successfully (verified)" -ForegroundColor Green
                Write-Host "    Note: You may need to restart your terminal for PATH changes to take effect" -ForegroundColor Yellow
                Write-Host "    To verify in new terminal: \$env:Path -split ';' | Select-String '$TlangBinDir'" -ForegroundColor Gray
            } else {
                Write-Host "    ⚠ Warning: PATH may not have been set correctly" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "    ✗ Failed to set PATH: $_" -ForegroundColor Red
            Write-Host "    Please add manually:" -ForegroundColor Yellow
            Write-Host "      $WrapperBinDir  (for tlang wrapper)" -ForegroundColor Yellow
            Write-Host "      $TlangBinDir  (for all executables)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  ✓ PATH already configured in system environment" -ForegroundColor Green
    }
} else {
    # User installation - add to user PATH
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($null -eq $currentPath) { $currentPath = "" }
    $pathAdded = $false
    
    if ($currentPath -notlike "*$WrapperBinDir*") {
        Write-Host "  Adding $WrapperBinDir to user PATH..." -ForegroundColor Gray
        try {
            $currentPath = "$currentPath;$WrapperBinDir"
            $pathAdded = $true
        } catch {
            Write-Host "    ⚠ Warning: Could not prepare PATH update" -ForegroundColor Yellow
        }
    }
    
    if ($currentPath -notlike "*$TlangBinDir*") {
        Write-Host "  Adding $TlangBinDir to user PATH..." -ForegroundColor Gray
        try {
            $currentPath = "$currentPath;$TlangBinDir"
            $pathAdded = $true
        } catch {
            Write-Host "    ⚠ Warning: Could not prepare PATH update" -ForegroundColor Yellow
        }
    }
    
    if ($pathAdded) {
        try {
            [Environment]::SetEnvironmentVariable("Path", $currentPath, "User")
            # Verify it was set
            $verifyPath = [Environment]::GetEnvironmentVariable("Path", "User")
            if ($verifyPath -like "*$TlangBinDir*") {
                Write-Host "    ✓ PATH configured successfully (verified)" -ForegroundColor Green
                Write-Host "    Note: You may need to restart your terminal for PATH changes to take effect" -ForegroundColor Yellow
                Write-Host "    To verify in new terminal: \$env:Path -split ';' | Select-String '$TlangBinDir'" -ForegroundColor Gray
            } else {
                Write-Host "    ⚠ Warning: PATH may not have been set correctly" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "    ✗ Failed to set PATH: $_" -ForegroundColor Red
            Write-Host "    Please add manually:" -ForegroundColor Yellow
            Write-Host "      $WrapperBinDir  (for tlang wrapper)" -ForegroundColor Yellow
            Write-Host "      $TlangBinDir  (for all executables)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  ✓ PATH already configured in user environment" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "=== Installation Complete ===" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""
Write-Host "Tlang wrapper script: $TlangWrapper" -ForegroundColor Green
Write-Host "Tlang executables:    $TlangBinDir" -ForegroundColor Green
Write-Host "  - tlangc.exe (compiler)" -ForegroundColor Gray
Write-Host "  - tlang-build.exe (build system)" -ForegroundColor Gray
Write-Host "  - tlang-port.exe (porting tool)" -ForegroundColor Gray
if ($bundledGCC) {
    Write-Host "  - gcc.exe (bundled compiler)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "GCC compiler bundled and ready to use" -ForegroundColor Green
}
Write-Host ""
Write-Host "All executables are in: $TlangBinDir" -ForegroundColor Cyan
Write-Host ""
Write-Host ""
Write-Host "Usage:" -ForegroundColor Cyan
Write-Host "  tlang compile [file.tl]     - Compile Tlang file to executable (like 'go build')"
Write-Host "  tlang run [file.tl] [args]   - Compile and run in one step (like 'go run')"
Write-Host "                                  Auto-detects entry file if not specified"
Write-Host "  tlang test [file.tl]        - Run tests"
Write-Host "  tlang build [dir]           - Build project"
Write-Host "  tlang init [app_name] [dir] - Initialize project"
Write-Host "  tlang clean [dir]            - Clean build artifacts"
Write-Host "  tlang add <pkg>@<ver> [dir] - Add package dependency"
Write-Host "  tlang get [url] [dir]      - Fetch package from Git/URL and add to project"
Write-Host "  tlang remove [pkg] [dir]   - Remove package dependency"
Write-Host "  tlang upgrade [pkg|.|*] [dir] - Upgrade package(s)"
Write-Host "  tlang version              - Show installed version"
Write-Host "  tlang port [url|file] [dest]- Convert Go/Rust to Tlang"
Write-Host "  tlang help [command]       - Show help"
Write-Host ""
