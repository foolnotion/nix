# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, options, ... }:


let 
        #unstable = import <nixos> { 
	#	config = { 
	#		allowUnfree = true;
	#		input-fonts.acceptLicense = true;
	#	}; 
	#};
	myCustomLayout = pkgs.writeText "xkb-layout" ''
		! Map umlauts to RIGHT ALT + <key>
        clear mod1
		keycode 108 = Mode_switch
        keycode 64 = Super_L

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

	nixpkgs = {
		config = { 
			allowUnfree = true;

			packageOverrides = pkgs: {
				nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
					inherit pkgs;
				};
			};
			permittedInsecurePackages = [ "ffmpeg-3.4.8" ];
		};
		# most of the time this causes build failures
		#localSystem = {
		#	gcc.arch = "znver2";
		#	gcc.tune = "znver2";
		#	system = "x86_64-linux";
		#};
	};

	documentation.info.enable = false;

	#nix.useSandbox = false;

	nix = {
                #package = pkgs.nixStable;
                package = pkgs.nixUnstable;
		extraOptions = ''
			experimental-features = nix-command flakes
		'';
		systemFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ] ++ [ "gccarch-znver2" ];
	};	

	# Use the systemd-boot EFI boot loader.
	boot.kernelPackages = pkgs.linuxPackages_latest;
	boot.initrd.kernelModules = [ "amdgpu" "dm_thin_pool" ];
	boot.kernelModules = [ "msr" "dm_thin_pool" "v4l2loopback" "zenpower" ];
	boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];
	boot.blacklistedKernelModules = [ "radeon" "k10temp" ];
	boot.extraModulePackages = [ pkgs.linuxPackages_latest.zenpower ];
	boot.extraModprobeConfig = /* modconf */ ''
		options usb-storage quirks=174c:55aa:u
	'';

	boot.kernel.sysctl = {
	    "kernel.sysrq" = 1;
    	};

	boot.loader = {
		grub = {
			efiSupport = true;
			memtest86.enable = true;
		};
		efi.canTouchEfiVariables = true;
		systemd-boot = {
			enable = true;
			memtest86.enable = true;
		};
	};
  
	#powerManagement.cpuFreqGovernor = "schedutil";
	powerManagement.powerUpCommands = ''
	    ${pkgs.hdparm}/sbin/hdparm -y /dev/sda
	    ${pkgs.hdparm}/sbin/hdparm -y /dev/sdb
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

	i18n = {
		defaultLocale = "en_US.UTF-8";

		extraLocaleSettings = {
			LC_TIME = "en_GB.UTF-8";
		};
	};

	# Set your time zone.
	time.timeZone = "Europe/Vienna";
	time.hardwareClockInLocalTime = true;

	nixpkgs = {
		overlays = [ (import /home/bogdb/.config/nixpkgs/overlays/default.nix) ];
	};

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		# basic system
		htop
		wget
		mc
		vim
		tmux tmate
		gitFull
		subversion
		msr-tools
		lm_sensors
		parallel
		zip p7zip
		nix-prefetch-scripts
		pv
		mbuffer
		zstd
		neofetch
		ntfs3g
		psmisc
		hdparm
		linuxPackages.cpupower
		stress-ng
		mprime
		nitrogen
		mupdf
		st
		xdotool
		xclip

        #corefreq
		unzip

		# desktop-other
		remmina

		# latex
		texlive.combined.scheme-full
		poppler_utils
		jabref
		pandoc

		# python
		python39 
		(python39.withPackages(ps: with ps; [ virtualenvwrapper pip ]))
		# proton mail & vpn
		openvpn
		networkmanager-openvpn
		networkmanagerapplet
		hydroxide # opensource protonmail bridge
		#evolutionWithPlugins

		# vaapi video acceleration
	        libva
	        libva-utils
	        libvdpau-va-gl
	        vaapiVdpau

		# needed by coc.vim
		#nodejs

		# xorg utils
		xorg.xdpyinfo
        xorg.xhost
		xsettingsd

		# opencl
		clinfo

		# util
		nix-du
		smartmontools
		corectrl

		# disk
		gparted

		# amd
		# corectrl

		# virtualization
		virt-manager
		virt-viewer
		looking-glass-client
		thin-provisioning-tools

		# signing
		gnupg

		# games (other)
		lutris
		mangohud
	];

	fonts.fonts = with pkgs; [
		#unscii
		camingo-code
		cascadia-code
		corefonts
                #cozette
		dina-font
		font-awesome_4
		gohufont
		go-font
		hack-font
		hermit
		ibm-plex
		jetbrains-mono
		julia-mono
		liberation_ttf
		libertine
		lmodern
		noto-fonts-emoji
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

	# neovim
	environment.variables.EDITOR = "nvim";
	environment.variables.QT_QPA_PLATFORMTHEME = "qt5ct";
	# List services that you want to enable:
	networking.hostName = "jaghut";
	networking.networkmanager.enable = true;

	programs = {
		adb.enable = true;
		dconf.enable = true;
		gnupg.agent.enable = true;
		qt5ct.enable = true;
		seahorse.enable = true;
		steam.enable = true;
        ssh.forwardX11 = true;
	};


	services = {
		# ssh access
		openssh.enable = true;

		# smart disk monitoring
		smartd = {
			enable = true;
			autodetect = true;
			notifications.x11.enable = true;
		};

		# gnome-keyring needed by many apps to work properly
		gnome.gnome-keyring.enable = true;

		# x11
		xserver = {
			enable = true;
			layout = "us";

			videoDrivers = [ "amdgpu" ];
			deviceSection = ''
				Option "TearFree" "true"
			'';

			displayManager = {
                lightdm = {
                    enable = true;
                    greeters.mini = {
                        enable = true;
                        user = "bogdb";
                        extraConfig = ''
                            [greeter]
                            show-password-label=false
                            active-monitor=1
                            [greeter-theme]
                            background-image = ""
                        '';

                    };
                };
				defaultSession = "xfce+i3";
				sessionCommands = "${pkgs.xorg.xmodmap}/bin/xmodmap ${myCustomLayout}";
			};

			desktopManager = {
				xterm.enable = false;
				xfce = {
					enable = true;
					noDesktop = true;
					enableXfwm = false;
				};
			};

			wacom.enable = true;

			windowManager.i3 = {
				enable = true;
				extraPackages = with pkgs; [
					dmenu #application launcher most people use
					i3status # gives you the default i3 status bar
					i3lock #default i3 screen locker
					i3blocks #if you are planning on using i3blocks over i3status
					dunst
					rofi
					rofi-pass
					(polybar.override { i3Support = true; })
					clipmenu
					udiskie
				];
			};
		};

		# remote desktop
		xrdp = {
			enable = true;
			defaultWindowManager = "i3";
		};
	};

	# Open ports in the firewall.
	networking.firewall.allowedTCPPorts = [ 3389 8888 ];
	networking.firewall.allowedUDPPorts = [ 3389 8888 ]; 
	# Or disable the firewall altogether.
	networking.firewall.enable = true;

	# Enable CUPS to print documents.
	# services.printing.enable = true;

	# Enable sound.
	sound.enable = true;
    #hardware.pulseaudio.enable = true;
	#hardware.pulseaudio.support32Bit = true; #steam
	#hardware.pulseaudio.extraConfig = "unload-module module-suspend-on-idle"; 

	# pipewire is supposedly better but still buggy 
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		pulse.enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
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

	virtualisation = {
		docker.enable = true;
		libvirtd.enable = true;
		lxd.enable = true;
        lxc.enable = true;
	};
	systemd.services.lxd.path = with pkgs; [ lvm2 thin-provisioning-tools e2fsprogs ];
	
	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.bogdb = {
		isNormalUser = true;
		extraGroups = [ "adbusers" "disk" "wheel" "audio" "video" "networkmanager" "kvm" "libvirtd" "lxd" "docker" ]; # Enable ‘sudo’ for the user.
	};

	# This value determines the NixOS release with which your system is to be
	# compatible, in order to avoid breaking some software such as database
	# servers. You should change this only after NixOS release notes say you
	# should.
	system.stateVersion = "20.09"; # Did you read the comment?
}



