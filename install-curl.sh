#!/bin/bash
# Tlang one-line install (rustup-style): clone repo and run install.sh with user install.
# Usage: curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/vasuvanka/tlang/main/install-curl.sh | sh
# Prerequisites: Rust, C compiler, OpenSSL dev libs. See: https://github.com/vasuvanka/tlang#readme

set -e

REPO_URL="${TLANG_REPO_URL:-https://github.com/vasuvanka/tlang.git}"
BRANCH="${TLANG_BRANCH:-main}"
INSTALL_DIR="${TMPDIR:-/tmp}/tlang-install-$$"

echo "=== Tlang curl install ==="
echo "This will clone the Tlang repository and run the install script (user install, no sudo)."
echo "Prerequisites: Rust (rustup.rs), C compiler (gcc/clang), OpenSSL dev libraries."
echo ""

if ! command -v git &>/dev/null; then
    echo "Error: git is required. Install git and try again."
    exit 1
fi

echo "Cloning $REPO_URL (branch: $BRANCH)..."
git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
cd "$INSTALL_DIR"

echo ""
echo "Running install script (USER_INSTALL=1)..."
export USER_INSTALL=1
export TLANG_NONINTERACTIVE=1
chmod +x install.sh
./install.sh

echo ""
echo "Cleaning up clone..."
cd -
rm -rf "$INSTALL_DIR"

echo ""
echo "Done. Add to PATH if needed: export PATH=\"\$PATH:\$HOME/.local/bin\""
echo "Verify: tlang --version  or  tlangc --version"
echo ""
