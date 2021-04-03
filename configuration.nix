# Edit thi
# configuration file to define what should be installed on
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
	boot.kernelPackages = pkgs.linuxPackages_latest;
	
	#boot.kernelPackages = let
        #    linux_5_10_pkg = { fetchurl, buildLinux, modDirVersionArg ? null, ... } @ args:
        #        buildLinux (args // rec {
        #            version = "5.10.9";

        #            modDirVersion = if (modDirVersionArg == null) then builtins.replaceStrings ["-"] [".0-"] version else modDirVersionArg;

        #            src = fetchurl {
        #                url = "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${version}.tar.xz";
        #                sha256 = "7f733e0dd8bbb6929aae2191cf6b9dc0b0ec1dad77ab3f5d3aad1b7fe96c4751";
        #            };

        #            kernelPatches = [];

        #            extraMeta.branch = "5.10.9";

        #        } // (args.argsOverride or {}));

        #    linux_5_10 = pkgs.callPackage linux_5_10_pkg{};
        #in
        #    pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_5_10);

	boot.kernelModules = [ "msr" "dm_thin_pool" "k10temp" "v4l2loopback" ];
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.blacklistedKernelModules = [ "radeon" ];
	#boot.extraModulePackages = [ pkgs.linuxPackages_latest.v4l2loopback ];
	boot.kernel.sysctl = {
	    "kernel.sysrq" = 1;
    	};
	boot.loader.grub.efiSupport = true;
	boot.loader.grub.memtest86.enable = true;
  
	#powerManagement.cpuFreqGovernor = "schedutil";
	powerManagement.powerUpCommands = ''
	    ${pkgs.hdparm}/sbin/hdparm -y /dev/sda
	'';

	#swapDevices = [
	#	{
	#		device = "/var/swap";
	#		priority = 0;
	#		size = 2048;
	#	}
	#];

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
	#	[ "nixpkgs-overlays=/home/bogdb/.config/nixpkgs/overlays/" ]
	#;

	nixpkgs.overlays = [
		(import /home/bogdb/.config/nixpkgs/overlays/default.nix)
	];

	nix.systemFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ] ++ [ "gccarch-znver2" ];


	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		# basic system
		htop wget mc vim tmux gitFull subversion msr-tools lm_sensors parallel zip p7zip
		tmate nix-prefetch-scripts tokei bat exa fd pv mbuffer zstd neofetch ntfs3g
		psmisc hdparm linuxPackages.cpupower hdparm stress-ng mprime nitrogen

		#corefreq

		# utils
		tdrop
		kitty # terminal
		neovim neovim-qt 
		gnvim
		mupdf
		zathura
		llpp
		qalculate-gtk
		miller
		tmate
		aria
		persepolis
		youtube-dl somafm-cli nomacs mupdf zathura qpdfview llpp xdotool xclip 
		# productivity
		typora
		# zettlr
		# desktop-web
		chromium firefox hexchat thunderbird qbittorrent rtorrent discord teams skypeforlinux signal-desktop wire-desktop zoom-us 
		# desktop-media
		mpv 
		celluloid # gtk mpv frontend
		strawberry 
		deadbeef
		gst_all_1.gst-plugins-good
		gst_all_1.gst-plugins-bad

		gimp inkscape
		# chess
		chessx
		stockfish
		#others
		unzip figlet transmission

		# desktop-other
		adwaita-qt # dark theme for qt5
		numix-gtk-theme numix-cursor-theme numix-icon-theme materia-theme 
		#libreoffice-fresh
		remmina
		obs-studio
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
		#protonmail-bridge
		#protonmail-bridge
		hydroxide # opensource protonmail bridge
		protonvpn-cli
		evolutionWithPlugins

		# password management
		keepassxc

		# flash player
		# flashplayer-standalone

		volctl
		alsaTools
		arandr
		tint2
		conky
		gsimplecal
		obconf
		jgmenu
		zenmonitor
		ncdu

		# vaapi video acceleration
	        libva
	        libva-utils
	        libvdpau-va-gl
	        vaapiVdpau

		# teamviewer
		# teamviewer

		# tcl/tk
		tcl
		tk

		# needed by coc.vim
		nodejs

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
		# corectrl

		# virtualization
		virt-manager
		# virt-manager-qt # broken
		virt-viewer
		looking-glass-client
		thin-provisioning-tools

		# signing
		gnupg

		# games (other)
		lutris
	];

	fonts.fonts = with unstable; [
		#unscii
		camingo-code
		cascadia-code
		corefonts
		cozette
		dina-font
		fira-code
		gohufont
		go-font
		hack-font
		hermit
		ibm-plex
		jetbrains-mono
		julia-mono
		liberation_ttf
		libertine
		proggyfonts
		recursive
		siji
		source-code-pro
		spleen
		sudo-font
		tamsyn
		tamzen
		terminus_font
		uw-ttyp0
		vistafonts
	];
	fonts.fontconfig.allowBitmaps = true;

	# gnupg
	programs.gnupg.agent.enable = true;

	# steam
	programs.steam.enable = true;

	# android
	programs.adb.enable = true;

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

	# enable dconf
	programs.dconf.enable = true;

	# Open ports in the firewall.
	networking.firewall.allowedTCPPorts = [ 3389 8888 ];
	networking.firewall.allowedUDPPorts = [ 3389 8888 ]; 
	# Or disable the firewall altogether.
	networking.firewall.enable = true;

	# Enable CUPS to print documents.
	# services.printing.enable = true;

	# Enable sound.
	sound.enable = true;
	hardware.pulseaudio.enable = true;
	hardware.pulseaudio.support32Bit = true; #steam
	hardware.pulseaudio.extraConfig = "unload-module module-suspend-on-idle"; 
	#
	# enable pipewire (better sound system)
	security.rtkit.enable = true;
	#services.pipewire = {
	#	enable = true;
	#	pulse.enable = true;
	#	alsa.enable = true;
	#	alsa.support32Bit = true;
	#};


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
		extraPackages32 = with pkgs.pkgsi686Linux; [ 
			libva
			driversi686Linux.amdvlk
		]; #steam
		extraPackages = with pkgs; [
			rocm-opencl-icd
			rocm-opencl-runtime
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
			defaultSession = "lxqt";
			sessionCommands = "${pkgs.xorg.xmodmap}/bin/xmodmap ${myCustomLayout}";
		};
		desktopManager = {
			xterm.enable = false;
			lxqt.enable = true;
		};
		windowManager.i3 = {
			enable = true;
			extraPackages = with pkgs; [
				dmenu #application launcher most people use
				i3status # gives you the default i3 status bar
				i3lock #default i3 screen locker
				i3blocks #if you are planning on using i3blocks over i3status
				dunst
				(polybar.override { i3Support = true; })
			];
		};
	};
	# Team viewer
	# services.teamviewer.enable = true;	

	#
	services.xrdp.enable = true;
	services.xrdp.defaultWindowManager = "lxqt-session";

	# virtualisation
	virtualisation.libvirtd.enable = true;
	virtualisation.lxd.enable = true;
	systemd.services.lxd.path = with pkgs; [ lvm2 thin-provisioning-tools e2fsprogs ];
	virtualisation.docker.enable = true;
	
	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.bogdb = {
		isNormalUser = true;
		extraGroups = [ "adbusers" "wheel" "audio" "video" "networkmanager" "kvm" "libvirtd" "lxd" "docker" ]; # Enable ‘sudo’ for the user.
	};

	# This value determines the NixOS release with which your system is to be
	# compatible, in order to avoid breaking some software such as database
	# servers. You should change this only after NixOS release notes say you
	# should.
	system.stateVersion = "20.09"; # Did you read the comment?
}



