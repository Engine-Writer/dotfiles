#!/usr/bin/env zsh
set -uo pipefail

DOTFILES_DIR="$(cd "$(dirname "${0}")" && pwd)"

typeset -A PACKAGES
PACKAGES=(
  hyprland   "$HOME/.config/hypr"
  kitty      "$HOME/.config/kitty"
  waybar     "$HOME/.config/waybar"
  starship   "$HOME/.config/starship.toml"
  ulauncher  "$HOME/.config/ulauncher"
  swaync     "$HOME/.config/swaync"
  qt6ct      "$HOME/.config/qt6ct"
  fontconfig "$HOME/.config/fontconfig"
  wofi       "$HOME/.config/wofi"
  swappy     "$HOME/.config/swappy"
)

LOOSE_FILES=(.zshrc .XCompose)

GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
RED=$'\033[0;31m'
NC=$'\033[0m'

echo -e "${YELLOW}==> Starting dotfiles uninstallation...${NC}"

if command -v stow >/dev/null 2>&1; then
    echo -e "${YELLOW}==> Removing symlinks...${NC}"
    for pkg target in ${(kv)PACKAGES}; do
        if [[ ! -e "$target" ]]; then
            continue
        fi
        
        stow -D -v --target="$HOME" "$pkg" >/dev/null 2>&1 || true
        echo -e "  ${GREEN}[Unstowed]${NC} $pkg"
    done
else
    echo -e "${RED}Error: GNU Stow is not installed. Cannot cleanly unstow.${NC}"
fi

echo -e "${YELLOW}==> Removing loose file links...${NC}"
for file in "${LOOSE_FILES[@]}"; do
    if [[ -L "$HOME/$file" ]]; then
        rm "$HOME/$file"
        echo -e "  ${GREEN}[Removed Link]${NC} ~/$file"
    fi
done

echo -e "${YELLOW}==> Restoring backups...${NC}"

for pkg target in ${(kv)PACKAGES}; do
    BAK_TARGET="${target}.bak"
    
    if [[ -e "$BAK_TARGET" ]]; then
        if [[ -e "$target" || -L "$target" ]]; then
            rm -rf "$target"
        fi
        mv "$BAK_TARGET" "$target"
        echo -e "  ${GREEN}[Restored]${NC} $target"
    fi
done

for file in "${LOOSE_FILES[@]}"; do
    BAK_TARGET="$HOME/$file.bak"
    
    if [[ -e "$BAK_TARGET" ]]; then
        if [[ -e "$HOME/$file" || -L "$HOME/$file" ]]; then
            rm -f "$HOME/$file"
        fi
        mv "$BAK_TARGET" "$HOME/$file"
        echo -e "  ${GREEN}[Restored]${NC} ~/$file"
    fi
done

echo ""
echo -e "${GREEN}==> Uninstallation complete!${NC}"
echo "Your previous configurations have been restored."
