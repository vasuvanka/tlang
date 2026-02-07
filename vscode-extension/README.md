# Tlang VS Code Extension

![Tlang logo (అ / Aa)](https://vasuvanka.github.io/tlang/tlang-logo.png)

Language support for Tlang - A compiled programming language for Telugu, inspired by Go.

## Features

- **Syntax Highlighting** - Full syntax highlighting for `.tl` files (keywords and operators aligned with [Reserved Keywords](https://vasuvanka.github.io/tlang/docs/reserved-keywords); move/channel use `<-` only, no `jarugu` keyword)
- **Language Server Protocol (LSP)** - Code completion, hover information, go-to-definition, diagnostics, and formatting
- **IntelliSense** - Smart code completion and suggestions
- **Error Diagnostics** - Real-time error detection and reporting
- **Code Formatting** - Automatic code formatting support
- **File Icons** - Custom icons for `.tl` files in the file explorer

## Requirements

- VS Code 1.74.0 or higher
- Node.js 16+ (for building from source)
- Tlang compiler installed with `tlang-lsp` in your PATH, or configure the path in settings

## Installation

### Quick Install (Recommended)

#### Windows (PowerShell)

```powershell
cd path\to\tlang\vscode-extension
npm install
npm run compile
npm run package
code --install-extension tlang-0.1.0.vsix --force
```

#### Linux/macOS (Bash)

```bash
cd path/to/tlang/vscode-extension
npm install
npm run compile
npm run package
code --install-extension tlang-0.1.0.vsix --force
```

### Step-by-Step Installation

#### Step 1: Navigate to Extension Directory

```bash
cd tlang/vscode-extension
```

#### Step 2: Install Dependencies

```bash
npm install
```

This installs:
- TypeScript compiler
- VS Code Extension tools (vsce)
- Language Server client library

#### Step 3: Compile TypeScript

```bash
npm run compile
```

This compiles `src/extension.ts` to `out/extension.js`.

#### Step 4: Package the Extension

```bash
npm run package
```

This creates a `.vsix` file (e.g., `tlang-0.1.0.vsix`) which is the installable extension package.

#### Step 5: Install the Extension

**Option A: Using VS Code CLI**

```bash
code --install-extension tlang-0.1.0.vsix --force
```

**Option B: Using Cursor CLI**

```bash
cursor --install-extension tlang-0.1.0.vsix --force
```

**Option C: Using GUI (VS Code or Cursor)**

1. Open VS Code or Cursor
2. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on macOS)
3. Type "Extensions: Install from VSIX..."
4. Select the `tlang-0.1.0.vsix` file

**Option D: Development Mode (for testing)**

1. Open the `vscode-extension` folder in VS Code/Cursor
2. Press `F5` to launch a new window with the extension loaded

#### Step 6: Reload VS Code

After installation, reload VS Code:
- Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on macOS)
- Type "Developer: Reload Window"
- Press Enter

## Configuration

The extension can be configured via VS Code settings (`Ctrl+,` or `Cmd+,`):

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `tlang.languageServerPath` | string | `tlang-lsp` | Path to the `tlang-lsp` executable |
| `tlang.enableLanguageServer` | boolean | `true` | Enable/disable the language server |

### Example Configuration (settings.json)

```json
{
    "tlang.languageServerPath": "C:/path/to/tlang-lsp.exe",
    "tlang.enableLanguageServer": true
}
```

## Building the Language Server

For full LSP support, you need to build and install `tlang-lsp`:

```bash
# From the tlang root directory
cargo build --release --bin tlang-lsp

# The binary will be at:
# Windows: target/release/tlang-lsp.exe
# Linux/macOS: target/release/tlang-lsp
```

Add the binary to your PATH or configure `tlang.languageServerPath` in VS Code settings.

## Usage

1. Open a `.tl` file in VS Code
2. The extension will automatically activate
3. Enjoy syntax highlighting, IntelliSense, and other language features!

### Supported Features

| Feature | Description |
|---------|-------------|
| Syntax Highlighting | Telugu keywords, strings, numbers, comments |
| Code Completion | Function names, variables, keywords |
| Hover Information | Type information and documentation |
| Go to Definition | Jump to function/variable definitions |
| Error Diagnostics | Real-time syntax and type error reporting |
| Code Formatting | Auto-format on save (if enabled) |

### File Icons

To enable file icons for `.tl` files:

1. Open VS Code Settings (`Ctrl+,` or `Cmd+,`)
2. Search for "File Icon Theme"
3. Select "Tlang Icons" from the dropdown
4. `.tl` files will now display with the Tlang icon in the file explorer

## Commands

| Command | Description |
|---------|-------------|
| `Tlang: Restart Language Server` | Restart the Tlang language server |

## Troubleshooting

### Extension not activating

1. Ensure the file has a `.tl` extension
2. Reload VS Code (`Ctrl+Shift+P` → "Developer: Reload Window")
3. Check the Output panel (`View` → `Output` → Select "Tlang")

### Language Server not working

1. Verify `tlang-lsp` is in your PATH:
   ```bash
   tlang-lsp --version
   ```
2. Or set the full path in settings:
   ```json
   {
       "tlang.languageServerPath": "/full/path/to/tlang-lsp"
   }
   ```
3. Check the Output panel for error messages

### Syntax highlighting not working

1. Ensure the file extension is `.tl`
2. Check that the language mode is set to "Tlang" (bottom-right of VS Code)
3. Try reloading the window

## Development

To contribute or modify the extension:

1. Clone the repository
2. Open `vscode-extension` folder in VS Code
3. Run `npm install` to install dependencies
4. Make changes to files in `src/`
5. Run `npm run watch` to automatically compile on changes
6. Press `F5` to test the extension in a new window

### Project Structure

```
vscode-extension/
├── src/
│   └── extension.ts      # Main extension entry point
├── syntaxes/
│   └── tlang.tmLanguage.json  # Syntax highlighting (keywords, @, #, prarambham, dhimpu, etc.)
├── language-configuration.json  # Language config (brackets, comments)
├── package.json          # Extension manifest
├── tsconfig.json         # TypeScript configuration
├── tlang.png             # Extension icon
└── README.md             # This file
```

## Uninstalling

```bash
code --uninstall-extension vasuvanka.tlang
```

Or through VS Code:
1. Open Extensions (`Ctrl+Shift+X`)
2. Find "Tlang Language Support"
3. Click "Uninstall"

## License

MIT
