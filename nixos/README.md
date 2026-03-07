# NixOS Flake (flake-parts)

A clean, maintainable NixOS configuration using flake-parts and import-tree.

## Quick Start

```bash
cd ~/personal/dotfiles/nixos/new-flake

# Test build (safe - doesn't change system)
nixos-rebuild build --flake .#main

# Apply changes
sudo nixos-rebuild switch --flake .#main
```

## Directory Structure

```
new-flake/
├── flake.nix                    # Main flake using flake-parts
├── modules/
│   ├── flake/                   # Flake-level configuration
│   │   ├── devshell.nix         # Dev tools & formatter
│   │   ├── home-manager.nix     # Home-manager base config
│   │   └── nixpkgs.nix          # Nixpkgs config & overlays
│   ├── hosts/
│   │   └── darkplace.nix        # Host definition
│   ├── hardware/
│   │   └── darkplace.nix        # Hardware configuration
│   ├── users/
│   │   └── iago.nix             # User & home-manager config
│   ├── private/
│   │   └── default.nix          # Private flake integration
│   ├── system/                  # System-level NixOS modules
│   │   ├── audio.nix            # PipeWire audio
│   │   ├── fonts.nix            # System fonts
│   │   ├── io-schedulers.nix    # I/O scheduler tuning
│   │   ├── lact.nix             # AMD GPU control
│   │   ├── networking.nix       # Network & locale settings
│   │   ├── nix.nix              # Nix settings & GC
│   │   └── virtualisation.nix   # Docker, libvirt, etc.
│   ├── desktop/                 # Desktop environment modules
│   │   ├── ashell.nix           # Ashell status bar
│   │   ├── gnome.nix            # GNOME DE + dconf
│   │   └── niri.nix             # Niri compositor
│   ├── gaming/                  # Gaming-related modules
│   │   ├── gamemode.nix         # GameMode + kernel tuning
│   │   ├── graphics.nix         # AMD GPU + ROCm
│   │   ├── steam.nix            # Steam + Proton
│   │   └── vr.nix               # VR (Envision, WiVRn)
│   ├── apps/                    # Application modules
│   │   ├── _1password.nix       # 1Password
│   │   ├── browsers.nix         # Firefox, Chrome
│   │   ├── ghostty.nix          # Ghostty terminal
│   │   ├── git.nix              # Git configuration
│   │   ├── media.nix            # Media apps
│   │   └── zed.nix              # Zed editor
│   ├── cli/                     # CLI tool modules
│   │   ├── dev-tools.nix        # Development tools
│   │   ├── shell.nix            # Fish shell
│   │   └── tmux.nix             # Tmux configuration
│   └── theming/
│       └── dark.nix             # Dark theme settings
└── README.md                    # This file
```

## Architecture

This flake uses:

