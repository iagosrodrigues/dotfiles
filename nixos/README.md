# NixOS Configuration

A modular NixOS flake configuration with automatic host, user, and module discovery.

## Structure

```
.
├── flake.nix              # Main flake configuration
├── hosts/                 # Host-specific configurations
│   └── main/              # Example host configuration
├── users/                 # User configurations with home-manager
│   └── iago/              # Example user
├── modules/               # Reusable NixOS and home-manager modules
│   └── nixos/             # NixOS system modules
│       ├── 1password/
│       ├── development/
│       ├── gaming/
│       ├── virtualisation/
│       └── ...
├── packages/              # Custom package definitions
│   └── netskope-client/
└── lib/                   # Helper functions for discovery
```

## Features

- **Automatic Discovery**: Hosts, users, modules, and packages are automatically discovered
- **Home Manager Integration**: User configurations with home-manager
- **Secure Boot**: Lanzaboote support for secure boot
- **Modular Design**: Reusable modules for different system features
- **NUR Support**: Nix User repository overlay included

## Usage Without Cloning

### Quick System Rebuild

Rebuild your system directly from GitHub:

```bash
sudo nixos-rebuild switch --flake github:iagosrodrigues/dotfiles#HOSTNAME
```

Replace `iagosrodrigues/dotfiles` with your repository path and `HOSTNAME` with your host name (e.g., `main`).

### Test Configuration

Test without switching:

```bash
sudo nixos-rebuild test --flake github:iagosrodrigues/dotfiles#HOSTNAME
```

### Build Only

Build the configuration without activating:

```bash
sudo nixos-rebuild build --flake github:iagosrodrigues/dotfiles#HOSTNAME
```

### Using a Specific Commit/Branch

```bash
# Use a specific branch
sudo nixos-rebuild switch --flake github:iagosrodrigues/dotfiles/BRANCH#HOSTNAME

# Use a specific commit
sudo nixos-rebuild switch --flake github:iagosrodrigues/dotfiles/COMMIT#HOSTNAME
```

## Initial Installation

For a fresh installation:

1. Boot into NixOS installer
2. Partition and format your disks
3. Generate hardware configuration:
   ```bash
   nixos-generate-config --root /mnt
   ```
4. Install directly from GitHub:
   ```bash
   sudo nixos-install --flake github:iagosrodrigues/dotfiles#HOSTNAME
   ```

## Adding a New Host

1. Create a new directory in `hosts/`:
   ```
   hosts/
   └── NEW_HOSTNAME/
       ├── default.nix              # Host attributes (system, modules)
       ├── configuration.nix        # Main configuration
       └── hardware-configuration.nix
   ```

2. The host will be automatically discovered and available as:
   ```bash
   sudo nixos-rebuild switch --flake .#NEW_HOSTNAME
   ```

## Adding a New User

1. Create a new directory in `users/`:
   ```
   users/
   └── iagosrodrigues/
       ├── default.nix    # User system configuration
       └── home.nix       # Home-manager configuration
   ```

2. Users are automatically discovered and configured

## Adding Custom Modules

Drop module directories into:
- `modules/nixos/` for system-level modules
- `modules/home-manager/` for user-level modules (if created)

Modules are automatically imported and available to all configurations.

## Flake Inputs

This configuration uses:
- **nixpkgs**: NixOS unstable
- **home-manager**: User environment management
- **lanzaboote**: Secure boot support
- **hyprland**: Wayland compositor
- **disko**: Declarative disk partitioning
- **impermanence**: Stateless system support
- **rust-overlay**: Rust toolchain management
- **NUR**: Community package repository

## Update Inputs

```bash
# Update all inputs
nix flake update github:iagosrodrigues/dotfiles

# Update specific input
nix flake lock --update-input nixpkgs github:iagosrodrigues/dotfiles
```

## Available Outputs

- `nixosConfigurations.*`: System configurations
- `nixosModules.*`: Reusable NixOS modules
- `homeModules.*`: Reusable home-manager modules
- `packages.*`: Custom packages
- `formatter.*`: Code formatter (Alejandra)
