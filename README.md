# TotaltTax's Nix config:

This is my nixos config, its changing all the time and is probaly not stable.

**DE** - Hyprland\
**Terminal** - Alacritty (with tmux)\
**Theme** - Kinda Nordic\
**Bar** - Eww\
**Browser** - Brave\
**Login manager** - GDM

Layout of this repo:

```
.
├── build.sh
├── flake.lock
├── flake.nix
├── home
│   ├── config
│   │   ├── grimblast
│   │   ├── icons
│   │   │   └── candy-icons.nix
│   │   ├── nvim
│   │   │   ├── configs
│   │   │   │   ├── nvim-tree.lua
│   │   │   │   ├── vim-airline.lua
│   │   │   │   └── vim-buffet.lua
│   │   │   ├── init.lua
│   │   │   ├── nvim.nix
│   │   │   ├── parsers
│   │   │   │   ├── parser
│   │   │   │   │   ├── bash.so
│   │   │   │   │   ├── ini.so
│   │   │   │   │   ├── json.so
│   │   │   │   │   ├── lua.so
│   │   │   │   │   ├── markdown.so
│   │   │   │   │   ├── nix.so
│   │   │   │   │   ├── python.so
│   │   │   │   │   ├── scss.so
│   │   │   │   │   ├── vimdoc.so
│   │   │   │   │   ├── vim.so
│   │   │   │   │   ├── yaml.so
│   │   │   │   │   └── yuck.so
│   │   │   │   └── parser-info
│   │   │   │       ├── bash.revision
│   │   │   │       ├── ini.revision
│   │   │   │       ├── json.revision
│   │   │   │       ├── lua.revision
│   │   │   │       ├── markdown.revision
│   │   │   │       ├── nix.revision
│   │   │   │       ├── python.revision
│   │   │   │       ├── scss.revision
│   │   │   │       ├── vimdoc.revision
│   │   │   │       ├── vim.revision
│   │   │   │       ├── yaml.revision
│   │   │   │       └── yuck.revision
│   │   │   └── utils
│   │   │       └── utils.lua
│   │   ├── shells
│   │   │   └── shell.sh
│   │   └── term
│   │       ├── config
│   │       └── term.nix
│   ├── custom-pkgs
│   │   └── sysmontask.nix
│   ├── home.nix
│   └── home.nix.back
├── outputs
│   ├── home.nix
│   └── nixos.nix
├── README.md
└── system
    ├── configuration.nix
    └── machines
        └── laptop.nix
```
### WTF is all this shit
- `build.sh` is a shell script to mange some build commands its very simple.
- `flake.nix` the flake for this config??! idk how to explain.
- `home/` is for home manager configurations, all the parser shit in the `home/config/nivm` is for treesitter and not really importent.
- `system/` is the nix system configs, includes the `configuration.nix` and hardware configs for diffrent devices.
- `outputs/` nix modules for generating the config from the `system/` and `home/` directorys.

## Install
If you want to install this config it would go something like this:
```
1. cd ~/.config
2. git clone https://github.com/TotalTaxAmount/nix.git && cd nix
3. Replace all the "totaltaxamount" strings with your username (there are a few but I will fix sometime)
4. ./build.sh system
5. ./build.sh home
```

**Note**: After doing this you should be able to update your system with `update home/system` from anywhere.