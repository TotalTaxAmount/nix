# TotalTax's Nix config:

This is my nixos config, its changing all the time and is probably not stable.

### What is this?
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
- [ ] Nixify hyprland + other stuff that didnt have a nix module when I created this
