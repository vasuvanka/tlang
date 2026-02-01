# VS Code / Cursor Extension Setup Guide

This guide explains how to install and configure the Tlang extension for VS Code and Cursor for the best development experience.

> **Note:** Cursor is a VS Code fork, so the same extension works in both editors.

## Overview

The Tlang VS Code extension provides:

- **Syntax Highlighting** - Telugu keywords, strings, numbers, comments
- **Language Server Protocol (LSP)** - Full IDE features
- **Code Completion** - IntelliSense for functions and variables
- **Error Diagnostics** - Real-time error detection
- **Hover Information** - Type information on hover
- **Go to Definition** - Navigate to declarations
- **Code Formatting** - Auto-format your code
- **File Icons** - Custom icons for `.tl` files

## Prerequisites

| Requirement | Version |
|-------------|---------|
| VS Code | 1.74.0+ |
| Node.js | 16+ |
| npm | 8+ |

## Installation Methods

### Method 1: Quick Install Script

#### Windows (PowerShell)

**For VS Code:**
```powershell
cd C:\path\to\tlang\vscode-extension
npm install && npm run compile && npm run package && code --install-extension tlang-0.1.0.vsix --force
```

**For Cursor:**
```powershell
cd C:\path\to\tlang\vscode-extension
npm install && npm run compile && npm run package && cursor --install-extension tlang-0.1.0.vsix --force
```

#### Linux/macOS (Bash)

**For VS Code:**
```bash
cd /path/to/tlang/vscode-extension
npm install && npm run compile && npm run package && code --install-extension tlang-0.1.0.vsix --force
```

**For Cursor:**
```bash
cd /path/to/tlang/vscode-extension
npm install && npm run compile && npm run package && cursor --install-extension tlang-0.1.0.vsix --force
```

### Method 2: Step-by-Step Installation

#### Step 1: Install Dependencies

```bash
cd tlang/vscode-extension
npm install
```

**What this installs:**
- `typescript` - TypeScript compiler
- `@vscode/vsce` - VS Code Extension packaging tool
- `vscode-languageclient` - LSP client library
- `@types/vscode` - VS Code API type definitions

#### Step 2: Compile TypeScript

```bash
npm run compile
```

This compiles `src/extension.ts` → `out/extension.js`

#### Step 3: Package the Extension

```bash
npm run package
```

This creates `tlang-0.1.0.vsix` - the installable extension package.

#### Step 4: Install in VS Code or Cursor

**Option A: VS Code CLI**
```bash
code --install-extension tlang-0.1.0.vsix --force
```

**Option B: Cursor CLI**
```bash
cursor --install-extension tlang-0.1.0.vsix --force
```

**Option C: GUI (both editors)**
1. Open VS Code or Cursor
2. Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (macOS)
3. Type: `Extensions: Install from VSIX...`
4. Select `tlang-0.1.0.vsix`

#### Step 5: Reload VS Code

```
Ctrl+Shift+P → "Developer: Reload Window"
```

## Language Server Setup

For full IDE features (completion, diagnostics, hover), you need the Tlang Language Server.

### Build the Language Server

```bash
# From tlang root directory
cargo build --release --bin tlang-lsp
```

### Add to PATH

**Windows:**
```powershell
# Add to user PATH (run in PowerShell as Admin)
$env:Path += ";C:\path\to\tlang\target\release"
[Environment]::SetEnvironmentVariable("Path", $env:Path, [EnvironmentVariableTarget]::User)
```

**Linux/macOS:**
```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$PATH:/path/to/tlang/target/release"
source ~/.bashrc
```

### Or Configure in VS Code Settings

```json
{
    "tlang.languageServerPath": "C:/path/to/tlang/target/release/tlang-lsp.exe"
}
```

## Configuration Options

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `tlang.languageServerPath` | string | `tlang-lsp` | Path to LSP executable |
| `tlang.enableLanguageServer` | boolean | `true` | Enable/disable LSP |

### Example settings.json

```json
{
    "tlang.languageServerPath": "tlang-lsp",
    "tlang.enableLanguageServer": true,
    "editor.formatOnSave": true,
    "[tlang]": {
        "editor.tabSize": 4,
        "editor.insertSpaces": true
    }
}
```

## Verifying Installation

### Check Extension is Active

1. Open a `.tl` file
2. Look at the bottom-right of VS Code
3. Should show "Tlang" as the language mode

### Check LSP is Working

1. Open a `.tl` file
2. Hover over a function name
3. You should see type information
4. Check `View → Output → Tlang` for LSP logs

### Test Syntax Highlighting

Create a test file `test.tl`:

```tl
@fmt = #dhimpu("std/fmt");

// This is a comment
/* Multi-line
   comment */

@PI float = 3.14159;

#prarambham() {
    @name string = "Tlang";
    @count int = 42;
    
    okavela count > 0 {
        fmt.Printf("Hello, %s!\n", name);
    } lekapothe {
        fmt.Printf("Goodbye!\n");
    }
}
```

You should see:
- Keywords (`dhimpu`, `okavela`, `lekapothe`, `prarambham`) highlighted
- Strings in quotes highlighted
- Numbers highlighted
- Comments dimmed

## Troubleshooting

### Extension Not Activating

| Problem | Solution |
|---------|----------|
| File not recognized | Ensure `.tl` extension |
| Extension not loaded | Reload VS Code window |
| Conflict with other extensions | Disable other language extensions |

### Language Server Issues

| Problem | Solution |
|---------|----------|
| LSP not starting | Check `tlang-lsp` is in PATH |
| No completions | Verify `tlang.enableLanguageServer` is `true` |
| Errors in Output | Check LSP binary is correct version |

### Syntax Highlighting Issues

| Problem | Solution |
|---------|----------|
| No colors | Check language mode is "Tlang" |
| Wrong colors | Check VS Code color theme compatibility |
| Keywords not highlighted | Verify grammar file is loaded |

## Uninstalling

### CLI

**VS Code:**
```bash
code --uninstall-extension vasuvanka.tlang
```

**Cursor:**
```bash
cursor --uninstall-extension vasuvanka.tlang
```

### GUI

1. Open Extensions sidebar (`Ctrl+Shift+X`)
2. Find "Tlang Language Support"
3. Click "Uninstall"

## Development Mode

For extension development:

```bash
cd tlang/vscode-extension
npm install
npm run watch  # Auto-compile on changes
```

Then press `F5` in VS Code to launch Extension Development Host.

## File Structure

```
vscode-extension/
├── src/
│   └── extension.ts          # Extension entry point & LSP client
├── syntaxes/
│   └── tlang.tmLanguage.json # TextMate grammar for syntax highlighting
├── out/
│   └── extension.js          # Compiled JavaScript (generated)
├── language-configuration.json # Brackets, comments, auto-close
├── package.json              # Extension manifest
├── tsconfig.json             # TypeScript config
├── tlang.png                 # Extension icon
└── README.md                 # Extension documentation
```

## See Also

- [Language Reference](language-reference.md) - Tlang syntax guide
- [Getting Started](getting-started.md) - First steps with Tlang
- [LSP Implementation](../src/lsp/) - Language Server source code
