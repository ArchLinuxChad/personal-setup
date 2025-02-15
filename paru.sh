  sudo pacman -S --needed git base-devel
  cd $HOMEDIR/other-repos
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  cd $HOMEDIR
