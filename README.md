# TotaltTax's Nix config:

This is my nixos config, its changing all the time and is probaly not stable.

**DE** - Hyprland\
**Terminal** - Alacritty (with tmux)\
**Theme** - Changes\
**Bar** - Eww\
**Browser** - Brave\
**Login manager** - GDM\
**More shit** - ???

![image](https://github.com/TotalTaxAmount/nix/assets/64336456/0ce3764e-be0e-475a-8135-241fa65dd665)

Layout of this repo:

```
.
├── build.sh
├── dots
│   ├── btop
│   │   └── themes
│   │       └── system.theme
│   ├── eww
│   │   ├── eww.scss
│   │   ├── eww.yuck
│   │   ├── nixos-icon.svg
│   │   └── scripts
│   │       ├── battery
│   │       ├── currentapp
│   │       ├── music
│   │       ├── pop
│   │       ├── sys_info
│   │       └── workspaces
│   ├── hypr
│   │   ├── hyprland.conf
│   │   └── scripts
│   │       └── background.sh
│   ├── nvim
│   │   ├── configs
│   │   │   ├── nvim-tree.lua
│   │   │   ├── vim-airline.lua
│   │   │   └── vim-buffet.lua
│   │   ├── init.lua
│   │   ├── parsers
│   │   │   ├── parser
│   │   │   │   ├── bash.so
│   │   │   │   ├── ini.so
│   │   │   │   ├── json.so
│   │   │   │   ├── lua.so
│   │   │   │   ├── markdown.so
│   │   │   │   ├── nix.so
│   │   │   │   ├── python.so
│   │   │   │   ├── scss.so
│   │   │   │   ├── vimdoc.so
│   │   │   │   ├── vim.so
│   │   │   │   ├── yaml.so
│   │   │   │   └── yuck.so
│   │   │   └── parser-info
│   │   │       ├── bash.revision
│   │   │       ├── ini.revision
│   │   │       ├── json.revision
│   │   │       ├── lua.revision
│   │   │       ├── markdown.revision
│   │   │       ├── nix.revision
│   │   │       ├── python.revision
│   │   │       ├── scss.revision
│   │   │       ├── vimdoc.revision
│   │   │       ├── vim.revision
│   │   │       ├── yaml.revision
│   │   │       └── yuck.revision
│   │   └── utils
│   │       └── utils.lua
│   ├── rofi
│   │   ├── config.rasi
│   │   └── systemTheme.rasi
│   └── swww
│       └── wallpapers
│           ├── 10.jpg
│           ├── 11.jpg
│           ├── 12.jpg
│           ├── 13.jpg
│           ├── 1.jpg
│           ├── 2.jpg
│           ├── 3.jpg
│           ├── 4.jpg
│           ├── 5.jpg
│           ├── 6.jpg
│           ├── 7.jpg
│           ├── 8.jpg
│           └── 9.jpg
├── flake.lock
├── flake.nix
├── home
│   ├── custom-pkgs
│   │   └── sysmontask.nix
│   ├── home.nix
│   └── modules
│       ├── alacritty
│       │   ├── config
│       │   └── default.nix
│       ├── btop
│       │   └── default.nix
│       ├── dunst
│       │   └── default.nix
│       ├── eww
│       │   └── default.nix
│       ├── hypr
│       │   └── default.nix
│       ├── icons
│       │   └── candy-icons.nix
│       ├── nvim
│       │   └── default.nix
│       └── rofi
│           └── default.nix
├── outputs
│   ├── home.nix
│   └── nixos.nix
├── overlays
│   ├── apply
│   │   ├── default.nix
│   │   └── patches
│   └── default.nix
├── README.md
└── system
    ├── configuration.nix
    └── hosts
        └── laptop.nix
```
### WTF is all this shit
- `build.sh` is a shell script to mange some build commands its very simple.
- `flake.nix` the flake for this config??! idk how to explain.
- `home/` is for home manager configurations, all the parser shit in the `home/modules/nivm` is for treesitter and not really importent.
- `system/` is the nix system configs, includes the `configuration.nix` and hardware configs for diffrent devices.
- `outputs/` nix modules for generating the config from the `system/` and `home/` directorys.
- `overlays/` directory for overlays to apply patches or outher stuff (ex. discord with vecord)

## Install
If you want to install this config it would go something like this:
```
1. cd ~
2. git clone https://github.com/TotalTaxAmount/nix.git && cd nix
3. Replace all the "totaltaxamount" strings with your username (there are a few but I will fix sometime)
4. ./build.sh fresh
```

**Note**: After doing this you should be able to update your system with `update home/system` from anywhere.

## To Do
- [ ] Fix all paths
- [x] Better file layout
- [x] Add a global config thing to change colors from one place
- [x] Add eww configs
- [x] Understand flakes
- [x] Finish fully using color theme (i think).
- [x] Figure out how to use multiple hosts

