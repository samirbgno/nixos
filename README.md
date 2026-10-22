# NixOS Configuration
A modular, scalable, and declarative NixOS environment built with Flakes and Home Manager. This repository serves as a framework to manage multiple machines across different hardware architectures and use cases (e.g., workstations, servers, laptops) from a single unified codebase.

## Features
* **Nix Flakes & Home Manager:** Fully reproducible system and user-level configuration.
* **Feature Toggles:** Granular control over software and system features using `lib.mkEnableOption` and `lib.mkIf`.
* **Domain-Driven Host Configuration:** Host-specific configurations are strictly separated by logical domains (`hardware`, `storage`, `system`, `software`).
* **Declarative Partitioning:** Automated disk layout, formatting, and swap allocation using `disko`.
* **Script Management:** Local shell scripts managed and integrated into the environment.

## Repository Structure
```text
.
├── flake.nix             # Entry point, inputs, and outputs definition
├── flake.lock            # Pinned dependency versions
├── hosts/                # Per-machine configurations
│   ├── common.nix        # Common configurations shared across hosts
│   └── <host>/           # Replace <host> with the machine's hostname
│       ├── default.nix   # Host entry point and module imports
│       ├── system.nix    # Core OS setup (networking, locale, bootloader)
│       ├── software.nix  # Application feature toggles (Neovim, VSCode, etc.)
│       ├── hardware.nix  # Kernel modules, microcode, and physical drivers
│       └── storage.nix   # Disko layouts, file systems, zramSwap, swapDevices, and backups
├── modules/              # Reusable modules containing feature toggles
│   ├── boot.nix          # Bootloader and splash screen options
│   ├── editors.nix       # Text editor configurations and XDG entries
│   ├── options.nix       # Global options schema (monitors, fonts, user)
│   └── ...               # Terminals, window managers, tools, etc.
└── scripts/              # Local shell scripts and utilities
```

## Bootstrapping a New Host
1. **Create the host directory:**
```bash
mkdir -p hosts/<host>
```
2. **Define domain files:**
Create `system.nix`, `software.nix`, `hardware.nix`, and `storage.nix` inside `hosts/<host>/`.
3. **Configure `default.nix`:**
Import `../common.nix` and the host domain files inside `hosts/<host>/default.nix`:
```nix
{
  imports = [
    ../common.nix
    ./system.nix
    ./software.nix
    ./hardware.nix
    ./storage.nix
  ];
}
```
4. **Update `flake.nix`:**
Add `<host>` to your `nixosConfigurations`.

## Installation
To apply the configuration to an existing NixOS installation, run:
```bash
sudo nixos-rebuild switch --flake .#<host>
```
To update the system and pull the latest flake inputs:
```bash
nix flake update
sudo nixos-rebuild switch --flake .#<host>
```

## Module Management
This framework relies on an opt-in philosophy. Modules defined in the `modules/` directory do nothing until explicitly enabled.
To enable a feature for a specific host, declare it in that host's `software.nix` or `system.nix` file:
```nix
# inside hosts/<host>/software.nix
dotfiles = {
  editors = {
    neovim.enable = true;
    vscode.enable = true;
  };
};
```
