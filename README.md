# TotalTax's Nix config:

This is my nixos config, its changing all the time and is probably not stable.

File Structure:
```
.
├── build.sh
├── dots
│   ├── alacritty
│   │   └── tmux-attach.sh
│   ├── btop
│   │   └── themes
│   │       └── system.theme
│   ├── eww
│   │   ├── eww.scss
│   │   ├── eww.yuck
│   │   ├── modules
│   │   │   ├── info.yuck
│   │   │   ├── main.yuck
│   │   │   └── system.yuck
│   │   ├── nixos-icon.svg
│   │   └── scripts
│   │       ├── battery.sh
│   │       ├── currentapp.sh
│   │       ├── music.sh
│   │       ├── music_utils.sh
│   │       ├── pop.sh
│   │       ├── sys_info.sh
│   │       └── vpn.sh
│   ├── hypr
│   │   ├── hyprland
│   │   │   ├── desktopExtra.conf
│   │   │   ├── hyprland.conf
│   │   │   ├── laptopExtra.conf
│   │   │   └── laptopStrixExtra.conf
│   │   ├── hyprlock.conf
│   │   └── scripts
│   │       ├── background.sh
│   │       └── screen-rec.sh
│   ├── neofetch
│   │   └── config.conf
│   ├── nvim
│   │   └── config.lua
│   ├── rofi
│   │   ├── config.rasi
│   │   └── systemTheme.rasi
│   ├── swww
│   │   ├── desktop
│   │   │   ├── 2nd.jpg
│   │   │   └── ultrawide.png
│   │   └── wallpapers
│   │       ├── 10.jpg
│   │       ├── 11.jpg
│   │       ├── 12.jpg
│   │       ├── 13.jpg
│   │       ├── 14.jpg
│   │       ├── 15.jpg
│   │       ├── 16.jpg
│   │       ├── 17.jpg
│   │       ├── 18.jpg
│   │       ├── 19.jpg
│   │       ├── 1.jpg
│   │       ├── 20.jpg
│   │       ├── 21.jpg
│   │       ├── 22.jpg
│   │       ├── 23.jpg
│   │       ├── 24.jpg
│   │       ├── 25.jpg
│   │       ├── 26.jpg
│   │       ├── 27.jpg
│   │       ├── 28.jpg
│   │       ├── 29.jpg
│   │       ├── 2.jpg
│   │       ├── 3.jpg
│   │       ├── 4.jpg
│   │       ├── 5.jpg
│   │       ├── 6.jpg
│   │       ├── 7.jpg
│   │       ├── 8.jpg
│   │       └── 9.jpg
│   ├── vscode
│   │   ├── customcss.css
│   │   ├── keybinds.json
│   │   ├── settings.json
│   │   ├── shell.nix
│   │   └── systemtheme
│   │       ├── CHANGELOG.md
│   │       ├── package.json
│   │       ├── README.md
│   │       ├── themes
│   │       │   ├── System Theme-color-theme.json
│   │       │   └── system.tmTheme
│   │       └── vsc-extension-quickstart.md
│   └── zsh
│       └── tmux.conf
├── external
│   └── pkgs
│       ├── conductor
│       │   └── default.nix
│       ├── flightcore
│       │   ├── Cargo.lock
│       │   ├── default.nix
│       │   └── package.json
│       ├── gfn-electron
│       │   └── default.nix
│       ├── hyprland-workspaces
│       │   └── default.nix
│       ├── pathplanner
│       │   ├── default.nix
│       │   └── pubspec.lock.json
│       └── rofi-copyq
│           ├── better_type.patch
│           └── default.nix
├── flake.lock
├── flake.nix
├── HOST
├── modules
│   ├── home-manager
│   │   ├── common
│   │   │   └── default.nix
│   │   ├── desktop
│   │   │   └── default.nix
│   │   ├── laptop
│   │   │   └── default.nix
│   │   ├── laptop-strix
│   │   │   └── default.nix
│   │   ├── modules
│   │   │   ├── alacritty
│   │   │   │   └── default.nix
│   │   │   ├── btop
│   │   │   │   └── default.nix
│   │   │   ├── dunst
│   │   │   │   └── default.nix
│   │   │   ├── eww
│   │   │   │   └── default.nix
│   │   │   ├── hypr
│   │   │   │   ├── hyprland.nix
│   │   │   │   └── hyprlock.nix
│   │   │   ├── neofetch
│   │   │   │   └── default.nix
│   │   │   ├── nvim
│   │   │   │   └── default.nix
│   │   │   ├── rofi
│   │   │   │   └── default.nix
│   │   │   ├── shell
│   │   │   │   ├── default.nix
│   │   │   │   └── src
│   │   │   │       ├── shells
│   │   │   │       │   ├── cuda_tools
│   │   │   │       │   │   └── default.nix
│   │   │   │       │   ├── java_17
│   │   │   │       │   │   └── default.nix
│   │   │   │       │   ├── nextjs
│   │   │   │       │   │   └── default.nix
│   │   │   │       │   └── rust
│   │   │   │       │       ├── default.nix
│   │   │   │       │       └── rust-toolchain
│   │   │   │       └── shell.sh
│   │   │   ├── terminal
│   │   │   │   └── default.nix
│   │   │   ├── utils.nix
│   │   │   └── vscode
│   │   │       └── default.nix
│   │   └── remote
│   │       └── default.nix
│   └── nixos
│       ├── common
│       │   └── default.nix
│       ├── desktop
│       │   ├── configuration.nix
│       │   └── hardware.nix
│       ├── laptop
│       │   ├── configuration.nix
│       │   ├── hardware.nix
│       │   ├── secrets
│       │   │   └── secrets.yml
│       │   ├── vfio
│       │   │   ├── default.nix
│       │   │   ├── linux-fake-rdtsc.patch
│       │   │   ├── OVMF.nix
│       │   │   └── win10.sh
│       │   └── wireguard
│       │       └── default.nix
│       ├── laptop-strix
│       │   ├── configuration.nix
│       │   ├── hardware.nix
│       │   ├── secrets
│       │   │   └── secrets.yml
│       │   ├── vfio
│       │   │   ├── default.nix
│       │   │   ├── linux-fake-rdtsc.patch
│       │   │   ├── OVMF.nix
│       │   │   └── win10.sh
│       │   └── wireguard
│       │       └── default.nix
│       └── remote
│           ├── configuration.nix
│           └── hardware.nix
├── outputs
│   ├── home.nix
│   └── nixos.nix
├── overlays
│   ├── apply
│   │   ├── default.nix
│   │   └── patches
│   │       └── xplorer_json_storage.patch
│   └── default.nix
├── README.md
├── result -> /nix/store/bxz947ibjjya3nx66imvcclqskykk740-home-manager-generation
├── theme
│   └── custom.nix
└── tree.txt

72 directories, 135 files
```
### What is this??
- `build.sh` is a shell script to make rebuilding easier.
- `flake.nix` defines all of the inputs and outputs of this flake.
- `dots/` this directory contains all of the dotfiles for diffrent applications. (`dots/[application]/(requried config files)` included in `modules/home-manager/[host]/[app]/default.nix`)
- `external/` contains any packages that I want to use that are not included in nixpkgs
- `modules` this directory contains the bulk of the config, including: 
    - application deffintions
    - hosts
    - hardware confiurations for hosts
    - everything else
