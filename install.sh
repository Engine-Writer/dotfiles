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

echo -e "${YELLOW}==> Starting dotfiles installation...${NC}"

if ! command -v stow >/dev/null 2>&1; then
    echo -e "${RED}Error: GNU Stow is not installed.${NC}"
    exit 1
fi

echo -e "${YELLOW}==> Stowing packages...${NC}"
for pkg target in ${(kv)PACKAGES}; do
    if [[ ! -d "$DOTFILES_DIR/$pkg" ]]; then
        echo -e "  ${RED}[Skip]${NC} $pkg (directory not found in repo)"
        continue
    fi
    
    if [[ -e "$target" && ! -L "$target" ]]; then
        echo -e "  ${YELLOW}[Backup]${NC} $target -> $target.bak"
        mv "$target" "$target.bak"
    fi
    
    if stow_output=$(stow -v --target="$HOME" "$pkg" 2>&1); then
        echo -e "  ${GREEN}[Stowed]${NC} $pkg"
    else
        echo -e "  ${RED}[Error]${NC} Failed to stow $pkg:"
        echo "$stow_output" | sed 's/^/    /'
    fi
done

echo -e "${YELLOW}==> Handling loose files...${NC}"
for file in "${LOOSE_FILES[@]}"; do
    if [[ -e "$HOME/$file" && ! -L "$HOME/$file" ]]; then
        echo -e "  ${YELLOW}[Backup]${NC} ~/$file -> ~/$file.bak"
        mv "$HOME/$file" "$HOME/$file.bak"
    fi
    
    if [[ -f "$DOTFILES_DIR/zsh/$file" ]]; then
        ln -sf "$DOTFILES_DIR/zsh/$file" "$HOME/$file"
        echo -e "  ${GREEN}[Linked]${NC} ~/$file"
    elif [[ -f "$DOTFILES_DIR/xcompose/$file" ]]; then
        ln -sf "$DOTFILES_DIR/xcompose/$file" "$HOME/$file"
        echo -e "  ${GREEN}[Linked]${NC} ~/$file"
    fi
done

echo -e "${YELLOW}==> Creating required directories...${NC}"
mkdir -p "$HOME/Pictures/Screenshots"
mkdir -p "$HOME/.config/hypr/wallpapers"
mkdir -p "$HOME/.local/bin"
echo -e "  ${GREEN}[Created]${NC} Screenshots, wallpapers, local/bin"

echo ""
echo -e "${GREEN}==> Installation complete!${NC}"
echo "Log out and back in to apply changes."
