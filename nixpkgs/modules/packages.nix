{ config, pkgs, libs, ... }:
{  
	home.packages = with pkgs; [
	  # utilities
	  alacritty
	  bat
	  chessx
	  datamash
	  fd
	  flac
	  flacon
      eovim
	  gh
      gitter
	  gitui
	  gnome.gnome-dictionary
	  gsimplecal
	  keyd
	  kitty
	  lazygit
	  lxqt.qterminal
	  mac
	  miller
	  ncdu
	  neovide
	  neovim-nightly
	  neovim-qt
	  pcmanfm-qt
	  qalculate-gtk
	  taskwarrior
	  tilix
	  timewarrior
      quaternion
	  ripgrep
      scid-vs-pc
      slack
	  somafm-cli
	  stockfish
      visidata
	  vivaldi
	  xarchiver
	  zenmonitor

	  # password management
	  keepassxc

	  # coc.nvim plugin
	  nodejs

	  # office
	  zathura
	  llpp
	  qpdfview
	  libreoffice-fresh

	  #multimedia
      freetube
	  lxqt.pavucontrol-qt
	  mpv
      vlc
	  strawberry
	  deadbeef

	  # themes
	  adwaita-qt
	  numix-gtk-theme
	  numix-cursor-theme
	  numix-icon-theme
	  materia-theme

	  # graphics
	  nomacs
	  gimp

	  # browsers
	  firefox
	  #ungoogled-chromium

	  # torrents
	  qbittorrent

	  # messengers
	  discord
	  teams
	  skypeforlinux
	  signal-desktop
	  wire-desktop
	  zoom-us
	];
}
