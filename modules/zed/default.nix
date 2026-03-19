{ config, pkgs, ... }: 
let
  extentions = import ./extensions.nix;
  terminal = import ./terminal.nix { inherit config; };
  lsp = import ./lsp.nix { inherit pkgs; };
  settings = import ./settings.nix { inherit config; };
  keymap = import ./keymap.nix;
in {
  programs.zed-editor = {
    enable = true;
    mutableUserKeymaps = false;
    mutableUserSettings = false;
    extensions = extentions;
    userKeymaps = keymap;
    userSettings =
      settings
      // {
        terminal = terminal;
        lsp = lsp;
      };
  };
}