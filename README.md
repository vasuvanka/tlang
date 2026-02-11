# Tlang

A compiled programming language for Telugu, inspired by Go. Simple, explicit, and fast. Compiles to C.

![Tlang logo (అ / Aa)](https://vasuvanka.github.io/tlang/tlang-logo.png)

## Installation

**Prerequisites:** Rust ([rustup.rs](https://rustup.rs)), C compiler (or bundled GCC on Windows), OpenSSL dev libs. See [Installation Guide](README_INSTALL.md) for details.

### Single-link install (any OS)

**Linux / macOS / WSL:**
```bash
curl -fsSL https://raw.githubusercontent.com/vasuvanka/tlang/main/install.sh | bash
```

**Windows (PowerShell):**
```powershell
iwr -useb https://raw.githubusercontent.com/vasuvanka/tlang/main/install.ps1 | iex
```

**Windows (CMD):**
```cmd
curl -fsSL https://raw.githubusercontent.com/vasuvanka/tlang/main/install.cmd -o install.cmd && install.cmd && del install.cmd
```

Then add the install directory to your PATH if needed (e.g. `~/.local/bin` or `%LOCALAPPDATA%\Programs\bin`). Verify: `tlang --version` or `tlangc --version`.

For clone-and-install, manual install, and prerequisites by platform, see **[README_INSTALL.md](README_INSTALL.md)**.

## Quick start

```tl
@fmt = #dhimpu("std/fmt");

#prarambham() {
    fmt.Printf("Hello, Tlang!\n");
}
```

Save as `hello.tl`, then: `tlang run hello.tl` or `tlang compile hello.tl hello && ./hello`.

## Links

- **Docs:** [Getting Started](docs/getting-started.md), [Language Reference](docs/language-reference.md), [Standard Library](docs/standard-library.md)
- **Website / Playground:** [vasuvanka.github.io/tlang](https://vasuvanka.github.io/tlang)
- **GitHub:** [github.com/vasuvanka/tlang](https://github.com/vasuvanka/tlang)

## License

MIT. © VasuVanka.
