# TotaltTax's Nix config:

This is my nixos config, its changing all the time and is probably not stable.

Installer is broken atm will fix soon (hopefully)

**DE** - Hyprland\
**Terminal** - Alacritty (with tmux)\
**Theme** - Changes\
**Bar** - Eww\
**Browser** - Brave\
**Tools** - To many
**More shit** - ???

Layout of this repo:

```
.
├── build.sh
├── custom
│   ├── flightcore
│   │   ├── Cargo.lock
│   │   ├── default.nix
│   │   └── package.json
│   ├── rofi-copyq
│   │   ├── better_type.patch
│   │   └── default.nix
│   └── schemer2
│       └── default.nix
├── dots
│   ├── alacritty
│   │   └── tmux
│   │       └── tmux.conf
│   ├── btop
│   │   └── themes
│   │       └── system.theme
│   ├── discord
│   │   └── system.theme.css
│   ├── eww
│   │   ├── eww.scss
│   │   ├── eww.yuck
│   │   ├── modules
│   │   │   ├── info.yuck
│   │   │   ├── main.yuck
│   │   │   └── system.yuck
│   │   ├── music.svg
│   │   ├── nixos-icon.svg
│   │   └── scripts
│   │       ├── battery.sh
│   │       ├── currentapp.sh
│   │       ├── music.sh
│   │       ├── music_utils.sh
│   │       ├── pop.sh
│   │       ├── sys_info.sh
│   │       ├── vpn.sh
│   │       └── workspaces.sh
│   ├── hypr
│   │   ├── hyprland.conf
│   │   └── scripts
│   │       └── background.sh
│   ├── neofetch
│   │   └── config.conf
│   ├── nvim
│   │   ├── configs
│   │   │   ├── nvim-tree.lua
│   │   │   ├── vim-airline.lua
│   │   │   └── vim-buffet.lua
│   │   ├── init.lua
│   │   ├── parsers
│   │   │   ├── parser
│   │   │   │   ├── bash.so
│   │   │   │   ├── gitcommit.so
│   │   │   │   ├── ini.so
│   │   │   │   ├── json.so
│   │   │   │   ├── lua.so
│   │   │   │   ├── markdown.so
│   │   │   │   ├── nix.so
│   │   │   │   ├── python.so
│   │   │   │   ├── scss.so
│   │   │   │   ├── vimdoc.so
│   │   │   │   ├── vim.so
│   │   │   │   ├── yaml.so
│   │   │   │   └── yuck.so
│   │   │   └── parser-info
│   │   │       ├── bash.revision
│   │   │       ├── gitcommit.revision
│   │   │       ├── ini.revision
│   │   │       ├── json.revision
│   │   │       ├── lua.revision
│   │   │       ├── markdown.revision
│   │   │       ├── nix.revision
│   │   │       ├── python.revision
│   │   │       ├── scss.revision
│   │   │       ├── vimdoc.revision
│   │   │       ├── vim.revision
│   │   │       ├── yaml.revision
│   │   │       └── yuck.revision
│   │   └── utils
│   │       └── utils.lua
│   ├── prismLauncher
│   │   └── theme
│   │       ├── preview.png
│   │       ├── preview.png.license
│   │       ├── theme.json
│   │       ├── theme.json.license
│   │       └── themeStyle.css
│   ├── rofi
│   │   ├── config.rasi
│   │   └── systemTheme.rasi
│   ├── swaylock
│   │   └── config
│   ├── swww
│   │   └── wallpapers
│   │       ├── 10.jpg
│   │       ├── 11.jpg
│   │       ├── 12.jpg
│   │       ├── 13.jpg
│   │       ├── 1.jpg
│   │       ├── 2.jpg
│   │       ├── 3.jpg
│   │       ├── 4.jpg
│   │       ├── 5.jpg
│   │       ├── 6.jpg
│   │       ├── 7.jpg
│   │       ├── 8.jpg
│   │       └── 9.jpg
│   ├── vscode
│   │   ├── keybinds.json
│   │   ├── settings.json
│   │   ├── shell.nix
│   │   └── systemtheme
│   │       ├── CHANGELOG.md
│   │       ├── package.json
│   │       ├── README.md
│   │       ├── themes
│   │       │   ├── System Theme-color-theme.json
│   │       │   └── system.tmTheme
│   │       └── vsc-extension-quickstart.md
│   └── xplorer
│       └── systemTheme.xtension
├── flake.lock
├── flake.nix
├── HOST
├── hosts
│   ├── default.nix
│   ├── laptop
│   │   ├── configuration.nix
│   │   ├── hardware.nix
│   │   └── secrets
│   │       └── secrets.yml
│   └── remote
│       ├── configuration.nix
│       └── hardware.nix
├── modules
│   ├── home
│   │   ├── common
│   │   │   ├── btop
│   │   │   │   └── default.nix
│   │   │   ├── default.nix
│   │   │   ├── neofetch
│   │   │   │   └── default.nix
│   │   │   ├── nvim
│   │   │   │   └── default.nix
│   │   │   └── terminal
│   │   │       ├── config
│   │   │       └── default.nix
│   │   ├── laptop
│   │   │   ├── alacritty
│   │   │   │   └── default.nix
│   │   │   ├── default.nix
│   │   │   ├── discord
│   │   │   │   └── default.nix
│   │   │   ├── dunst
│   │   │   │   └── default.nix
│   │   │   ├── eww
│   │   │   │   └── default.nix
│   │   │   ├── hypr
│   │   │   │   └── default.nix
│   │   │   ├── icons
│   │   │   │   └── candy-icons.nix
│   │   │   ├── prismLauncher
│   │   │   │   └── default.nix
│   │   │   ├── rofi
│   │   │   │   └── default.nix
│   │   │   ├── swaylock
│   │   │   │   └── default.nix
│   │   │   ├── vscode
│   │   │   │   └── default.nix
│   │   │   └── xplorer
│   │   │       └── default.nix
│   │   └── remote
│   │       └── default.nix
│   └── system
│       └── wireguard.nix
├── outputs
│   ├── home.nix
│   └── nixos.nix
├── overlays
│   ├── apply
│   │   ├── default.nix
│   │   └── patches
│   │       └── xplorer_json_storage.patch
│   └── default.nix
├── README.md
├── shells
│   ├── apk_debug
│   │   └── default.nix
│   ├── cuda_tools
│   │   └── default.nix
│   └── rust
│       ├── default.nix
│       └── rust-toolchain
├── shell.sh
├── theme
│   └── custom.nix
└── utils
    └── color.nix
```
### WTF is all this shit
- `build.sh` is a shell script to mange some build commands its very simple.
- `flake.nix` the flake for this config??! idk how to explain.
- `outputs/` nix modules for generating the config from the `system/` and `home/` directorys.
- `overlays/` directory for overlays to apply patches or outher stuff (ex. discord with vecord)

