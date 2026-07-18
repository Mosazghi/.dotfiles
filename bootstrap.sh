#!/usr/bin/env bash
set -Eeuo pipefail

# - Cross-distro friendly (apt, dnf, pacman, zypper, apk)
# - Re-runnable/idempotent
# - Installs tools referenced by your configs (zsh, nvim, stow, kitty, etc.)

log() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
err() { printf "\033[1;31m[ERR ]\033[0m %s\n" "$*" >&2; }

need_cmd() { command -v "$1" >/dev/null 2>&1; }

SUDO=""
if [[ "${EUID}" -ne 0 ]]; then
    if need_cmd sudo; then
        SUDO="sudo"
    else
        err "Please run as root or install sudo."
        exit 1
    fi
fi

detect_pm() {
    if need_cmd apt-get; then
        echo "apt"
    elif need_cmd dnf; then
        echo "dnf"
    elif need_cmd pacman; then
        echo "pacman"
    elif need_cmd zypper; then
        echo "zypper"
    elif need_cmd apk; then
        echo "apk"
    else
        echo ""
    fi
}

PM="$(detect_pm)"
[[ -n "$PM" ]] || {
    err "Unsupported distro: no apt/dnf/pacman/zypper/apk found."
    exit 1
}
log "Detected package manager: $PM"

refresh_repos() {
    case "$PM" in
    apt) $SUDO apt-get update -y ;;
    dnf) $SUDO dnf makecache -y ;;
    pacman) $SUDO pacman -Sy --noconfirm ;;
    zypper) $SUDO zypper --gpg-auto-import-keys refresh ;;
    apk) $SUDO apk update ;;
    esac
}

is_installed() {
    local pkg="$1"
    case "$PM" in
    apt) dpkg -s "$pkg" >/dev/null 2>&1 ;;
    dnf) rpm -q "$pkg" >/dev/null 2>&1 ;;
    pacman) pacman -Q "$pkg" >/dev/null 2>&1 ;;
    zypper) rpm -q "$pkg" >/dev/null 2>&1 ;;
    apk) apk info -e "$pkg" >/dev/null 2>&1 ;;
    esac
}

install_pkg() {
    # Usage: install_pkg "label" pkg1 pkg2 ...
    local label="$1"
    shift
    local pkg
    for pkg in "$@"; do
        if is_installed "$pkg"; then
            log "$label already installed via package '$pkg'"
            return 0
        fi

        case "$PM" in
        apt) $SUDO apt-get install -y "$pkg" >/dev/null 2>&1 && {
            log "Installed $label ($pkg)"
            return 0
        } ;;
        dnf) $SUDO dnf install -y "$pkg" >/dev/null 2>&1 && {
            log "Installed $label ($pkg)"
            return 0
        } ;;
        pacman) $SUDO pacman -S --noconfirm --needed "$pkg" >/dev/null 2>&1 && {
            log "Installed $label ($pkg)"
            return 0
        } ;;
        zypper) $SUDO zypper --non-interactive install "$pkg" >/dev/null 2>&1 && {
            log "Installed $label ($pkg)"
            return 0
        } ;;
        apk) $SUDO apk add --no-interactive "$pkg" >/dev/null 2>&1 && {
            log "Installed $label ($pkg)"
            return 0
        } ;;
        esac
    done

    warn "Could not install $label (tried: $*)"
    return 1
}

install_pkg_w_curl() {
    local label="$1"
    local pkg="$2"
    local url="$3"
    if is_installed "$pkg"; then
        log "$label already installed via package '$pkg'"
        return 0
    fi

    if curl -fsSL "$url" | bash; then
        log "Installed $label ($pkg)"
        return 0
    else
        log "Failed to install $label"
        return 1
    fi
}

ensure_oh_my_zsh() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log "oh-my-zsh already installed"
        return 0
    fi
    if need_cmd git && need_cmd curl; then
        log "Installing oh-my-zsh (unattended)"
        RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" ||
            warn "oh-my-zsh install failed; you can run it manually later."
    else
        warn "Skipping oh-my-zsh install (git/curl missing)"
    fi
}

ensure_zsh_autosuggestions() {
    local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    if [[ -d "$plugin_dir" ]]; then
        log "zsh-autosuggestions already present"
        return 0
    fi
    if need_cmd git; then
        log "Installing zsh-autosuggestions plugin"
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$plugin_dir" ||
            warn "Failed to clone zsh-autosuggestions"
    fi
}

set_zsh_default_shell() {
    need_cmd zsh || return 0
    local zsh_path
    zsh_path="$(command -v zsh)"
    [[ "${SHELL:-}" == "$zsh_path" ]] && {
        log "Default shell already zsh"
        return 0
    }

    if [[ -w /etc/shells ]] || [[ -n "$SUDO" ]]; then
        grep -qx "$zsh_path" /etc/shells 2>/dev/null || echo "$zsh_path" | $SUDO tee -a /etc/shells >/dev/null
    fi

    chsh -s "$zsh_path" "$USER" || warn "Could not change shell automatically. Run: chsh -s $zsh_path"
}

install_core() {
    # Base tooling
    install_pkg "git" git
    install_pkg "curl" curl
    install_pkg "wget" wget
    install_pkg "stow" stow
    install_pkg "zsh" zsh
    install_pkg "neovim" neovim
    install_pkg "kitty" kitty
    install_pkg "lazygit" lazygit
    install_pkg "fastfetch" fastfetch
    install_pkg "fzf" fzf
    install_pkg "ripgrep" ripgrep
    install_pkg "fd" fd-find fd fdfind
    install_pkg "bat" bat
    install_pkg "eza" eza exa
    install_pkg "xclip" xclip wl-clipboard
    install_pkg "build tools" build-essential base-devel gcc make clang
    install_pkg "unzip" unzip
    install_pkg "tar" tar
    install_pkg "starship" starship
    install_pkg_w_curl "fnm" "fnm" "https://fnm.vercel.app/install"
    install_pkg_w_curl "rustup" "rustup" "https://sh.rustup.rs"
    install_pkg "go" golang-go go
    install_pkg "cargo" cargo

}

npm_global_install_if_missing() {
    local cmd="$1" pkg="$2"
    if need_cmd "$cmd"; then
        log "$cmd already installed"
        return 0
    fi
    if need_cmd npm; then
        npm install -g "$pkg" >/dev/null 2>&1 && log "Installed npm global: $pkg" || warn "Failed npm -g install: $pkg"
    fi
}

main() {
    refresh_repos
    install_core

    ensure_oh_my_zsh
    ensure_zsh_autosuggestions
    set_zsh_default_shell

    cat <<'EOF'

Bootstrap complete.

Next steps (from repo root):
  stow zsh
  stow nvim
  stow kitty

Then restart shell:
  exec zsh

Tip:
  Re-run bootstrap.sh anytime; it is safe and idempotent.
EOF
}

main "$@"
