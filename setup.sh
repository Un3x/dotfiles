#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
IGNORE_DIRS=".git .github .stow-local-ignore"
IGNORE_FILES="setup.sh README.md LICENSE"

info()  { printf '\033[1;34m[info]\033[0m  %s\n' "$1"; }
warn()  { printf '\033[1;33m[warn]\033[0m  %s\n' "$1"; }
error() { printf '\033[1;31m[error]\033[0m %s\n' "$1"; }

# --- OS Detection ---
detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

# --- Install stow if missing ---
install_stow() {
    if command -v stow &>/dev/null; then
        info "GNU Stow already installed"
        return
    fi

    local os
    os="$(detect_os)"
    info "Detected OS: $os"

    case "$os" in
        ubuntu|debian|pop|linuxmint)
            info "Installing GNU Stow via apt..."
            sudo apt-get update -qq && sudo apt-get install -y -qq stow
            ;;
        fedora)
            info "Installing GNU Stow via dnf..."
            sudo dnf install -y stow
            ;;
        arch|manjaro)
            info "Installing GNU Stow via pacman..."
            sudo pacman -S --noconfirm stow
            ;;
        *)
            error "Unsupported OS: $os — install GNU Stow manually and re-run"
            exit 1
            ;;
    esac

    info "GNU Stow installed"
}

# --- Discover stow packages ---
find_packages() {
    local packages=()
    for dir in "$DOTFILES_DIR"/*/; do
        [[ ! -d "$dir" ]] && continue
        local name
        name="$(basename "$dir")"

        # Skip ignored directories
        local skip=false
        for ignore in $IGNORE_DIRS; do
            [[ "$name" == "$ignore" ]] && skip=true && break
        done
        $skip && continue

        packages+=("$name")
    done
    echo "${packages[@]}"
}

# --- Backup conflicting files before stow ---
backup_conflicts() {
    local pkg="$1"
    local pkg_dir="$DOTFILES_DIR/$pkg"

    while IFS= read -r -d '' file; do
        local rel="${file#"$pkg_dir"/}"
        local target="$HOME/$rel"

        if [[ -e "$target" && ! -L "$target" ]]; then
            local backup_path="$BACKUP_DIR/$pkg/$rel"
            mkdir -p "$(dirname "$backup_path")"
            mv "$target" "$backup_path"
            warn "Backed up $target -> $backup_path"
        fi
    done < <(find "$pkg_dir" -type f -print0)
}

# --- Stow a single package ---
stow_package() {
    local pkg="$1"
    info "Stowing: $pkg"
    backup_conflicts "$pkg"
    stow -d "$DOTFILES_DIR" -t "$HOME" --restow "$pkg"
}

# --- Main ---
main() {
    info "Dotfiles setup — $DOTFILES_DIR"

    install_stow

    read -ra packages <<< "$(find_packages)"

    if [[ ${#packages[@]} -eq 0 || -z "${packages[0]}" ]]; then
        warn "No packages found. Add config directories and re-run."
        info "Example: mkdir -p kitty/.config/kitty && stow kitty"
        info ""
        info "Reminder: set any secrets (tokens, API keys) outside this repo."
        exit 0
    fi

    info "Packages: ${packages[*]}"
    for pkg in "${packages[@]}"; do
        stow_package "$pkg"
    done

    info "Done! All packages stowed."
    info ""
    info "Reminder: set any secrets (tokens, API keys) outside this repo."
}

main "$@"