## Install
If you want to install this config it would go something like this **(Dont right now doesnt work, I will fix it sometime)**:
```
1. $ cd ~
2. $ git clone https://github.com/TotalTaxAmount/nix.git && cd nix
3. Replace all the "totaltaxamount" strings with your username (there are a few but I will fix sometime)
4. Create the directory ~/nix/system/hosts/*Your host*
5. In that directory create a configuration.nix (look at ~/nix/system/hosts/laptop/configuration.nix) for examples
6. Inside of /outputs/nixos.nix create a new output with the name of your host (look at the outher entries for examples)
7. $ ./build.sh fresh
```

**Note**: After doing this you should be able to update your system with `update home/system` from anywhere.

## To Do
- [ ] Full Rewrite basicly 
- [ ] Better layout
    - [ ] File sturcture
- [ ] Better support for multi-device
- [ ] Rust anyalzer LSP working on remote better
- [ ] Fix vscode theme
    - [ ] Fix rust-anyalizer on the remote
- [ ] Explain the layout better
- [ ] Finish Eww (rewrite)
    - [ ] System info (cpu, ram, disk, etc)
- [ ] Make background switcher
- [ ] Swaylock
- [ ] Store secrets in private git repo
- [ ] Finish wireguard
    - [ ] Make wireguard easy to toggle
