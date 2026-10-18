# rhodium

My NixOS setup: **flakes + home-manager + niri** (scrollable tiling on Wayland), heavily
customised and made **portable** so it installs on any machine from a plain NixOS ISO.

This is a personal, cleaned-up fork of
**[pabloagn/rhodium](https://github.com/pabloagn/rhodium)**. The whole rice and the module
layout are kept; everything tied to the original author's private accounts, hardware and
paid software is removed.

## Screenshots

<p align="center">
  <img src="https://dvb0bsaug07xf.cloudfront.net/assets/screens/screen_001.jpg" width="49%"/>
  <img src="https://dvb0bsaug07xf.cloudfront.net/assets/screens/screen_002.jpg" width="49%"/>
</p>

## Overview

| Area | What I use |
| --- | --- |
| Compositor | **niri** (scrollable tiling, Wayland) |
| Bar / widgets | waybar + astal (ags) |
| Launcher | fuzzel |
| Notifications | mako |
| Shell / prompt | fish (+ zsh, nushell, bash), starship |
| Terminals | kitty, ghostty, foot, alacritty |
| Editors | neovim, helix, zed, vscode, micro, emacs (doom) |
| Files | yazi (TUI) + thunar (GUI) |
| Lock screen | hyprlock |
| Display manager | greetd — **autologin** straight into niri |
| Theme | chiaroscuro (Kanso) — GTK and Qt |
| Fonts | JetBrainsMono Nerd Font (free replacement for the paid original) |
| AI agents | opencode, codex, gemini-cli, claude-code, aider |

Press **Super + ç** at any time to open the shortcuts cheatsheet
(`~/.config/niri/shortcuts.txt`). Switch keyboard layout with **Super + Space**
(English ↔ Spanish).

## Installation

👉 **[INSTALL.md](./INSTALL.md)** — graphical ISO (recommended) or a manual install.

## Hosts & users

Defined in `data/hosts/hosts.nix` and `data/users/users.nix`:

| nixosConfiguration | Hostname | User | GPU | Create this user in the installer |
| --- | --- | --- | --- | --- |
| `amd` | `amd` | `bausserr` | AMD (iGPU / dGPU) | ✅ |
| `intel` | `intel` | `manssell` | Intel iGPU | ✅ |

> **Use exactly these during the NixOS installation** (the username most of all). If you
> create that user in the installer, the repo needs **zero edits** to work.
>
> Want a single machine instead of two? Point any host at the same `user` in
> `data/hosts/hosts.nix`, or add your own entry + directory under `hosts/`.

## Repository layout

```
rhodium/
├── flake.nix                      # inputs + nixosConfigurations (amd, intel)
├── INSTALL.md                     # install guide (graphical ISO + manual)
├── data/                          # ← all your personal data lives here
│   ├── hosts/hosts.nix            #   hostnames, users, monitors, timezone
│   └── users/users.nix            #   usernames, names, emails, groups
├── hosts/<host>/                  # per-machine NixOS config (amd/, intel/)
│   ├── default.nix
│   └── hardware-configuration.nix #   regenerate on the target machine
├── users/user_001/                # shared Home Manager config
├── modules/                       # system-level NixOS modules
├── home/                          # Home Manager modules
│   ├── desktop/wm/niri/           #   niri config + shortcuts.txt
│   └── development/agents/        #   AI agents (incl. opencode)
├── overlays/                      # package overlays (incl. the free font)
└── justfile                       # helper recipes
```

## Daily use

```sh
cd ~/rhodium
git pull
sudo nixos-rebuild switch --flake .#intel    # or .#amd
```

> Flakes only see files tracked by git, so `git add` new files before rebuilding.

`just` comes with the config and wraps the common commands (`just --list` shows all):

| Command | What it does |
| --- | --- |
| `just switch <host>` | Rebuild and switch now |
| `just switch-fast <host>` | Same, with minimal output |
| `just build <host>` | Build only (no switch) |
| `just boot <host>` | Build and apply on next boot |
| `just check` | `nix flake check --all-systems` |
| `just update` | Update all flake inputs |
| `just update-input <input>` | Update a single input |
| `just fmt` | Format every `.nix` file |
| `just gc` | Garbage-collect the Nix store |
| `just rollback` | Roll back to the previous generation |
| `just health` | System health check |
| `just docs` | Open the upstream docs in the browser |

`<host>` is `amd` or `intel`.

## Customizing

- **Colors / theme** — `home/assets/themes/` + `data/users/preferences/theme.nix`.
  niri, waybar, kitty, fuzzel, yazi… all follow it.
- **Fonts** — `overlays/fonts.nix` (the free replacement) and `home/modules/fonts.nix`.
- **Keybinds** — `home/desktop/wm/niri/default.nix`; keep
  `home/desktop/wm/niri/shortcuts.txt` in sync when you change them.
- **Keyboard layout / timezone** — `modules/hardware/keyboard.nix` +
  `data/hosts/hosts.nix` (`timeZone`, `locale`).
- **Users & hosts** — `data/users/users.nix`, `data/hosts/hosts.nix`.
- **Programs** — `home/apps/…` (user) and `modules/apps` (system).

## Keybinds

- **Super + ç** — open the shortcuts cheatsheet (all keybinds in one file).
- **Super + Space** — switch keyboard layout (English ↔ Spanish, `grp:win_space_toggle`).

The cheatsheet is `home/desktop/wm/niri/shortcuts.txt`, deployed to
`~/.config/niri/shortcuts.txt` and opened in a floating terminal.

## OpenCode integration (in development)

[opencode](https://opencode.ai) is installed through Home Manager
(`home/development/agents/`) and preconfigured at `~/.config/opencode/opencode.json`
with the **free** model:

```json
{ "model": "opencode/deepseek-v4.1-flash-free", "autoupdate": false }
```

Run it with `opencode`, or pick another model with `opencode --model <provider/model>`.
`autoupdate` is off because Nix owns the binary. To add other providers:

```sh
opencode auth login
```

> **Status: in development.** The package and config are wired up, but it has not been
> validated on a real NixOS machine yet.

## Secrets

Nothing sensitive is stored in this repository.

- **SSH** — paste your **public** key into `home/security/network/ssh.nix` →
  `rhSsh.authorizedKeys`. It is opt-in: no keys are installed by default.
- **User password** — set with `passwd` (or during installation), never committed.
- **opencode credentials** — live in your home directory (`opencode auth login`).

## Troubleshooting

- **Nothing boots after installing** — you didn't copy the machine's
  `hardware-configuration.nix` into `hosts/<host>/`. See [INSTALL.md](./INSTALL.md).
- **Black screen after autologin** — press `Ctrl + Alt + F3` for a TTY, log in, fix and
  rebuild.
- **Home-Manager fails on an existing file** (e.g. Firefox `profiles.ini`) — the flake sets
  `backupFileExtension = "backup"`, so the old file is renamed to `*.backup`.
- **A package doesn't exist** — names change between nixpkgs branches. Search with
  `nix search nixpkgs <name>`.
- **Wrong keyboard layout / console keymap** — edit `modules/hardware/keyboard.nix`.
- **Wrong clock** — set `timeZone` in `data/hosts/hosts.nix` (defaults to `Europe/Madrid`).

## Fork changes vs. upstream

- **Removed the private `iridium-rh` flake input.** Upstream pulled Berkeley Mono (paid) and
  Server Mono from a private repo over SSH, which made the flake unbuildable for anyone
  else. Replaced with the free (SIL OFL) **JetBrains Mono Nerd Font**.
- **Removed the hardcoded personal SSH key** and the private `identityFile` — now an opt-in
  module option (`rhSsh.authorizedKeys`).
- **All personal data moved into `data/`** (usernames, emails, hostnames, monitors).
- **Two portable hosts** (`amd`, `intel`) with template `hardware-configuration.nix`.
- **Real Intel iGPU module.** Upstream's `niri/intel.nix` was actually an **NVIDIA** module;
  renamed to `nvidia.nix`, and a genuine Intel iGPU module was added.
- **Autologin enabled** via greetd.
- **Keyboard layouts: English (US) + Spanish (ES)**.
- **Hardware/server-specific services off by default** (ASUS backlight, Keychron/kmonad,
  Plex, Roon, Atuin sync…) so a fresh install boots anywhere.
- **Comments and docs in English.**

Nothing here is destructive to upstream: the whole rice and module layout are preserved.

## TODO

Roadmap:

- [x] Remove the private `iridium-rh` flake input
- [x] Replace the paid font (Berkeley Mono) with a free Nerd Font
- [x] Remove hardcoded personal SSH key and private key path
- [x] Move all personal data into `data/` (users + hosts)
- [x] Two portable hosts (`amd`, `intel`) with template hardware configs
- [x] Add a real Intel iGPU niri module (rename the old one to `nvidia.nix`)
- [x] Enable autologin (greetd)
- [x] English + Spanish keyboard layouts
- [x] Keybind cheatsheet (`Super + ç`)
- [x] `INSTALL.md` for both install routes
- [x] Add `opencode` with the free `deepseek-v4.1-flash-free` model
- [x] Disable hardware/server-specific services by default
- [x] Translate comments and docs to English

Next:

- [ ] Set the real `timeZone` / `locale` in `data/hosts/hosts.nix` (currently `Europe/Madrid`)
- [ ] Set the real `fullName` / `emailMain` in `data/users/users.nix` (currently GitHub noreply)
- [ ] Validated build: `nix flake check` + first `nixos-rebuild switch`
- [ ] Screenshots of this fork's own setup (the ones above are upstream's)
- [ ] "Lite" profile for low-RAM machines
- [ ] `nix flake check` in CI (GitHub Actions)
- [ ] (Optional) own public SSH key, `opencode auth login`, Keychron/kmonad, ASUS services

## Credits & license

Upstream rice: **[pabloagn/rhodium](https://github.com/pabloagn/rhodium)** by Pablo Aguirre
(MIT). All original design and the vast majority of this configuration are his work — this
fork only makes it portable and personal. See [LICENSE](./LICENSE).
