> *remember when github was github? now it's copilot with a repo tab. damn microsoft.*

<p align="center">
  <img src="assets/rhodium-logo.png" alt="rhodium" width="560"/>
</p>

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
| Editors | neovim, helix, zed, vscode, micro, emacs |
| Files | yazi (TUI) + thunar (GUI) |
| Lock screen | hyprlock |
| Display manager | greetd — login prompt (tuigreet), autologin opt-in |
| Theme | chiaroscuro (Kanso) — GTK and Qt |
| Fonts | JetBrainsMono Nerd Font (free replacement for the paid original) |
| AI agents | opencode, codex, gemini-cli, claude-code, aider |

Press **Super + F1** at any time for the searchable keybind menu; `Super + Shift + F1`
opens the full plain-text cheatsheet. Switch the keyboard layout by clicking the
**ES/US** indicator in the waybar (Spanish first).

## Installation

👉 **[INSTALL.md](./INSTALL.md)** — graphical ISO (recommended) or a manual install.

## Hosts & users

Defined in `data/hosts/hosts.nix` and `data/users/users.nix`:

| nixosConfiguration | Hostname | User | GPU | Create this user in the installer |
| --- | --- | --- | --- | --- |
| `generic` | `nixos` | `rhodium` | Intel / AMD free drivers | ✅ |
| `amd` | `amd` | `bausserr` | AMD (iGPU / dGPU) | ✅ |
| `intel` | `intel` | `manssell` | Intel iGPU | ✅ |

> **Use exactly these during the NixOS installation** (the username most of all). If you
> create that user in the installer, the repo needs **zero edits** to work.
>
> Want a single machine instead of several? Point any host at the same `user` in
> `data/hosts/hosts.nix`, or add your own entry + directory under `hosts/`.

## Repository layout

```
rhodium/
├── flake.nix                      # inputs + nixosConfigurations (generic, amd, intel)
├── INSTALL.md                     # install guide (graphical ISO + manual)
├── data/                          # ← all your personal data lives here
│   ├── hosts/hosts.nix            #   hostnames, users, monitors, timezone
│   └── users/users.nix            #   usernames, names, emails, groups
├── hosts/<host>/                  # per-machine NixOS config (generic/, amd/, intel/)
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

## Home layout

Home Manager creates the content directories the rice uses; you do not have to
make them by hand.

```
~/
├── documents/
│   ├── aprendizaje/      # Obsidian vault
│   └── opencode/         # OpenCode chats by topic
├── downloads/
└── pictures/
    ├── screenshots/      # niri screenshot path
    └── ocr/              # OCR text output
```

Lowercase is intentional: niri and the screenshot/OCR scripts already use those
paths. `~/documents`, `~/downloads` and `~/pictures` are registered as XDG user
dirs in `home/modules/env.nix`, so file pickers and apps resolve to the same
places. Everything else follows the XDG base dirs: `~/.config`, `~/.local/share`,
`~/.local/state`, `~/.cache`.

## Daily use

```sh
cd ~/rhodium
git pull
sudo nixos-rebuild switch --flake .#generic    # or .#intel / .#amd
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

`<host>` is `generic`, `amd` or `intel`.

## Customizing

- **Colors / theme** — `home/assets/themes/` + `data/users/preferences/theme.nix`.
  niri, waybar, kitty, fuzzel, yazi… all follow it, and so do the GTK/Qt apps
  (`home/desktop/portals/default.nix`) and the Firefox-family browsers
  (`home/apps/browsers/browser-theme.nix`). Obsidian gets a matching
  `chiaroscuro` CSS snippet installed into every vault listed in
  `~/.config/obsidian/obsidian.json` (`home/apps/docs/obsidian-theme.nix`).
- **Fonts** — `overlays/fonts.nix` (the free replacement) and `home/modules/fonts.nix`.
- **Keybinds** — `home/desktop/wm/niri/default.nix`; keep
  `home/desktop/wm/niri/shortcuts.txt` in sync when you change them.
- **Keyboard layout / timezone** — `modules/hardware/keyboard.nix` +
  `data/hosts/hosts.nix` (`timeZone`, `locale`).
- **Users & hosts** — `data/users/users.nix`, `data/hosts/hosts.nix`.
- **Programs** — `home/apps/…` (user) and `modules/apps` (system).

## Keybinds

- **Super + F1** — searchable keybind menu (`fuzzel-help.sh`), generated from the
  `hotkey-overlay.title` of every bind, so it is always in sync with the config.
  Works with any layout.
- **Super + Shift + F1** — the full plain-text cheatsheet, which also
  lists the rice's other menus and helper scripts.
