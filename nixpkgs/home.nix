{ config, pkgs, ... }:

{
    nixpkgs.overlays = [
        (import (builtins.fetchTarball {
            url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
        }))
        (import /home/bogdb/.config/nixpkgs/overlays/default.nix)
    ];

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "bogdb";
    home.homeDirectory = "/home/bogdb";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "21.05";

    home.sessionVariables = {
      EDITOR = "nvim";
      TCLLIBPATH = "~/.local/share/tk-themes";
    };


    home.packages = with pkgs; [
        # utilities
        alacritty
        bat
        chessx
        datamash
        exa
        fd
        flac
        flacon
        gh
        gitui
        gnome.gnome-dictionary
        gsimplecal
        kitty
        lazygit
        mac
        miller
        ncdu
        neovide
        neovim-qt
        pcmanfm-qt
        qalculate-gtk
        tilix
        scid-vs-pc
        somafm-cli
        stockfish
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
        typora
        libreoffice-fresh

        #multimedia
        lxqt.pavucontrol-qt
        mpv
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
        ungoogled-chromium

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

    programs.bash = {
      enable = true;
      shellAliases = {
        nv = "nvim-qt -- -u ~/.config/nvim/init.vim";
      };
    };

    programs.vscode = {
        enable = true;
        package = pkgs.vscode;
        extensions = with pkgs.vscode-extensions; [
          xaver.clang-format
          ms-vscode.cpptools
        ];
    };

    programs.neovim = {
      enable = true;

      withPython3 = true;
      withNodeJs = true;

      plugins = with pkgs.vimPlugins; [
        { plugin = awesome-vim-colorschemes; }
        #{ plugin = coc-clangd; }
        #{ plugin = coc-fzf; }
        #{ plugin = coc-nvim; }
        #{ plugin = coc-vimlsp; }
        { plugin = nvim-lspconfig; }
        { plugin = nvim-treesitter; }
        { plugin = completion-nvim; }
        { plugin = lualine-nvim; }
        { plugin = fzf-vim; }
        { plugin = lazygit-nvim; }
        { plugin = nerdtree; }
        { plugin = nvim-base16; }
        #{ plugin = vim-lsp-cxx-highlight; }
        { plugin = vim-nix; }
        { plugin = vim-pandoc-syntax; }
        { plugin = vim-pandoc; }
        { plugin = vimtex; }
      ];

      extraConfig = ''
          if !exists("homemanagerbug")
            let homemanagerbug = "yes"
            luafile /home/bogdb/.config/nvim/init.lua
          endif
      '';
    };

    xresources.extraConfig = ''
      *TkTheme: awdark;
    '';

}
