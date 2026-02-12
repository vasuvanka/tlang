# Copy only required MinGW files from C:\MinGW to deps\windows\mingw
# Run from repo root: powershell -ExecutionPolicy Bypass -File scripts\copy-mingw-to-deps.ps1 [source_path]
# Optional: $env:TLANG_MINGW_PATH or first arg as source (e.g. /c/MinGW from Git Bash)

# Convert Unix-style paths (/c/MinGW) to Windows (C:\MinGW) when needed
$rawSrc = if ($args[0]) { $args[0] } elseif ($env:TLANG_MINGW_PATH) { $env:TLANG_MINGW_PATH } else { "C:\MinGW" }
$SRC = if ($rawSrc -match '^/([a-zA-Z])/') { $rawSrc -replace '^/([a-zA-Z])/', '$1:\' -replace '/', '\' } else { $rawSrc }
$DST = "deps\windows\mingw"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
Set-Location $RepoRoot

if (-not (Test-Path "$SRC\bin\gcc.exe")) {
    Write-Host "Error: MinGW not found at $SRC" -ForegroundColor Red
    Write-Host "  Set TLANG_MINGW_PATH to your MinGW path, or use default C:\MinGW" -ForegroundColor Yellow
    exit 1
}

Write-Host "Copying required MinGW files from $SRC to $DST" -ForegroundColor Cyan

# 1. Bin — only required executables + DLLs (no mingw-get)
New-Item -ItemType Directory -Force -Path "$DST\bin" | Out-Null
$binExes = @("gcc.exe","g++.exe","cpp.exe","as.exe","ld.exe","ar.exe","ranlib.exe","objcopy.exe","objdump.exe","strip.exe","windres.exe")
foreach ($exe in $binExes) {
    if (Test-Path "$SRC\bin\$exe") { Copy-Item "$SRC\bin\$exe" -Destination "$DST\bin\" -Force }
}
Copy-Item "$SRC\bin\*.dll" -Destination "$DST\bin\" -ErrorAction SilentlyContinue
Write-Host "  bin/ done (exes + DLLs only)" -ForegroundColor Green

# 2. Libexec — only gcc part, NOT mingw-get
$gccVersion = Get-ChildItem "$SRC\libexec\gcc\mingw32" -ErrorAction SilentlyContinue | Select-Object -First 1
if ($gccVersion) {
    $gccVer = $gccVersion.Name
    New-Item -ItemType Directory -Force -Path "$DST\libexec\gcc\mingw32\$gccVer" | Out-Null
    Copy-Item "$SRC\libexec\gcc\mingw32\$gccVer\*" -Destination "$DST\libexec\gcc\mingw32\$gccVer\" -Recurse -ErrorAction SilentlyContinue
    Write-Host "  libexec/gcc/mingw32/$gccVer done" -ForegroundColor Green
} else {
    Write-Host "  Warning: libexec/gcc/mingw32 not found" -ForegroundColor Yellow
}

# 3. Include — C headers only (exclude mingw-get if present)
New-Item -ItemType Directory -Force -Path "$DST\include" | Out-Null
$includeExclude = @("mingw-get")
Get-ChildItem "$SRC\include" -ErrorAction SilentlyContinue | Where-Object { $includeExclude -notcontains $_.Name } | ForEach-Object {
    Copy-Item $_.FullName -Destination "$DST\include\" -Recurse -Force -ErrorAction SilentlyContinue
}
Write-Host "  include/ done" -ForegroundColor Green

# 4. Lib — only required files (crt*.o, lib*.a, gcc version dir); exclude mingw-get, var, etc.
New-Item -ItemType Directory -Force -Path "$DST\lib" | Out-Null
# Root .o and .a files
Copy-Item "$SRC\lib\*.o" -Destination "$DST\lib\" -ErrorAction SilentlyContinue
Copy-Item "$SRC\lib\*.a" -Destination "$DST\lib\" -ErrorAction SilentlyContinue
# lib/gcc/TARGET/VERSION/ directory
$gccLibTarget = $null
foreach ($triple in @("x86_64-w64-mingw32","i686-w64-mingw32","mingw32")) {
    if (Test-Path "$SRC\lib\gcc\$triple") {
        $gccLibTarget = $triple
        break
    }
}
if ($gccLibTarget) {
    $gccLibVer = Get-ChildItem "$SRC\lib\gcc\$gccLibTarget" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($gccLibVer) {
        $gccLibVerName = $gccLibVer.Name
        New-Item -ItemType Directory -Force -Path "$DST\lib\gcc\$gccLibTarget\$gccLibVerName" | Out-Null
        Copy-Item "$SRC\lib\gcc\$gccLibTarget\$gccLibVerName\*" -Destination "$DST\lib\gcc\$gccLibTarget\$gccLibVerName\" -Recurse -ErrorAction SilentlyContinue
    }
    Copy-Item "$SRC\lib\gcc\$gccLibTarget\*.spec" -Destination "$DST\lib\gcc\$gccLibTarget\" -ErrorAction SilentlyContinue
}
Write-Host "  lib/ done (crt, lib*.a, gcc/mingw32 only)" -ForegroundColor Green

# 5. Architecture dir (MinGW-w64: x86_64-w64-mingw32 or i686-w64-mingw32)
Get-ChildItem $SRC -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^.+?\-w64\-mingw32$' } | ForEach-Object {
    Copy-Item $_.FullName -Destination "$DST\" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "  $($_.Name)/ done" -ForegroundColor Green
}

Write-Host ""
Write-Host "Done. Verify: $DST\bin\gcc.exe --version" -ForegroundColor Cyan