- **Super + Space** — lock screen (`hyprlock`).
- **Super + Shift + Space** — power menu (`fuzzel-power.sh`): power off, reboot,
  reboot to UEFI, suspend, hibernate, log out, lock screen, airplane mode.
- **Super + A** — plain application launcher (`fuzzel`): installed applications
  from your `.desktop` files.
- **Super + M** — the rice's richer app menu (`fuzzel-apps.sh`): applications
  *plus* bookmarks and browser profiles, grouped by category. The screenshot
  annotate that used to live on `Super + A` is on `Super + Alt + A`, and
  `Alt + Print` still works too.
- **Super + Shift + I** — symbols / unicode icons picker (`fuzzel-icons.sh`).
- **Super + Alt + E** — emoji picker (`fuzzel-emoji.sh`, copies to clipboard).

The rest of the menus ship as scripts in `~/.local/bin/fuzzel/` and are not
keybound: wifi, networking, display, colors, services, USB, mounts, vaults,
temperature, journals, kill, yank, go, osmium, remote, xecute, zutils, find,
launch, query. A few are on the bar: click the logo for the app menu, click
Bluetooth for its menu, and right-click the battery for the power menu.

The plain-text cheatsheet is `home/desktop/wm/niri/shortcuts.txt`, deployed to
`~/.config/niri/shortcuts.txt` and opened in a floating terminal.

`fuzzel-help.sh` (see `~/.local/bin/fuzzel/`) builds the `Super + F1` menu from
the `hotkey-overlay.title` of every bind in `home/desktop/wm/niri/default.nix`,
so those titles are the source of truth for both cheatsheets — keep
`shortcuts.txt` in sync when you change them.

**What each menu lists.** `Super + A` is plain `fuzzel`, which scans every
installed `.desktop` file. `Super + M` opens `fuzzel-apps.sh`, which reads the
rice's curated entries from `data/users/extras/apps.nix` (applications) plus
bookmarks and browser profiles, grouped by category; entries whose binary is not
installed are hidden. Each row shows the name, the entry type (`App`,
`Bookmark`, `Profile`) and a short group (`Media`, `Productivity`, `Reference`,
...). Bookmarks and browser profiles are not applications, but the menu lists
them as their own categories too. The *generic* `.desktop`
launcher (`raffi`, no keybind) lists applications only: bookmark/profile entries
and launcher entries that merely duplicate a package's own entry are marked
`noDisplay = true;` in `data/users/extras/apps.nix`, so an app is never listed
twice and icons resolve. Add your own launchers (wrappers, TUIs) the same way.

## OpenCode integration (in development)

