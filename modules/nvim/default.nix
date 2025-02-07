{ pkgs, ... }:

let
  # vim-buffet = pkgs.vimUtils.buildVimPlugin {
  #   name = "onedark";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "bagrat";
  #     repo = "vim-buffet";
  #     rev = "3ee5c836cd7ded3526902122e06110cd3f8549cb";
  #     hash = "sha256-cyZN06Dn+qaL5AjbZfBZIj9Est7b+Q8BYemmWpCt7Gs=";
  #   };
  # };

  # vim-airline-theme = pkgs.vimUtils.buildVimPlugin {
  #   name = "airline-themes";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "vim-airline";
  #     repo = "vim-airline-themes";
  #     rev = "dd81554c2231e438f6d0e8056ea38fd0e80ac02a";
  #     hash = "sha256-OOmmdHDWVazs4UqIm0xTdQ66as4/TqEs+EQA/TDiUBY=";
  #   };
  # };

  # nvim-tree = pkgs.vimUtils.buildVimPlugin {
  #   name = "nvim-tree";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "nvim-tree";
  #     repo = "nvim-tree.lua";
  #     rev = "4af572246ce49883e2a52c49203a19984454f2e0";
  #     hash = "sha256-c4xsbCGsm67wssPdmRoHk/8HEOqlPu1RHSWKlvEI9vw=";
  #   };
  # };

in
{
  home.packages = with pkgs; [ lunarvim ];

  programs.zsh.shellAliases = {
    vi = "lvim";
    vim = "lvim";
    nvim = "lvim";
  };

  home.file.".config/lvim/config.lua".source = ../../../dots/nvim/config.lua;
  #   programs.neovim = {
  #     enable = true;
  #     defaultEditor = true;
  #     extraConfig = ''luafile ${../../../../dots/nvim/init.lua}'';
  #     viAlias = true;
  #     vimAlias = true;
  #     plugins = with pkgs.vimPlugins; [
  #       vim-devicons
  #       vim-startify
  #       nvim-tree
  #       vim-airline
  #       vim-airline-theme
  #       vim-buffet
  #       onedark-vim
  #       nvim-lspconfig
  #       (nvim-treesitter.withPlugins (p: [p.cpp p.java p.lua p.nix p.bash p.yuck]))
  #     ];

  #     coc = {
  #         enable = true;
  # #      settings = pkgs.lib.fileContents
  #     };
  # };
}
