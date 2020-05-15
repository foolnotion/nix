# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
		./hardware-configuration.nix
		];

	nixpkgs.config.allowUnfree = true;

	# Use the systemd-boot EFI boot loader.
	boot.kernelPackages = pkgs.linuxPackages_latest;
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.blacklistedKernelModules = [ "radeon" ];
	boot.kernel.sysctl = {
	    "kernel.sysrq" = 1;
    	};

	# networking.hostName = "nixos"; # Define your hostname.

	# The global useDHCP flag is deprecated, therefore explicitly set to false here.
	# Per-interface useDHCP will be mandatory in the future, so this generated config
	# replicates the default behaviour.
	networking.useDHCP = false;
	networking.interfaces.enp5s0.useDHCP = true;

	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	# Select internationalisation properties.
	console.keyMap = "us";
	console.font   = "Lat2-Terminus16";
	i18n.defaultLocale = "en_US.UTF-8";

	# Set your time zone.
	time.timeZone = "Europe/Vienna";
	time.hardwareClockInLocalTime = true;

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		# basic system
		htop wget mc vim tmux git subversion msr-tools lm_sensors parallel zip tmate
		nix-prefetch-scripts tokei bat exa fd pv mbuffer zstd neofetch ntfs3g
		psmisc linuxPackages.cpupower stress-ng
		# utils
		kitty neovim neovim-qt ccls youtube-dl nomacs termite
		mupdf zathura qpdfview llpp xdotool xclip mpv qalculate-gtk
		unzip miller figlet transmission discord teams skypeforlinux 
		# desktop
		firefox hexchat thunderbird mpv clementine sayonara qbittorrent rtorrent adwaita-qt chessx stockfish gimp 
		numix-gtk-theme numix-cursor-theme numix-icon-theme materia-theme libreoffice-fresh
		xboard eboard
		# latex
		texlive.combined.scheme-full
		# python
		python38 
		(python38.withPackages(ps: with ps; [ pynvim virtualenvwrapper pip ]))
		# proton mail & vpn
		openvpn
		networkmanager-openvpn
		networkmanagerapplet
		protonmail-bridge
		protonvpn-cli-ng

		# flash player
		# flashplayer-standalone

		alsaTools
		arandr
		tint2
		conky
	];

	fonts.fonts = with pkgs; [
		noto-fonts
		roboto
		liberation_ttf
		fira-code
		fira-code-symbols
		mplus-outline-fonts
		dina-font
		proggyfonts
		tamsyn
		corefonts
		ibm-plex
		libertine
		cascadia-code
		go-font
	];
	fonts.fontconfig.allowBitmaps = true;

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

	# List services that you want to enable:
	networking.networkmanager.enable = true;

	# Enable the OpenSSH daemon.
	services.openssh.enable = true;

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	# Enable CUPS to print documents.
	# services.printing.enable = true;

	# Enable sound.
	sound.enable = true;
	hardware.pulseaudio.enable = true;
	hardware.pulseaudio.extraConfig = "unload-module module-suspend-on-idle"; 

	# Enable the X11 windowing system.
	services.xserver.enable = true;
	services.xserver.layout = "us";
	services.xserver.videoDrivers = [ "amdgpu" ];
	services.xserver.xkbOptions = "eurosign:e";

	# hardware options
	hardware.opengl.enable = true;
	hardware.opengl.driSupport = true;
	hardware.cpu.amd.updateMicrocode = true;
	hardware.enableRedistributableFirmware = true;

	# docker virtualisation
	# virtualisation.docker.enable = true;


	# Enable touchpad support.
	# services.xserver.libinput.enable = true;

	# Enable the KDE Desktop Environment.
	services.xserver.displayManager.sddm.enable = true;
	services.xserver.desktopManager.lxqt.enable = true;

	# Enable the gnome-keyring service as many applications (even outside gnome) depend on it
	services.gnome3.gnome-keyring.enable = true;

	# Enable the Gnome3 Desktop Environment
	# services.xserver.displayManager.gdm.enable = true;
	# services.xserver.displayManager.gdm.wayland = false;
	# services.xserver.desktopManager.gnome3.enable = true;

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.bogdb = {
		isNormalUser = true;
		extraGroups = [ "wheel" "audio" "video" "networkmanager" ]; # Enable ‘sudo’ for the user.
	};

	# This value determines the NixOS release with which your system is to be
	# compatible, in order to avoid breaking some software such as database
	# servers. You should change this only after NixOS release notes say you
	# should.
	system.stateVersion = "20.03"; # Did you read the comment?
}



