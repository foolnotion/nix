{ config, pkgs, libs, ... }: 
let 
  nixConfigDir = "${config.home.homeDirectory}/.config/nixpkgs";
in
{
    programs.neovim = {
      enable = true;
      withPython3 = true;
      withNodeJs = true;
      plugins = with pkgs.vimPlugins; [
        { plugin = awesome-vim-colorschemes; }
        { plugin = completion-nvim; }
        { plugin = fzf-vim; }
        { plugin = lazygit-nvim; }
        { plugin = lualine-nvim; }
        { plugin = nerdtree; }
        { plugin = nvim-base16; }
        { plugin = nvim-lspconfig; }
        { plugin = nvim-tree-lua; }
        { plugin = nvim-treesitter; }
        { plugin = vim-nix; }
        { plugin = vim-pandoc-syntax; }
        { plugin = vim-pandoc; }
        { plugin = vimtex; }
      ];
    }; # neovim 
    xdg.configFile."nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "${nixConfigDir}/configs/nvim/lua";
    xdg.configFile."nvim/colors".source = config.lib.file.mkOutOfStoreSymlink "${nixConfigDir}/configs/nvim/colors";
    xdg.configFile."nvim/ginit.vim".source = config.lib.file.mkOutOfStoreSymlink "${nixConfigDir}/configs/nvim/ginit.vim";
    programs.neovim.extraConfig = "lua require('init')";
}
