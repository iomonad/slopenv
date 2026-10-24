#!/usr/bin/env bash
set -e

INSTALL_DIR="${XDG_BIN_HOME:-$HOME/.local/bin}"

usage() {
  echo "Usage: $(basename "$0") [install-dir]" >&2
  echo "Default install dir: $INSTALL_DIR" >&2
  exit 1
}

if [ $# -gt 1 ]; then
  usage
fi

if [ $# -eq 1 ]; then
  INSTALL_DIR="$1"
fi

mkdir -p "$INSTALL_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$SCRIPT_DIR/bin/slopenv"

if [ ! -f "$SRC" ]; then
  echo "Error: $SRC not found" >&2
  exit 1
fi

cp "$SRC" "$INSTALL_DIR/slopenv"
chmod +x "$INSTALL_DIR/slopenv"

echo "Installed slopenv to $INSTALL_DIR/slopenv"

case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *)
    echo "Note: $INSTALL_DIR is not in your PATH. Add it to your shell rc:"
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
    ;;
esac
