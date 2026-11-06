# My Hyprland Dotfiles

## Prerequisites

This setup is built for **Arch Linux** (or Arch-based distributions). You will need packages from the official repositories, the `archlinuxcn` repository, and the AUR.

### 1. Keyrings (Required First)
Before installing anything, ensure your keyrings are up to date to prevent PGP signature errors:
```bash
sudo pacman -S archlinux-keyring archlinuxcn-keyring
```

### 2. Core Packages
Install the required packages from the official repos:
```bash
sudo pacman -S --needed \
  hyprland hyprpaper xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  hyprpolkitagent qt6-wayland qt5-wayland wl-clipboard cliphist \
  hyprshot grim slurp jq libnotify rofimoji brightnessctl playerctl \
  wireplumber pipewire pipewire-pulse pipewire-alsa networkmanager \
  network-manager-applet waybar swaync kitty zsh zsh-completions \
  starship qt6ct qt5ct ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols \
  ttf-nerd-fonts-symbols-common noto-fonts noto-fonts-emoji fontconfig \
  papirus-icon-theme firefox dolphin git stow swappy
```

### 3. AUR Packages
You need an AUR helper (`yay` or `paru`) to install ulauncher:
```bash
yay -S --needed ulauncher-git
```

---

## Installation

1. **Clone the repository** to your home directory:
   ```bash
   git clone https://github.com/YOURNAME/my-dotfiles.git ~/my-dotfiles
   cd ~/my-dotfiles
   ```

2. **Verify dependencies** (optional):
   This script will check if all required binaries, fonts, and directories are present. and tell you which are missing
   ```bash
   ./test-dependencies.sh
   ```

3. **Run the installer**:
   ```bash
   ./install.sh
   ```

---

## Uninstallation

If you want to remove these dotfiles and restore your previous setup:

```bash
cd ~/my-dotfiles
./uninstall.sh
```

---

## Included Configurations
*   **Hyprland** (Uses Lua config syntax, requires Hyprland 0.55+)
*   **Kitty** (Terminal)
*   **Waybar** (Status Bar)
*   **SwayNC** (Notification Center)
*   **Swappy** (Screenshot Editor)
*   **Starship** (Shell Prompt)
*   **Zsh** (`.zshrc`)
*   **Ulauncher** (App Launcher)
*   **Qt6ct / Fontconfig** (Theming and Fonts)
*   **XCompose** (Custom key mappings)

## Notes
*   The Hyprland config expects wallpapers to be placed in `~/.config/hypr/wallpapers/`.
*   The screenshot tool expects images to be saved in `~/Pictures/Screenshots/`. 