- `outputs/` top-level defintions of the diffrent hosts this flake is used on (if you want to use this, add your own host to `outputs/nixos.nix` and `outputs/home.nix`).
- `overlays/` any modifictions to existing nixpkgs pkgs go here. (eg: patches, diffrent sources, etc)
- `theme/` some custom themes, I should move this to external

## Install
```
1. $ cd ~
2. $ git clone https://github.com/TotalTaxAmount/nix.git && cd nix
3. Replace all the 'totaltaxamount's with your username (the main one is in flake.nix but there are a few hiding in outher files)
4. Create the directory ~/nix/modules/nixos/[your host]
5. In that directory create a configuration.nix (look at ~/nix/system/hosts/laptop/configuration.nix) for examples
6. Inside of /outputs/nixos.nix create a new output with the name of your host (look at the outher entries for examples)
7. $ ./build.sh fresh
8. Enter the host that you have defined previously
```

**Note**: After doing this you should be able to update your system with `update home/system` from anywhere.

## To Do
- [x] Better support for multi-device
- [ ] Fix vscode theme
- [ ] Finish Eww (rewrite)
    - [x] System info (cpu, ram, disk, etc)
- [x] Make background switcher
- [x] ~~Swaylock~~ Hyprlock
- [ ] Store secrets in private git repo
- [ ] Finish wireguard
    - [ ] Make wireguard easy to toggle
- [ ] Rename host laptop to laptop-zeph
- [ ] Remove all non /nix/store paths (things like ~/, or /home/${user})
