#!/usr/bin/env bash

# Define colors
CRE=$(tput setaf 1)
CYE=$(tput setaf 3)
CGR=$(tput setaf 2)
CBL=$(tput setaf 4)
BLD=$(tput bold)
CNC=$(tput sgr0)

# Set up variables
backup_folder=~/.RiceBackup
date=$(date +%Y%m%d-%H%M%S)

# Dependencies
dependencies=(alacritty bspwm dragon-drop dunst maim feh git gtk-engine-murrine gvfs gvfs-afc gvfs-mtp gvfs-smb htop firefox lxappearance vlc neovim networkmanager pamixer pavucontrol ranger rofi scrot sed sxhkd udisks2 ttf-roboto-mono ttf-maple ttf-jetbrains-mono-nerd ttf-ubuntu-font-family ttf-ubuntu-nerd ttf-roboto-mono-nerd unzip xclip xdg-user-dirs-gtk xorg-xinit zathura zathura-pdf-mupdf zip picom-simpleanims-next-git zsh zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting dolphin qt5ct kvantum kde-cli-tools)

# Function to display the logo
logo() {
    local message="$1"
    local bold=$(tput bold)
    local reset=$(tput sgr0)

    echo -e "${bold}\e[95m$message${reset}"
}


# Function to check if the script is run as root
check_root() {
    if [ "$(id -u)" = 0 ]; then
        echo "This script MUST NOT be run as root."
        exit 1
    fi
}

# Check if install or not
is_installed() {
    pacman -Qi "$1" &>/dev/null
    return $?
  }

# Function to handle the installation process
install(){
  # Intro
  clear
  logo "Welcome"
  printf '%s%sThis script will automatically install fully-featured tiling/floating window manager-based system on any Arch Linux or Arch-based system. \n\nMy dotfiles DO NOT modify any of your system configuration. \nYou will be prompted for your root password to install missing dependencies \n\nThis script doesnt have potential power to break your system, it only copies files from my repo to your HOME directory. %s\n\n' "${BLD}" "${CRE}" "${CNC}"

  while true; do
    read -rp " Do you want to continue? [y/n]: " yn
    case $yn in
    [Yy]*) break ;;
    [Nn]*) exit ;;
    *) printf "Just write 'y' or 'n'\n\n" ;;
    esac
  done
  clear

  # Update system
  logo "Updating system"
  sudo rm -rf /var/lib/pacman/db.lck
  sudo pacman -Syu --noconfirm
  printf "%s%sDone!!%s\n\n" "${BLD}" "${CGR}" "${CNC}"
  sleep 2
  clear

  # Install X.Org
  logo "Installing X.Org"
  sudo pacman -S --needed --noconfirm xorg xorg-drivers
  printf "%s%sDone!!%s\n\n" "${BLD}" "${CGR}" "${CNC}"
  sleep 2
  clear


  # Install Pipewire (audio)
  logo "Installing Pipewire (audio)"
  yes y | sudo pacman -S --needed pipewire pipewire-pulse wireplumber
  printf "%s%sDone!!%s\n\n" "${BLD}" "${CGR}" "${CNC}"
  sleep 2
  clear

  # Install paru (AUR helper)
  logo "Installing paru"
  if command -v paru &>/dev/null; then
    echo "Paru is installed in your system"
  else
    sudo pacman -S --needed --noconfirm base-devel && git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si --noconfirm && cd ..
  fi
  sleep 2
  clear

  # Install yay (AUR helper)
  logo "Installing yay"
  if command -v yay &>/dev/null; then
    echo "Yay is installed in your system"
  else
    git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd ..
  fi
  sleep 2
  clear

  # Install packages
  logo "Installing needed packages"

  printf "%s%sChecking for required packages%s\n" "${BLD}" "${CBL}" "${CNC}"
  for paquete in "${dependencies[@]}"; do
    if ! is_installed "$paquete"; then
      paru -S --noconfirm "$paquete"
      printf "\n"
    else
      printf '%s%s is already installed on your system!%s\n' "${CGR}" "$paquete" "${CNC}"
    fi
  done
  sleep 2
  clear

  # Preparing folders
  logo "Preparing Folders"
  if [ ! -e $HOME/.config/user-dirs.dirs ]; then
    xdg-user-dirs-update
    echo "Creating xdg-user-dirs"
  else
    echo "user-dirs.dirs already exists"
  fi
  sleep 2
  clear

  # Downloading dotfiles
  logo "Downloading dotfiles"
  [ -d ~/dotfiles ] && rm -rf ~/dotfiles
  printf "Cloning rice\n"
  cd
  git clone --depth=1 https://github.com/kagerou-hikari/dotfiles.git ~/.dotfiles
  printf "%s%sDone!!%s\n\n" "${BLD}" "${CGR}" "${CNC}"
  sleep 2
  clear

  # Backup dotfiles
  logo "Backing-up dotfiles"
  printf "Backup files will be stored in %s%s%s/.RiceBackup%s \n\n" "${BLD}" "${CRE}" "$HOME" "${CNC}"
  sleep 1

  if [ ! -d "$backup_folder" ]; then
    mkdir -p "$backup_folder"
  fi

  for folder in alacritty bspwm btop gtk-3.0 gtk-4.0 neovim picom ranger rofi vlc sxhkd zathura qt5ct Kvantum neofetch polybar dunst; do
    if [ -d "$HOME/.config/$folder" ]; then
      mv "$HOME/.config/$folder" "$backup_folder/${folder}_$date"
      echo "$folder folder backed up successfully at $backup_folder/${folder}_$date"
    else
      echo "The folder $folder does not exist in $HOME/.config/"
    fi
  done

  for folder in wallpapers; do
    if [ -d "$HOME"/$folder ]; then
      mv "$HOME"/$folder "$backup_folder"/${folder}_$date
      echo "$folder folder backed up successfully at $backup_folder/${folder}_$date"
    else
      echo "The folder $folder does not exist in $HOME"
    fi
  done

  [ -f ~/.fehbg ] && mv ~/.fehbg ~/.RiceBackup/.fehbg-backup-"$(date +%Y.%m.%d-%H.%M.%S)"
  printf "%s%sDone!!%s\n\n" "${BLD}" "${CGR}" "${CNC}"
  sleep 2
  clear

  # Installing dotfiles
  logo "Installing dotfiles.."
  printf "Linking files to respective directories..\n"

  [ ! -d ~/.config ] && mkdir -p ~/.config

  files=( ".zshrc" ".xinitrc" ".Xresources" ".ssh" ".gitconfig" ".gnupg" )

  for file in "${files[@]}"; do
    ln -s "$HOME/.dotfiles/home/$file" "$HOME/"
  done

  configs=( "bspwm" "alacritty" "ranger" "dunst" "neofetch" "htop" "zathura" )

  for config in "${configs[@]}"; do
    ln -s "$HOME/.dotfiles/config/$config" "$HOME/.config/"
  done

  ln -s "$HOME/.dotfiles/config/code/User" "$HOME/.config/Code/"

  sudo cp -r $HOME/.dotfiles/themes/* /usr/share/themes/
  sudo cp -r $HOME/.dotfiles/icons/* /usr/share/icons/

  
}

install_pkg_list(){
  echo "${dependencies[@]}"
}

install_backup(){
  echo "Not working yet"
}

case "$1" in
  --install)install;;
  --install-pkg-list)install_pkg_list;;
  --install-backup)install_backup;;
  --help|*)echo -e "Setup [options]
  
Options:
	--install		            Install config and pkg without backup.
        --install-pkg-list                  Installing pkg list.
	--install-backup		    Install backup config and remove install config.\n"
esac