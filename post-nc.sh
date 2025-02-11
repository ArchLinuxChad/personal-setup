#!/usr/bin/env bash

HOMEDIR="/home/$USER"

create_dirs() {
  mkdir $HOMEDIR/github-repos
  mkdir $HOMEDIR/other-repos
  mkdir $HOMEDIR/.local/share/fonts
  [[ ! -d $HOMEDIR/.config ]] && mkdir $HOMEDIR/.config
}

install_paru() {
  sudo pacman -S --needed git base-devel
  cd $HOMEDIR/other-repos
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  cd $HOMEDIR
}

install_apps() {
  paru -S --needed - < $HOMEDIR/nc/linux/dotfiles/pkglist.txt
}

setup_dotfiles() {
  cp $HOMEDIR/nc/linux/dotfiles/.zshrc $HOMEDIR/
  cp -r $HOMEDIR/nc/linux/dotfiles/.config/* $HOMEDIR/.config/
  chmod +x $HOMEDIR/.config/polybar/launch.sh
}

setup_grub() {
  sudo cp -r $HOMEDIR/nc/linux/dotfiles/Shodan /boot/grub/themes/
  sudo sed -i 's/\/path\/to\/gfxtheme/\/boot\/grub\/themes\/Shodan\/theme.txt/'
  sudo grub-mkconfig -o /boot/grub/grub.cfg
}

clone_wallpapers() {
  cd $HOMEDIR
  git clone https://github.com/ArchLinuxChad/wallpapers.git
}

setup_fonts() {
  cd $HOMEDIR/.local/share/fonts
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/SpaceMono.zip
  unzip SpaceMono.zip
  rm OFL.txt
  rm README.md
  rm SpaceMono.zip 
  fc-cache -vf
  cd $HOMEDIR
}

setup_misc() {
  sudo systemctl enable ufw.service
  sudo ufw default allow outgoing
  sudo ufw default deny incoming
  sudo ufw enable

  sudo systemctl enable tlp.service
  sudo tlp start
}

setup_aa() {
  sudo systemctl enable apparmor.service
  sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=\"*\"/GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet lsm=landlock,lockdown,yama,integrity,apparmor,bpf\"/' /etc/default/grub
}

fix_screen_tearing() {
  sudo pacman -S --needed xf86-video-amdgpu
  sudo touch /etc/X11/xorg.conf.d/20-amdgpu.conf
  sudo echo 'Section "OutputClass"
     Identifier "AMD"
     MatchDriver "amdgpu"
     Driver "amdgpu"
     Option "TearFree" "true"
EndSection' >> /etc/X11/xorg.conf.d/20-amdgpu.conf
}

install_nvchad() {
  git clone https://github.com/NvChad/starter ~/.config/nvim
}

main() {
  create_dirs
  install_paru
  install_apps
  setup_dotfiles
  setup_grub
  setup_fonts
  setup_misc
  setup_aa
  install_nvchad
  reboot
}

# run the program
main