[opencode](https://opencode.ai) is installed through Home Manager
(`home/development/agents/`) and preconfigured at `~/.config/opencode/config.json`
with the **free** model:

```json
{ "model": "opencode/deepseek-v4.1-flash-free", "autoupdate": false }
```

Run it with `opencode`, or pick another model with `opencode --model <provider/model>`.
`autoupdate` is off because Nix owns the binary. To add other providers:

```sh
opencode auth login
```

opencode is a Bun-compiled binary, and nixpkgs builds it for CPUs **with AVX2**.
On older machines — a ThinkPad T420, for example, whose Sandy Bridge CPU has AVX
but no AVX2 — that build dies immediately with
`Illegal instruction (core dumped)`. `overlays/opencode.nix` therefore installs
upstream's own **baseline** build of opencode instead of compiling it, which runs
on those CPUs and on modern ones alike. To bump it, edit the version and the hash
in that file.

Keep that pin reasonably fresh: each release bakes in the catalogue of models it
knows about, so an old binary will not offer newer free models. The 1.18.x builds
have no `deepseek-v4.1-flash-free`; 1.19.x does.

> **Status: in use.** Validated on a T420 (old CPU, no AVX2) and on modern
> machines; the model config above is what both the devshell and
> `~/.config/opencode/config.json` use.

## Secrets

Nothing sensitive is stored in this repository.

- **SSH** — paste your **public** key into `home/security/network/ssh.nix` →
  `rhSsh.authorizedKeys`. It is opt-in: no keys are installed by default.
- **User password** — set with `passwd` (or during installation), never committed.
- **opencode credentials** — live in your home directory (`opencode auth login`).

## Troubleshooting

- **Nothing boots after installing** — you didn't copy the machine's
  `hardware-configuration.nix` into `hosts/<host>/`. See [INSTALL.md](./INSTALL.md).
- **Black screen after login** — press `Ctrl + Alt + F3` for a TTY, log in, fix and
  rebuild.
- **`direnv: .envrc is blocked` when you `cd` into the repo** — the repo ships an
  `.envrc` (just `use flake`) and the fork whitelists `~/rhodium`, so this only
  appears when your clone lives somewhere else: run `direnv allow` once inside it.
- **Home-Manager fails on an existing file** (e.g. Firefox `profiles.ini`) — the flake sets
  `backupFileExtension = "backup"`, so the old file is renamed to `*.backup`.
- **A package doesn't exist** — names change between nixpkgs branches. Search with
  `nix search nixpkgs <name>`.
- **Wrong keyboard layout / console keymap** — edit `modules/hardware/keyboard.nix`.
- **Wrong clock** — set `timeZone` in `data/hosts/hosts.nix` (defaults to
  `America/Bogota`).

## Fork changes vs. upstream

- **Removed the private `iridium-rh` flake input.** Upstream pulled Berkeley Mono (paid) and
  Server Mono from a private repo over SSH, which made the flake unbuildable for anyone
  else. Replaced with the free (SIL OFL) **JetBrains Mono Nerd Font**.
- **Removed the hardcoded personal SSH key** and the private `identityFile` — now an opt-in
  module option (`rhSsh.authorizedKeys`).
- **All personal data moved into `data/`** (usernames, emails, hostnames, monitors).
- **Three portable hosts** (`generic`, `amd`, `intel`) with template
  `hardware-configuration.nix`. Use `generic` on any other laptop or desktop.
- **Real Intel iGPU module.** Upstream's `niri/intel.nix` was actually an **NVIDIA** module;
  renamed to `nvidia.nix`, and a genuine Intel iGPU module was added.
- **Login prompt by default** (greetd + tuigreet), with autologin as an opt-in:
  set `rhodium.autologin = true`.
- **Keyboard layouts: Spanish (ES) + English (US)**, Spanish first, toggled by
  clicking the **ES/US** indicator in the waybar; the default timezone is `America/Bogota`.
- **Hardware/server-specific services off by default** (ASUS backlight, Keychron/kmonad,
  Plex, Roon, Atuin sync…) so a fresh install boots anywhere.
- **Steam is opt-in** (`rhodium.gaming.steam.enable = true;`) so old GPUs and
  non-gaming machines do not pull the 32-bit graphics stack and a large closure.
- **No one else's bookmarks or browser profiles.** Upstream shipped 117 personal
  bookmarks and 14 Firefox profiles, which appeared as launcher entries on any
  install. Replaced with a small, neutral starter set (`data/users/extras/bookmarks.nix`,
  `profiles.nix`, `data/users/preferences/apps.nix`).
- **A clean generic launcher.** `raffi` lists applications only: bookmark/profile
  entries and launcher entries that merely duplicate a package's own `.desktop`
  file are `NoDisplay`, so nothing shows up twice and icons resolve
  (`home/modules/desktop.nix`, `lib/generators/desktopGenerators.nix`). The
  `Super + M` menu (`fuzzel-apps.sh`) adds bookmarks and browser profiles on top,
  grouped by category.
- **No hardcoded browser profile required.** An empty profile name means "the
  browser's default profile", so links, bookmarks and launcher entries work on a
  fresh install instead of opening a profile that does not exist yet. The same
  applies to the helpers that used to hardcode personal profiles (`Super + B`,
  `fuzzel-go.sh`, `fuzzel-osmium.sh`, the internal-services data file).
- **Comments and docs in English.**

Nothing here is destructive to upstream: the whole rice and module layout are preserved.

## TODO

Roadmap:

- [x] Remove the private `iridium-rh` flake input
- [x] Replace the paid font (Berkeley Mono) with a free Nerd Font
- [x] Remove hardcoded personal SSH key and private key path
- [x] Move all personal data into `data/` (users + hosts)
- [x] Three portable hosts (`generic`, `amd`, `intel`) with template hardware configs
- [x] Add a real Intel iGPU niri module (rename the old one to `nvidia.nix`)
- [x] Login prompt by default (greetd + tuigreet), autologin opt-in
- [x] Spanish + English keyboard layouts (ES first) with `America/Bogota` as default
      timezone
- [x] Keybind cheatsheet (`Super + F1`)
- [x] App menu keybind (`Super + M` → `fuzzel-apps.sh`, `Super + A` → plain `fuzzel`)
- [x] `INSTALL.md` for both install routes
- [x] Add `opencode` with the free `deepseek-v4.1-flash-free` model
- [x] Disable hardware/server-specific services by default
- [x] Translate comments and docs to English

  > Nota personal: casi no hablo inglés; sé lo básico (suficiente para
  > programar, jajaja) y escribir con fluidez todavía me cuesta, pero lo iré
  > mejorando poco a poco.

Next:

- [ ] Set your own `timeZone` / `locale` in `data/hosts/hosts.nix` (defaults:
      `America/Bogota` / `en_US.UTF-8`)
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
