# Tlang Project Manifest (config.toml)

The `config.toml` file is the project manifest for Tlang, similar to `Cargo.toml` (Rust), `go.mod` (Go), or `package.json` (Node.js). It defines your project's metadata, dependencies, and build configuration.

## File Location

The manifest file must be named `config.toml` and placed in your project root directory.

## Structure

```toml
[package]
name = "myapp"
version = "0.1.0"
description = "My Tlang application"
author = "Your Name"
license = "MIT"
repository = "https://github.com/user/myapp"

[build]
output_dir = "target"
binary_name = "myapp"
entry_file = "src/main.tl"  # Optional: specify entry point file
static_link = true
optimize = "speed"
debug = false

[dependencies]
utils = { path = "./libs/utils", version = "0.1.0" }

[dev-dependencies]
test-helpers = { path = "./test-helpers", version = "0.1.0", optional = true }

# Ignore packages (exclude from dependency resolution)
ignore = ["experimental-pkg", "deprecated-lib"]
```

## Package Section

The `[package]` section defines your project's metadata:

- **`name`** (required) - Package name
- **`version`** (default: "0.1.0") - Semantic version
- **`description`** (optional) - Project description
- **`author`** (optional) - Author name
- **`license`** (optional) - License identifier
- **`repository`** (optional) - Repository URL

## Build Section

The `[build]` section configures how your project is built:

- **`output_dir`** (default: "target") - Output directory for build artifacts
- **`binary_name`** (default: "app") - Name of the generated binary
- **`entry_file`** (optional) - Entry point file for the project (e.g., "src/main.tl", "app.tl"). If not specified, the build system will auto-detect by looking for `prarambham.tl`, `main.tl`, or `{package_name}.tl`
- **`static_link`** (default: true) - Static linking for standalone binary
- **`optimize`** (default: "speed") - Optimization level: "none", "size", or "speed"
- **`debug`** (default: false) - Include debug symbols
- **`compiler_flags`** (default: []) - Additional compiler flags
- **`linker_flags`** (default: []) - Additional linker flags

## Dependencies

### Direct Dependencies

Direct dependencies are listed in the `[dependencies]` section:

```toml
[dependencies]
utils = { path = "./libs/utils", version = "0.1.0" }
```

### Dependency Sources

Dependencies can be specified from different sources:

#### Local Path

```toml
[dependencies]
utils = { path = "./libs/utils", version = "0.1.0" }
```

#### HTTP/HTTPS URL

```toml
[dependencies]
utils = { http = "https://example.com/packages/utils.zip", version = "1.0.0" }
utils = { http = "https://example.com/packages/utils.tar.gz" }
```

**Supported formats:**
- ZIP archives (`.zip`)
- TAR archives (`.tar`)
- Gzipped TAR archives (`.tar.gz`, `.tgz`)
- Single `.tl` files

**Usage:**
```bash
tlang add https://example.com/packages/utils.zip
tlang add https://example.com/packages/utils.tar.gz@1.0.0
```

#### Git Repository (Future)

```toml
[dependencies]
http-client = { git = "https://github.com/user/tlang-http-client", branch = "main" }
http-client = { git = "https://github.com/user/tlang-http-client", tag = "v1.0.0" }
http-client = { git = "https://github.com/user/tlang-http-client", rev = "abc123" }
```

#### Registry (Future)

```toml
[dependencies]
json = { registry = "tlang", version = "1.0.0" }
```

### Optional Dependencies

Mark dependencies as optional:

```toml
[dependencies]
optional-lib = { path = "./libs/optional", version = "0.1.0", optional = true }
```

### Dev Dependencies

Development-only dependencies:

```toml
[dev-dependencies]
test-helpers = { path = "./test-helpers", version = "0.1.0" }
```

### Ignore Packages

Exclude packages from dependency resolution. Useful for:
- Experimental packages that shouldn't be included
- Packages in dependencies that you want to exclude
- Deprecated packages

```toml
ignore = ["experimental-pkg", "deprecated-lib", "unused-dependency"]
```

**Note:** Ignored packages are skipped during dependency resolution, even if they appear as transitive dependencies.

## Indirect Dependencies

Indirect (transitive) dependencies are automatically resolved and tracked. When you depend on a package that itself has dependencies, those are automatically included.

**Example:**
```
Your Project
  └── utils (direct)
      └── strings (indirect - dependency of utils)
```

## Lock File (config.lock)

The build system automatically generates a `config.lock` file (similar to `Cargo.lock` or `go.sum`) that:

- Locks exact versions of all dependencies (direct + indirect)
- Stores checksums for integrity verification
- Ensures reproducible builds
- Tracks dependency graph

**Note:** `config.lock` should be committed to version control for applications, but not for libraries.

### Lock File Structure

```toml
version = "1"

[[dependencies]]
name = "utils"
version = "0.1.0"
type = "path"
path = "./libs/utils"
checksum = "abc123..."
dependencies = ["strings"]

[[indirect_dependencies]]
name = "strings"
version = "0.1.0"
type = "path"
path = "./libs/strings"
checksum = "def456..."
dependencies = []
```

