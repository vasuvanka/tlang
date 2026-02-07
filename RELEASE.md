# Tlang Release Guide — First Beta

Steps to run before publishing the first public beta and how to publish.

---

## 1. Pre-release checklist (do before tagging)

### 1.1 Run Rust unit tests

```bash
cargo test
```

- **Expected:** All tests pass (lexer + borrow_checker).
- **Current:** 6 tests pass.

### 1.2 Run Tlang integration tests

From repo root, using the compiler (and a C compiler + OpenSSL):

**Linux/macOS (from `tests/`):**

```bash
cd tests
./run_all_tests.sh
```

**Windows (from `tests/`):**

```cmd
cd tests
run_all_tests.bat
```

Or with `tlang` in PATH:

```bash
cd tests
tlang run test_core_features.tl
# ... run other test files as needed
```

- **Note:** Some test files may need updates for the current language (e.g. `testing.Assert(expr && expr, ...)`, `arr[0] = 10`, mutable params, multiline struct literals). Fix those or temporarily exclude them from the list in `run_all_tests.sh` / `run_all_tests.bat` so CI/local runs are green before release.

### 1.3 Version and CHANGELOG

- **Cargo.toml:** Set version to the release (e.g. `0.1.0` for first beta, or `0.1.0-beta.1` if you prefer a beta suffix).
- **CHANGELOG.md:** Add a section at the top for this release (e.g. `## 0.1.0-beta.1 - First public beta (YYYY-MM-DD)`) with:
  - Short summary (first public beta, main features).
  - Link to install instructions and docs.
  - Known limitations or test status if relevant.

### 1.4 VS Code extension (optional)

- **vscode-extension/package.json:** Set `version` to match (e.g. `0.1.0` or `0.1.0-beta.1`).
- Build and smoke-test: `npm run compile`, `npm run package`, install the `.vsix` and verify syntax/LSP.

### 1.5 Docs and install

- **README / README_INSTALL.md:** Ensure install commands (curl script, cargo, Windows) and required deps (C compiler, OpenSSL where needed) are correct.
- **Website:** If you use GitHub Pages, ensure the site and doc links work after deploy.

### 1.6 Clean build

```bash
cargo clean
cargo build --release
```

- Confirm no warnings you care about and that `tlangc`, `tlang-lsp`, `tlang-build`, `tlang-port` are produced.

---

## 2. How to publish

### 2.1 Git tag and GitHub Release

1. Commit all release changes (version, CHANGELOG, any test/script fixes).
2. Create an annotated tag:
   ```bash
   git tag -a v0.1.0 -m "First public beta"
   ```
3. Push the tag:
   ```bash
   git push origin v0.1.0
   ```
4. On GitHub: **Releases → Draft a new release**:
   - Choose tag `v0.1.0`.
   - Title: e.g. `v0.1.0 — First public beta`.
   - Description: paste or link the CHANGELOG section for this version; add install instructions and link to docs.
   - Attach binaries if you build them (e.g. `tlangc` / `tlang` for Windows, Linux, macOS) so users can download without building.

### 2.2 Building binaries for GitHub Release (optional)

- **Linux/macOS:** `cargo build --release` → attach `target/release/tlangc` (and `tlang-lsp`, etc. if you ship them).
- **Windows:** Build on Windows or use CI; attach `tlangc.exe` and optionally `tlang-lsp.exe`.
- You can add a GitHub Actions workflow that runs on tag push, builds for multiple targets, and uploads artifacts to the release.

### 2.3 crates.io (Rust package, optional)

If you want the compiler as a Rust crate:

1. Create an account on [crates.io](https://crates.io).
2. `cargo publish --dry-run` to check.
3. `cargo publish` (requires crate name availability; your `Cargo.toml` already has `name = "tlang"`).

### 2.4 VS Code Marketplace (optional)

1. Create a [Visual Studio Marketplace](https://marketplace.visualstudio.com/) publisher account.
2. In `vscode-extension/`: `npm run package` to produce the `.vsix`.
3. Install the [vsce](https://github.com/microsoft/vscode-vsce) CLI and run:
   ```bash
   vsce publish -p <your-personal-access-token>
   ```
   Or publish manually by uploading the `.vsix` in the marketplace web UI.

---

## 3. After release

- Announce (e.g. GitHub Discussion, blog, or social) with link to the release and docs.
- Watch issues for install or compatibility problems and update README/CHANGELOG as needed.

---

## 4. Current test status (as of this guide)

| Suite | Status | Notes |
|-------|--------|--------|
| **Rust unit tests** (`cargo test`) | ✅ 6 passed | lexer + borrow_checker |
| **Tlang integration** (`tests/run_all_tests.sh`) | ⚠️ Compile failures | Several test files hit parser/semantic limits (e.g. `Assert(..., &&, ...)`, `arr[0]=...`, param syntax, struct literal formatting). Fix tests or compiler before marking beta “all green,” or document known gaps. |

Fixing the test script to respect Tlang compile exit code is done; re-run from `tests/` after any compiler or test file changes.
