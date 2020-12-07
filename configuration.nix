# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, options, ... }:


let 
	unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
	myCustomLayout = pkgs.writeText "xkb-layout" ''
		! Map umlauts to RIGHT ALT + <key>
		keycode 108 = Mode_switch

		keysym e = e E EuroSign
		keysym c = c C cent
		keysym w = w W adiaeresis Adiaeresis
		keysym o = o O odiaeresis Odiaeresis
		keysym u = u U udiaeresis Udiaeresis
		keysym r = r R ssharp
		
		keysym q = q Q acircumflex Acircumflex
		keysym a = a A abreve Abreve
		keysym s = s S U0219 U0218
                keysym t = t T U021B U021A
		keysym i = i I U00EE U00CE

		! disable capslock
		! remove Lock = Caps_Lock
	'';
in
{
	imports =
		[ # Include the results of the hardware scan.
		./hardware-configuration.nix
		];

	nixpkgs.config = { 
		allowUnfree = true;
		packageOverrides = pkgs: {
			nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
				inherit pkgs;
			};
		};
	};

	# Use the systemd-boot EFI boot loader.
	boot.kernelPackages = pkgs.linuxPackages_5_9;
	boot.kernelModules = [ "zenpower" "msr" "dm_thin_pool" ];
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.blacklistedKernelModules = [ "radeon" "k10temp" ];
	boot.extraModulePackages = [ pkgs.linuxPackages_5_9.zenpower ];
	boot.kernel.sysctl = {
	    "kernel.sysrq" = 1;
    	};
	boot.loader.grub.efiSupport = true;
	boot.loader.grub.memtest86.enable = true;
  
	#powerManagement.cpuFreqGovernor = "schedutil";

	#swapDevices = [
	#	{
	#		device = "/var/swap";
	#		priority = 0;
	#		size = 2048;
	#	}
	#];




	# networking.hostName = "nixos"; # Define your hostname.

	# The global useDHCP flag is deprecated, therefore explicitly set to false here.
	# Per-interface useDHCP will be mandatory in the future, so this generated config
	# replicates the default behaviour.
	networking.useDHCP = false;
	networking.interfaces.enp7s0.useDHCP = true;

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

	#nix.nixPath =
	#	# Prepend default nixPath values.
	#	options.nix.nixPath.default ++ 
	#	# Append our nixpkgs-overlays.
	#	[ "nixpkgs-overlays=/etc/nixos/overlays/" ]
	#;

	nixpkgs.overlays = [
		(import /etc/nixos/overlays/overlays.nix)
	];


	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		# basic system
		htop wget mc vim tmux gitFull subversion msr-tools lm_sensors parallel zip p7zip
		tmate nix-prefetch-scripts tokei bat exa fd pv mbuffer zstd neofetch ntfs3g
		psmisc linuxPackages.cpupower stress-ng
		# utils
		unstable.kitty # terminal
		unstable.neovim unstable.neovim-qt unstable.gnvim # editor
		unstable.mupdf
		unstable.zathura
		unstable.llpp
		unstable.qalculate-gtk
		unstable.miller
		unstable.tmate
		unstable.aria
		unstable.persepolis
		kitty neovim neovim-qt youtube-dl nomacs mupdf zathura qpdfview llpp xdotool xclip 
		# productivity
		unstable.typora
		unstable.zettlr
		# desktop-web
		firefox hexchat thunderbird qbittorrent rtorrent discord teams skypeforlinux signal-desktop wire-desktop 
		# desktop-media
		unstable.mpv 
		unstable.strawberry 
		unstable.deadbeef
		unstable.gst_all_1.gst-plugins-good
		unstable.gst_all_1.gst-plugins-bad

		gimp inkscape calibre
		# chess
		unstable.chessx
		unstable.stockfish
		#others
		unzip figlet transmission

		# desktop-other
		adwaita-qt # dark theme for qt5
		numix-gtk-theme numix-cursor-theme numix-icon-theme materia-theme libreoffice-fresh
		remmina obs-studio 
		xournalpp
		# latex
		texlive.combined.scheme-full
		jabref
		# python
		python38 
		(python38.withPackages(ps: with ps; [ pynvim virtualenvwrapper pip ]))
		# proton mail & vpn
		openvpn
		networkmanager-openvpn
		networkmanagerapplet
		#unstable.protonmail-bridge
		protonmail-bridge
		hydroxide # opensource protonmail bridge

		# flash player
		# flashplayer-standalone

		alsaTools
		arandr
		tint2
		conky
		gsimplecal
		obconf
		jgmenu
		zenmonitor

		# vaapi video acceleration
	        libva
	        libva-utils
	        libvdpau-va-gl
	        vaapiVdpau

		# teamviewer
		teamviewer

		# tcl/tk
		tcl
		tk

		#
		nodejs

		# steam
		unstable.steam
		unstable.lutris

		# troubleshoot
		memtest86

		# xorg utils
		xorg.xdpyinfo
		xsettingsd

		# opencl
		clinfo

		# util
		nix-du

		# disk
		gparted

		# amd
		unstable.corectrl

		# virtualization
		unstable.virt-manager
		# virt-manager-qt # broken
		unstable.virt-viewer
		unstable.looking-glass-client
		unstable.thin-provisioning-tools
	];

	fonts.fonts = with unstable; [
		#unscii
		camingo-code
		cascadia-code
		corefonts
		dina-font
		fira-code
		go-font
		hack-font
		hermit
		ibm-plex
		jetbrains-mono
		liberation_ttf
		libertine
		proggyfonts
		spleen
		sudo-font
		tamsyn
		tamzen
		terminus_font
		uw-ttyp0
		vistafonts
	];
	fonts.fontconfig.allowBitmaps = true;

	# theme
	# environment.variables.QT_QPA_PLATFORMTHEME = "qt5ct";
	# environment.variables.QT_QPA_PLATFORMTHEME = "kvantum";

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

	# List services that you want to enable:
	networking.hostName = "jaghut";
	networking.networkmanager.enable = true;

	# Enable the OpenSSH daemon.
	services.openssh.enable = true;
	programs.ssh.askPassword = "lxqt-openssh-askpass";

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ 8888 ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	# Enable CUPS to print documents.
	# services.printing.enable = true;

	# Enable sound.
	sound.enable = true;
	hardware.pulseaudio.enable = true;
	hardware.pulseaudio.support32Bit = true; #steam
	hardware.pulseaudio.extraConfig = "unload-module module-suspend-on-idle"; 

	# Enable the X11 windowing system.
	services.xserver.enable = true;
	services.xserver.layout = "us";
	services.xserver = { 
		videoDrivers = [ "amdgpu" ]; 
		deviceSection = ''
			Option "TearFree" "true"
		''; 
	};
	#services.xserver.xkbOptions = "eurosign:e";
	#

	# hardware options
	hardware.opengl = { 
		enable = true;
		driSupport = true;
		driSupport32Bit = true; #steam
		extraPackages32 = with pkgs.pkgsi686Linux; [ libva ]; #steam
		extraPackages = with pkgs; [
			rocm-opencl-icd
			amdvlk
		];
	};
	hardware.cpu.amd.updateMicrocode = true;
	hardware.enableRedistributableFirmware = true;



	# Enable touchpad support.
	# services.xserver.libinput.enable = true;

	# Enable the KDE Desktop Environment.
	#services.xserver.desktopManager.plasma5.enable = true;
	services.xserver.wacom.enable = true;
	#services.xserver.dpi = 110;

	#services.xserver.desktopManager.lxqt.enable = true;
	# Enable the gnome-keyring service as many applications (even outside gnome) depend on it
	services.gnome3.gnome-keyring.enable = true;

	# Enable the Gnome3 Desktop Environment
	# services.xserver.displayManager.gdm.enable = true;
	# services.xserver.displayManager.gdm.wayland = false;
	# services.xserver.desktopManager.gnome3.enable = true;
	services.xserver = {
		displayManager = {
			sddm.enable = true;
			#sddm.theme = "elarun";
			defaultSession = "lxqt";
			sessionCommands = "${pkgs.xorg.xmodmap}/bin/xmodmap ${myCustomLayout}";
		};
		desktopManager = {
			xterm.enable = false;
			lxqt.enable = true;
		};
	};
	# Team viewer
	services.teamviewer.enable = true;	

	# virtualisation
	virtualisation.libvirtd.enable = true;
	virtualisation.lxd.enable = true;
	systemd.services.lxd.path = with pkgs; [ lvm2 thin-provisioning-tools e2fsprogs ];
	virtualisation.docker.enable = true;
	
	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.bogdb = {
		isNormalUser = true;
		extraGroups = [ "wheel" "audio" "video" "networkmanager" "kvm" "libvirtd" "lxd" "docker" ]; # Enable ‘sudo’ for the user.
	};

	# This value determines the NixOS release with which your system is to be
	# compatible, in order to avoid breaking some software such as database
	# servers. You should change this only after NixOS release notes say you
	# should.
	system.stateVersion = "20.09"; # Did you read the comment?
}



