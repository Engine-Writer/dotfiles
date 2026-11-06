#!/usr/bin/env zsh
set -uo pipefail

FAIL=0

REQUIRED_BINS=(
  hyprland hyprctl hyprpaper hyprshot swappy
  grim slurp jq wl-paste wl-copy cliphist notify-send
  rofimoji waybar swaync kitty zsh starship
  qt6ct qt5ct brightnessctl playerctl wpctl
  stow git fc-cache ulauncher
)

echo "==> Checking required binaries..."
for bin in "${REQUIRED_BINS[@]}"; do
  if command -v "$bin" >/dev/null 2>&1; then
    printf "  [ok]   %s\n" "$bin"
  else
    printf "  [MISS] %s\n" "$bin"
    FAIL=1
  fi
done

echo "==> Checking versions..."

if command -v hyprctl >/dev/null 2>&1; then
  HYPR_RAW="$(hyprctl version 2>/dev/null | head -n1 || true)"
  HYPR_VER="$(echo "$HYPR_RAW" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1 || echo "0.0.0")"
  
  local -a ver_parts=(${(s/./)HYPR_VER})
  local major=$ver_parts[1]
  local minor=$ver_parts[2]
  
  if [[ "$major" -eq 0 && "$minor" -lt 55 ]]; then
    printf "  [MISS] Hyprland version (%s). Config requires 0.55+\n" "$HYPR_VER"
    FAIL=1
  else
    printf "  [ok]   Hyprland version (%s)\n" "$HYPR_VER"
  fi
fi

if command -v ulauncher >/dev/null 2>&1; then
  ULAUNCHER_VER="$(ulauncher --version 2>/dev/null | head -n1 || true)"
  if [[ "$ULAUNCHER_VER" == "Ulauncher 6"* ]]; then
    printf "  [ok]   ulauncher (%s)\n" "$ULAUNCHER_VER"
  else
    printf "  [MISS] ulauncher (expected Ulauncher 6*, got '%s')\n" "${ULAUNCHER_VER:-<no output>}"
    FAIL=1
  fi
fi

echo "==> Checking fonts..."

check_font() {
  if fc-list : family | grep -qi "$1"; then
    printf "  [ok]   font: %s\n" "$1"
  else
    printf "  [MISS] font: %s\n" "$1"
    FAIL=1
  fi
}

check_font "JetBrainsMono Nerd Font"
check_font "Symbols Nerd Font"
check_font "Noto Emoji"

echo "==> Checking directories..."

check_dir() {
  if [[ -d "$1" ]]; then
    printf "  [ok]   dir: %s\n" "$1"
  else
    printf "  [MISS] dir: %s\n" "$1"
    FAIL=1
  fi
}

check_dir "$HOME/Pictures/Screenshots"
check_dir "$HOME/.config/hypr/wallpapers"
check_dir "$HOME/.local/bin"


# --- RESULT ---
echo ""
if [[ "$FAIL" -ne 0 ]]; then
  echo "=================================================="
  echo " FAIL: Missing dependencies or directories."
  echo ""
  echo " Fix missing directories:"
  echo "   mkdir -p ~/.config/hypr/wallpapers"
  echo "=================================================="
  exit 1
fi

echo "=================================================="
echo " OK: All dependencies satisfied."
echo "=================================================="
exit 0
