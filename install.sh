#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${HOME}/.local/bin"

echo "=== Installing Placeholder-Rsync-Resolver ==="

# Check Python 3
if ! command -v python3 >/dev/null 2>&1; then
    echo "Error: python3 is required but not installed." >&2
    exit 1
fi

# Check rsync
if ! command -v rsync >/dev/null 2>&1; then
    echo "Warning: rsync is not installed. Please install rsync via your package manager." >&2
fi

# Install Python dependencies
if [ -f "${SCRIPT_DIR}/requirements.txt" ]; then
    echo "Installing Python dependencies from requirements.txt..."
    python3 -m pip install -r "${SCRIPT_DIR}/requirements.txt" 2>/dev/null || pip install -r "${SCRIPT_DIR}/requirements.txt" || echo "Note: Check that dependencies (Flask) are satisfied."
fi

mkdir -p "${BIN_DIR}"

cat <<'LAUNCHER' > "${BIN_DIR}/placeholder-rsync-resolver"
#!/usr/bin/env bash
REAL_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
DIR_PATH="$(dirname "$REAL_DIR")/Placeholder-Rsync-Resolver"
if [ ! -f "${DIR_PATH}/cli.py" ]; then
    DIR_PATH="${HOME}/Projects/Thunar-Action/Placeholder-Rsync-Resolver"
fi
if [ -f "${DIR_PATH}/cli.py" ]; then
    python3 "${DIR_PATH}/cli.py" "$@"
else
    python3 -m resolver.cli "$@" 2>/dev/null || python3 "$(dirname "${BASH_SOURCE[0]}")/cli.py" "$@"
fi
LAUNCHER
chmod +x "${BIN_DIR}/placeholder-rsync-resolver"

cat <<'LAUNCHER' > "${BIN_DIR}/placeholder-rsync-resolver-gui"
#!/usr/bin/env bash
REAL_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
DIR_PATH="$(dirname "$REAL_DIR")/Placeholder-Rsync-Resolver"
if [ ! -f "${DIR_PATH}/gui.py" ]; then
    DIR_PATH="${HOME}/Projects/Thunar-Action/Placeholder-Rsync-Resolver"
fi
if [ -f "${DIR_PATH}/gui.py" ]; then
    python3 "${DIR_PATH}/gui.py" "$@"
else
    python3 "$(dirname "${BASH_SOURCE[0]}")/gui.py" "$@"
fi
LAUNCHER
chmod +x "${BIN_DIR}/placeholder-rsync-resolver-gui"

cat <<'LAUNCHER' > "${BIN_DIR}/placeholder-rsync-resolver-web"
#!/usr/bin/env bash
REAL_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
DIR_PATH="$(dirname "$REAL_DIR")/Placeholder-Rsync-Resolver"
if [ ! -f "${DIR_PATH}/web.py" ]; then
    DIR_PATH="${HOME}/Projects/Thunar-Action/Placeholder-Rsync-Resolver"
fi
if [ -f "${DIR_PATH}/web.py" ]; then
    python3 "${DIR_PATH}/web.py" "$@"
else
    python3 "$(dirname "${BASH_SOURCE[0]}")/web.py" "$@"
fi
LAUNCHER
chmod +x "${BIN_DIR}/placeholder-rsync-resolver-web"

echo "Placeholder-Rsync-Resolver installed successfully!"
echo "Available commands in ~/.local/bin/:"
echo "  - placeholder-rsync-resolver (CLI)"
echo "  - placeholder-rsync-resolver-gui (Desktop GUI)"
echo "  - placeholder-rsync-resolver-web (Flask Web Dashboard)"
