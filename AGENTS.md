# AGENTS.md

Guidance for AI coding agents (opencode, Claude Code, Codex, Cursor) working in
this repository. It is **not** used by the Nix build; it only provides context.

## Overview

Rhodium is a hypermodular, declarative NixOS system built with flakes. System
configuration lives in `modules/` + `hosts/`; per-user configuration lives in
`home/` + `users/` through Home Manager, which is integrated as a **NixOS
module** (not standalone). Hosts, users and preferences are plain data in
`data/`.

This repo is a personal fork of
[pabloagn/rhodium](https://github.com/pabloagn/rhodium) ported so it installs on
any machine from a plain NixOS ISO. Upstream documentation lives in a separate
Hugo repo (`pabloagn/rhodium.rh`); when a change alters documented behaviour
(scripts, keybindings, tools, architecture), that repo should be updated too.

## Repository map

| Path | Purpose |
| --- | --- |
| `flake.nix` | inputs, `mkHost`, `nixosConfigurations`, `homeConfigurations`, devshell |
| `hosts/<host>/` | per-host NixOS config + `hardware-configuration.nix` (machine-bound) |
| `users/user_001/` | the single Home Manager user module, shared by every host |
| `modules/` | system-level NixOS modules by category |
| `home/` | Home Manager modules by category |
| `data/` | declarative data: hosts, users, preferences, extras |
| `lib/` | `rhodiumLib` helpers |
| `overlays/` | package overlays |
| `build/recipes/` | `rh-*` shell scripts used by `just` |
| `devshells/` | dev shell for tooling |

## Hosts and users

Defined in `data/hosts/hosts.nix` and `data/users/users.nix`. A host picks its
user with the `user` field and `mkHost` resolves it.

| Host | Hostname | User key | Username | GPU |
| --- | --- | --- | --- | --- |
| `amd` | `amd` | `user_amd` | `bausserr` | amd |
| `intel` | `intel` | `user_intel` | `manssell` | intel |
| `generic` | `nixos` | `user_generic` | `rhodium` | generic |

Each host entry also carries `timeZone`, `locale`, `stateVersion`, `battery`,
`hasNvme`, `mainMonitor` and `extraMonitors`; niri and waybar read the monitors
from there.

## Key design patterns

- **Data/logic separation**: `data/` is imported by `flake.nix` and injected via
  `specialArgs` (system modules) and `extraSpecialArgs` (home modules).
- **Nixpkgs channels**: `nixpkgs` = `nixos-25.11` (primary), `nixpkgs-unstable`,
  and `nixpkgs-shell` = `nixos-25.11` for dev shells.
- **Themes**: palettes live in `home/assets/themes/` (`chiaroscuro.nix`,
  `kvantum-chiaroscuro.nix`). The selection comes from
  `data/users/preferences/theme.nix` (`theme.name = "chiaroscuro"`,
  `variant = "dark"`). `flake.nix` additionally passes
  `chiaroscuroTheme = inputs.chiaroscuro.themes.kanso-zen` and `targetTheme`
  (both marked TODO/temporary).
- **External flake inputs**: `chiaroscuro`, `rhodium-alloys` (fish/yazi plugins),
  `niri-flake`, `kanso-nvim` (`flake = false`), `zen-browser`, `sops-nix`,
  `nur`, `flake-parts`.
- **Special args (home)**: `pkgs-unstable`, `inputs`, `rhodiumLib`, `userData`,
  `user`, `host`, `theme`, `targetTheme`, `chiaroscuroTheme`,
  `userPreferences`, `userExtras`, `fishPlugins`, `yaziPlugins`, `mkModule`,
  `mkPkgModule`.
- **Special args (system)**: `pkgs-unstable`, `inputs`, `rhodiumLib`, `users`,
  `host`.

## Commands

Everything goes through `just` (see `justfile`). The host argument is `amd`,
`intel` or `generic`.

```bash
just switch intel        # build + activate
just switch-fast intel   # same, minimal output
just build intel         # build without activating
just boot intel          # build and set as next boot
just build-dry intel     # dry-run
just build-dev intel     # verbose build
just check               # nix flake check --all-systems
just fmt                 # nixfmt-rfc-style over all .nix
just update              # update all inputs
just update-input nixpkgs
just gc-keep 5
just rollback
just health
```

`just switch` runs through `sudo`, so an agent must not run it without explicit
authorization from the user.

## Workflows

### Add a host

1. Create `hosts/<key>/` with `default.nix` (import the matching GPU module) and
   a generated `hardware-configuration.nix`.
2. Add the entry to `data/hosts/hosts.nix` (key = directory name =
   nixosConfiguration).
3. Add `<key> = mkHost "<key>";` in `flake.nix`.
4. `just build-dry <key>`, then `just switch <key>`.

### Add a user

1. Add the entry to `data/users/users.nix`.
2. Add preferences under `data/users/preferences/` and extras under
   `data/users/extras/` when needed.
3. Point the host at it with `user = "user_<key>";` in `data/hosts/hosts.nix`.

### Modify modules

- System: `modules/<category>/`, imported by hosts.
- Home: `home/<category>/`, imported by `users/user_001`.
- Always verify evaluation before proposing a switch:
  `nix eval --raw .#nixosConfigurations.intel.config.system.build.toplevel.drvPath`
  or `just check`.

### Themes

`data/users/preferences/theme.nix` selects the theme; palettes live in
`home/assets/themes/`. Modules receive colours through the `theme` argument, so
a palette change belongs in the theme file, not as hardcoded hex values inside
app modules.

## Debugging a failed switch

1. Read the full error:
   `journalctl -u home-manager-<username>.service -n 200`
   (for example `home-manager-manssell.service`).
2. Home Manager file conflicts are backed up automatically
   (`backupFileExtension = "backup"` in `flake.nix`).
3. Use `just build-dev <host>` for verbose output and `just check` for flake
   errors.
4. `git status` warnings about a dirty tree are expected and informational.

## Notes

- `hosts/<host>/hardware-configuration.nix` is machine-bound (UUIDs, kernel
  modules). Never rewrite or "fix" it unless the user explicitly asks.
- Home Manager is a NixOS module here; there is no separate
  `home-manager switch` workflow.
- Secrets use `sops-nix`; never commit secrets.
- `rhodiumLib` (from `lib/`) exposes `generators.moduleGenerators.mkModule` and
  `mkPkgModule`, `generators.desktopGenerators`,
  `generators.utilsMetadataGenerators`, `formatters.iconFormatter` and
  `parsers.luaParsers`.
- Keep changes consistent with the surrounding style and module layout; prefer
  editing existing modules over adding new top-level ones.
- Do not commit or push without the user's explicit permission.
