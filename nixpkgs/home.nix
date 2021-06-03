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
        gh
        gitui
        gsimplecal
        lazygit
        miller
        ncdu
        neovide
        neovim-qt
        pcmanfm-qt
        qalculate-gtk
        sakura
        tilix
        somafm-cli
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

    programs.neovim = {
      enable = true;

      withPython3 = true;
      withNodeJs = true;

      plugins = with pkgs.vimPlugins; [
        { plugin = awesome-vim-colorschemes; }
        { plugin = coc-clangd; }
        { plugin = coc-fzf; }
        { plugin = coc-nvim; }
        { plugin = coc-vimlsp; }
        { plugin = fzf-vim; }
        { plugin = lazygit-nvim; }
        { plugin = nerdtree; }
        { plugin = nvim-base16; }
        { plugin = vim-lsp-cxx-highlight; }
        { plugin = vim-nix; }
        { plugin = vim-pandoc-syntax; }
        { plugin = vim-pandoc; }
        { plugin = vimtex; }
      ];

      extraConfig = ''
          set nocompatible
          set mouse=a
          set clipboard+=unnamedplus
          " Paste with <Shift> + <Insert>
          imap <S-Insert> <C-R>*
          set linespace=1
          filetype on
          set sw=4
          set ts=4

          set encoding=utf-8
          set backspace=indent,eol,start " allow backspacing over everything in insert mode
          set linespace=1
          set expandtab
          set nu
          set autoindent
          set ruler
          set showcmd
          set incsearch
          set wrap linebreak nolist

          map <F2> :w!<CR>
          map <F3> :NERDTreeToggle<CR>
          map <F4> :bdelete<CR>
          map <F5> :bprevious<CR>
          map <F6> :bnext<CR>
      '';
    };

    xresources.extraConfig = ''
      *TkTheme: awdark;
    '';

}