- **[flake-parts](https://github.com/hercules-ci/flake-parts)**: Modular flake structure
- **[import-tree](https://github.com/vic/import-tree)**: Automatic module discovery

### How It Works

The `flake.nix` is minimal:

```nix
{
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
}
```

All configuration lives in `./modules/`. The import-tree recursively imports all `.nix` files, and flake-parts combines them into:

- `flake.modules.nixos.*` → NixOS modules
- `flake.modules.homeManager.*` → Home-manager modules
- `perSystem.*` → Per-system outputs (formatter, devShells)
- `flake.nixosConfigurations.*` → Host definitions

## Inputs

| Input | Description |
|-------|-------------|
| `nixpkgs` | NixOS unstable |
| `flake-parts` | Modular flake framework |
| `import-tree` | Automatic module discovery |
| `home-manager` | User environment management |
| `nur` | Nix User Repository |
| `alejandra` | Nix formatter |
| `niri` | Scrollable tiling Wayland compositor |
| `ghostty` | GPU-accelerated terminal |
| `ashell` | Status bar for niri |
| `hytale-launcher` | Hytale game launcher |
| `rust-overlay` | Rust toolchain overlay |
| `agenix` | Encrypted secrets with age |
| `agenix-rekey` | Rekey secrets per host |

## Module Types

### NixOS Modules (`flake.modules.nixos.*`)

System-level configuration applied via `nixosSystem`:

```nix
# modules/system/audio.nix
{...}: {
  flake.modules.nixos.audio = {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };
}
```

### Home-Manager Modules (`flake.modules.homeManager.*`)

User-level configuration applied via `home-manager.sharedModules`:

```nix
# modules/desktop/ashell.nix
{...}: {
  flake.modules.homeManager.ashell = {...}: {
    programs.ashell = {
      enable = true;
      settings = { ... };
    };
  };
}
```

### Combined Modules

Some modules define both NixOS and home-manager config:

```nix
# modules/desktop/gnome.nix
{...}: {
  flake.modules.nixos.gnome = {pkgs, ...}: {
    services.desktopManager.gnome.enable = true;
    # ...
  };

  flake.modules.homeManager.gnome = {lib, ...}: {
    dconf.settings = { ... };
  };
}
```

### Host Definition

```nix
# modules/hosts/darkplace.nix
{inputs, config, ...}: let
  nixosModules = builtins.attrValues config.flake.modules.nixos;
  hmModules = builtins.attrValues config.flake.modules.homeManager;
in {
  flake.nixosConfigurations.main = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = nixosModules ++ [{
      home-manager.sharedModules = hmModules ++ [
        inputs.niri.homeModules.niri
      ];
    }];
  };
}
```

## Common Commands

```bash
# Build without switching
nixos-rebuild build --flake .#main

# Build and switch
sudo nixos-rebuild switch --flake .#main

# Enter dev shell
nix develop

# Format code
nix fmt

# Update all inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Show flake structure
nix flake show
```

## Adding New Configuration

### Adding a New NixOS Module

Create a file in the appropriate directory:

```nix
# modules/system/bluetooth.nix
{...}: {
  flake.modules.nixos.bluetooth = {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
```

It will be automatically discovered and included.

### Adding a New Home-Manager Module

```nix
# modules/apps/neovim.nix
{...}: {
  flake.modules.homeManager.neovim = {pkgs, ...}: {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
```

### Adding a New Host

1. Create hardware config:

```nix
# modules/hardware/newhost.nix
{...}: {
  flake.modules.nixos.hardware-newhost = {
    boot.loader.systemd-boot.enable = true;
    # ... hardware-specific config
  };
}
```

2. Create host definition:

```nix
# modules/hosts/newhost.nix
{inputs, config, ...}: let
  nixosModules = builtins.attrValues config.flake.modules.nixos;
  hmModules = builtins.attrValues config.flake.modules.homeManager;
in {
  flake.nixosConfigurations.newhost = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = nixosModules ++ [{
      home-manager.sharedModules = hmModules ++ [
        inputs.niri.homeModules.niri
      ];
    }];
  };
}
```

## Secrets Management

Secrets are managed in-repo with `agenix` + `agenix-rekey`.

- Base configuration lives in `modules/system/agenix.nix`
- Secret files and rekeyed outputs live under `secrets/`
- Setup and daily commands are documented in `secrets/README.md`

## Overlays

Configured in `modules/flake/nixpkgs.nix`:

- `nur.overlays.default` - Nix User Repository
- `niri.overlays.niri` - Niri compositor
- `ghostty.overlays.default` - Ghostty terminal

## Dev Shell

Available tools (`nix develop`):

- `alejandra` - Nix formatter
- `deadnix` - Dead code finder
- `nixpkgs-fmt` - Alternative formatter
- `statix` - Nix linter
- `nil` - Nix LSP

## Troubleshooting

### "attribute 'X' missing"
Check the module is exporting to the correct path (`flake.modules.nixos.*` or `flake.modules.homeManager.*`)

### "infinite recursion"
Check for circular imports or option references between modules

### Module not found
Make sure the file is tracked by git (`git add`)

### Build fails after adding module
Check syntax with `nix flake check` or try `nix eval .#nixosConfigurations.main`

## Rollback

```bash
# Select previous generation in bootloader

# Or rebuild with rollback
sudo nixos-rebuild switch --rollback

# Or specify a generation
sudo nixos-rebuild switch --rollback-to 42
```

## Resources

- [flake-parts documentation](https://flake.parts/)
- [import-tree](https://github.com/vic/import-tree)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)

---

**Philosophy:** Modular, discoverable, and maintainable. Each concern lives in its own file, automatically composed into a complete system.
