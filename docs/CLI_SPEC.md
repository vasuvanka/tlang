# Tlang CLI Specification

The `tlang` command is the unified entry point for all Tlang tooling.

---

## Commands

### Build & Run

| Command | Description | Example |
|---------|-------------|---------|
| `tlang run [file.tl] [args]` | Compile and run. Auto-detects `main.tl` or `adhi.tl` if file omitted. | `tlang run main.tl` |
| `tlang compile <file.tl> [output]` | Compile Tlang file to executable. | `tlang compile main.tl app` |
| `tlang build [dir]` | Build project (uses config.toml). | `tlang build` |

### Porting

| Command | Description | Example |
|---------|-------------|---------|
| `tlang port <url \| package \| file> [destination]` | Convert Go or Rust to Tlang. Input: file, directory, URL, or pkg.go.dev path. | `tlang port https://pkg.go.dev/go.mongodb.org/mongo-driver mongo` |
| | | `tlang port main.go main.tl` |

### Dependencies

| Command | Description | Example |
|---------|-------------|---------|
| `tlang get <git \| url>` | Fetch package from Git or URL and add to project. | `tlang get https://github.com/user/repo` |
| `tlang add <package>@<version> [dir]` | Add package dependency. | `tlang add github.com/user/pkg@v1.0.0` |
| `tlang remove <package> [dir]` | Remove package dependency. | `tlang remove my-pkg` |
| `tlang upgrade [package \| . \| *] [dir]` | Upgrade package(s). | `tlang upgrade .` |

### Project

| Command | Description | Example |
|---------|-------------|---------|
| `tlang init [app_name] [dir]` | Initialize new project. | `tlang init myapp` |
| `tlang clean [dir]` | Remove build artifacts. | `tlang clean` |
| `tlang test <file.tl>` | Compile and run test file. | `tlang test tests/foo.tl` |

### Info

| Command | Description | Example |
|---------|-------------|---------|
| `tlang version` | Show Tlang version. | `tlang version` |
| `tlang help` | Show help. | `tlang help` |
| `tlang help <command>` | Show help for a command. | `tlang help port` |

### Flags

| Flag | Description |
|------|-------------|
| `--version`, `-v` | Show version (same as `tlang version`). |

---

## Port Command Details

```
tlang port [--from go|rust] <input> [output]
```

- **Input:** File, directory, URL, or pkg.go.dev package path
- **Output:** File or directory (optional; inferred from input if omitted)
- **--from:** Force source language (go or rust) when auto-detection fails

Examples:
```bash
tlang port main.go main.tl
tlang port ./src ./tlang_out
tlang port https://github.com/user/repo/blob/main/cmd/main.go
tlang port https://pkg.go.dev/go.mongodb.org/mongo-driver/v2/mongo mongo
tlang port --from rust ./src ./out
```

---

## Get Command Details

```
tlang get <url>
```

Fetches a package from a Git URL or HTTP URL and adds it to the current project's `config.toml`.

Examples:
```bash
tlang get https://github.com/vasuvanka/tlang-libs
tlang get github.com/user/repo
```

---

## Implementation Notes

- **tlang** is the main entry point (wrapper script or native binary).
- **tlangc** — compiler (run, compile, build).
- **tlang-build** — build system (build, init, add, remove, upgrade, clean).
- **tlang-port** — porting tool (Go/Rust → Tlang).

The wrapper script delegates to these binaries. A future native `tlang` binary could subsume them.

---

*Last updated: February 2026*