## Dependency Resolution

The build system resolves dependencies in this order:

1. **Check lock file** - Use exact versions from `config.lock` if it exists
2. **Resolve direct dependencies** - From `[dependencies]` section
3. **Resolve transitive dependencies** - Recursively resolve dependencies of dependencies
4. **Update lock file** - Save resolved versions to `config.lock`

### Circular Dependency Detection

The build system detects and prevents circular dependencies:

```toml
# Error: Circular dependency detected: package 'utils' is being loaded recursively
```

## Version Constraints

Version constraints can be specified (future feature):

```toml
[dependencies]
# Exact version
lib = { path = "./libs/lib", version = "1.0.0" }

# Version range (future)
# lib = { registry = "tlang", version = "^1.0.0" }  # >= 1.0.0, < 2.0.0
# lib = { registry = "tlang", version = "~1.0.0" }  # >= 1.0.0, < 1.1.0
```

## Examples

### Minimal Manifest

```toml
[package]
name = "hello"
version = "0.1.0"
```

### With Dependencies

```toml
[package]
name = "webapp"
version = "0.1.0"
description = "A web application"
author = "John Doe"

[build]
binary_name = "webapp"
static_link = true

[dependencies]
http = { path = "./libs/http", version = "0.1.0" }
json = { path = "./libs/json", version = "0.1.0" }
```

### With Dev Dependencies

```toml
[package]
name = "library"
version = "0.1.0"

[dependencies]
utils = { path = "./libs/utils", version = "0.1.0" }

[dev-dependencies]
test-helpers = { path = "./test-helpers", version = "0.1.0" }
```

## Commands

### Initialize Project

```bash
tlang init [app_name] [directory]
```

Creates a new project with `config.toml` and a basic hello world program. If directory is not specified, uses current directory.

**Example:**
```bash
tlang init                    # Initialize current directory (auto-detect name)
tlang init myapp              # Initialize with app name "myapp" in current directory
tlang init myapp ./myproject  # Initialize with app name "myapp" in ./myproject directory
```

**What it creates:**
- `config.toml` - Project manifest with name and version "1.0.0"
- `src/prarambham.tl` - Entry point file with hello world
- Sets `entry_file = "src/prarambham.tl"` in config.toml

### Build Project

```bash
tlang build [directory]
```

Resolves dependencies and builds the project. Updates `config.lock` if dependencies changed. If directory is not specified, uses current directory.

**Example:**
```bash
tlang build          # Build current directory
tlang build ./myapp  # Build specified directory
```

### Clean Project

```bash
tlang clean [directory]
```

Removes all build artifacts. If directory is not specified, uses current directory.

### Add Package

```bash
tlang add <package|url>@<version> [directory]
```

Adds a package dependency to `config.toml`. If directory is not specified, uses current directory.

**Examples:**

**Local path dependency:**
```bash
tlang add utils@0.1.0           # Add to current directory
tlang add utils@0.1.0 ./myapp   # Add to specified directory
```

**HTTP/HTTPS URL dependency:**
```bash
tlang add https://example.com/packages/utils.zip
tlang add https://example.com/packages/utils.tar.gz@1.0.0
tlang add https://example.com/utils.tl
```

**Supported URL formats:**
- ZIP archives: `.zip`
- TAR archives: `.tar`, `.tar.gz`, `.tgz`
- Single Tlang files: `.tl`

When adding from HTTP/HTTPS, the package is automatically downloaded to `dependencies/` directory and the URL is saved in `config.toml`.

**Note:** For local path dependencies, this adds a default relative path. You may need to update the path in `config.toml` after adding.

### Remove Package

```bash
tlang remove <package> [directory]
```

Removes a package dependency from `config.toml`. If directory is not specified, uses current directory.

**Example:**
```bash
tlang remove utils           # Remove from current directory
tlang remove utils ./myapp  # Remove from specified directory
```

### Upgrade Package

```bash
tlang upgrade <package|.|*> [directory]
```

Upgrades package(s) to their latest version. Use `.` or `*` to upgrade all packages. If directory is not specified, uses current directory.

**Example:**
```bash
tlang upgrade utils          # Upgrade specific package
tlang upgrade .             # Upgrade all packages
tlang upgrade *             # Upgrade all packages (alternative)
tlang upgrade utils ./myapp # Upgrade in specified directory
```

**Note:** Currently, upgrade only works for path dependencies. It checks the package's `config.toml` for the latest version and updates your project's `config.toml` accordingly.

## Dependency Format

Dependencies can be specified in two formats:

**Inline format (recommended):**
```toml
[dependencies]
utils = { path = "./libs/utils", version = "0.1.0" }
```

**Table format (also supported):**
```toml
[[dependencies]]
name = "utils"
path = "./libs/utils"
version = "0.1.0"
```

## See Also

- [Build System Guide](build-system.md)
- [Package System](packages.md)
