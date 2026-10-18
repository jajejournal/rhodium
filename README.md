<p align="center">
  <img src="https://dvb0bsaug07xf.cloudfront.net/assets/site/logo.png" width="500px">
</p>

# rhodium (fork)

> A personal, **portable** fork of [pabloagn/rhodium](https://github.com/pabloagn/rhodium) —
> a hypermodular **NixOS "rice"** built around the [niri](https://github.com/YaLTeR/niri)
> Wayland compositor.

This is my daily-driver NixOS configuration. It keeps the upstream rice (niri, waybar/astal,
fuzzel, fish, kitty/ghostty, neovim, zed, …) but removes everything that was tied to the
original author's private accounts, hardware and paid software, so it can be installed on
**any machine** from a plain NixOS ISO.

<p align="center">
  <img src="https://dvb0bsaug07xf.cloudfront.net/assets/screens/screen_001.jpg" width="49%"/>
  <img src="https://dvb0bsaug07xf.cloudfront.net/assets/screens/screen_002.jpg" width="49%"/>
</p>

---

## What is a "rice"?

A "rice" is a heavily customized desktop: window manager / compositor, bar, launcher,
terminal, fonts, colors, keybinds and shell, all tuned for a specific look and workflow.
Here, everything is declared in Nix, so the whole desktop is **reproducible**: the same
repo produces the same system on any supported machine.

| Layer | Choice |
| --- | --- |
| Compositor | **niri** (scrollable tiling, Wayland) |
| Bar / widgets | waybar + astal (ags) |
| Launcher | fuzzel |
| Shell | fish (+ zsh, nushell, bash) |
| Terminals | kitty, ghostty, foot, alacritty |
| Editors | neovim, helix, zed, vscode, micro |
| Prompt | starship |
| Colors | chiaroscuro (Kanso) theme |
| Fonts | Nerd Fonts (mono: `JetBrainsMono Nerd Font`) |

---

## Fork changes vs. upstream

Upstream is great but is written for the author's own machines. This fork makes it
self-contained and portable:

- **Removed the private `iridium-rh` flake input.** Upstream pulled Berkeley Mono (paid)
  and Server Mono from a private repo over SSH, which made the flake unbuildable for anyone
  else. Replaced with the free (SIL OFL) **JetBrains Mono Nerd Font**.
- **Removed hardcoded personal SSH key** (`~/.ssh/authorized_keys`) and the private
  `identityFile`. It's now an opt-in module option (`rhSsh.authorizedKeys`).
- **Everything personal moved to `data/`**: username, full name, email, hostnames and
  monitors live in `data/users/users.nix` and `data/hosts/hosts.nix`.
- **Two portable hosts**: `amd` and `intel`. The `hardware-configuration.nix` files are
  **templates** that you regenerate on the target machine.
- **Real Intel iGPU module.** Upstream's `niri/intel.nix` was actually an **NVIDIA** module;
  renamed to `nvidia.nix`, and a genuine Intel iGPU module was added.
- **Autologin enabled** (greetd) — boots straight into the desktop.
- **Keyboard layouts: English (US) + Spanish (ES)**, toggle with `Super + Space`.
- **opencode** added to the AI agents, preconfigured with the free model
  `opencode/deepseek-v4.1-flash-free`.
- **Hardware-specific services off by default** (ASUS backlight, Keychron/kmonad, Plex, Roon,
  Atuin sync…) so a fresh install boots anywhere; enable the ones you own.
- **Comments and docs in English.**

Nothing here is destructive to upstream: the whole rice and module layout is preserved.

---

## Hosts & users

Defined in `data/hosts/hosts.nix` and `data/users/users.nix`:

| nixosConfiguration | Hostname | User | GPU | Create this user in the installer |
| --- | --- | --- | --- | --- |
| `amd` | `amd` | `bausserr` | AMD (iGPU/dGPU) | ✅ |
| `intel` | `intel` | `manssell` | Intel iGPU | ✅ |

> **Use exactly these during the NixOS installation** (the username most of all). If you
> create that user in the installer, the repo needs **zero edits** to work.
> Full walkthrough: **[INSTALL.md](./INSTALL.md)**.
>
> Want a single machine instead of two? Point any host at the same `user` in
> `data/hosts/hosts.nix`, or add your own entry + directory under `hosts/`.

---

## Installation

> 👉 **Full step-by-step guide: [INSTALL.md](./INSTALL.md)** — it covers the
> **graphical ISO** route (recommended, much shorter) and the manual route below.

> ⚠️ The `hardware-configuration.nix` files in this repo are **templates**. If you don't
> replace them with one generated on the machine you're installing to, the system won't
> boot.

1. Boot the NixOS ISO, then partition and mount your disks (UEFI + ext4 example):

   ```bash
   sudo parted /dev/nvme0n1 -- mklabel gpt
   sudo parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
   sudo parted /dev/nvme0n1 -- set 1 esp on
   sudo parted /dev/nvme0n1 -- mkpart primary ext4 512MiB 100%
   sudo mkfs.fat -F32 -n BOOT /dev/nvme0n1p1
   sudo mkfs.ext4 -L nixos /dev/nvme0n1p2
   sudo mount /dev/disk/by-label/nixos /mnt
   sudo mount --mkdir /dev/disk/by-label/BOOT /mnt/boot
   ```

2. Generate the hardware config and clone this repo:

   ```bash
   sudo nixos-generate-config --root /mnt
   nix-shell -p git --run "git clone https://github.com/jajejournal/rhodium /tmp/rhodium"
   ```

3. Copy the generated hardware config into the matching host:

   ```bash
   # For an Intel machine:
   sudo cp /mnt/etc/nixos/hardware-configuration.nix /tmp/rhodium/hosts/intel/hardware-configuration.nix
   # For an AMD machine:
   # sudo cp /mnt/etc/nixos/hardware-configuration.nix /tmp/rhodium/hosts/amd/hardware-configuration.nix
   ```

4. Install (pick `intel` or `amd`):

   ```bash
   sudo nixos-install --flake /tmp/rhodium#intel --root /mnt
   ```

5. Reboot. From then on, manage the system from the repo:

   ```bash
   cd ~/rhodium
   sudo nixos-rebuild switch --flake .#intel   # or .#amd
   ```

---

## Keyboard layouts

English (US) and Spanish (ES) are both enabled, switching with **Super + Space**
(`grp:win_space_toggle`). Configured in:

- `modules/hardware/keyboard.nix` (system/X11 + timezone/locale)
- `home/desktop/wm/niri/config.kdl` and `home/desktop/wm/niri/default.nix` (niri)
- `home/desktop/wm/hyprland/base.nix` (hyprland)

Timezone and locale are per-host (`data/hosts/hosts.nix` → `timeZone`, `locale`).

---

## Keybind cheatsheet

Every keybind is listed in `home/desktop/wm/niri/shortcuts.txt`, which is deployed to
`~/.config/niri/shortcuts.txt`. Open it at any time with:

```
Mod + ç    (the key that types "ç" — AltGr + , on the Spanish layout)
```

It opens in a floating terminal (`kitty --class rh-shortcuts -e less`).

---

## opencode

[opencode](https://opencode.ai) is installed via Home Manager
(`home/development/agents/`) and preconfigured at `~/.config/opencode/opencode.json`
with the free model:

```json
{ "model": "opencode/deepseek-v4.1-flash-free", "autoupdate": false }
```

Run it with `opencode`, or pick another model with `opencode --model <provider/model>`.
`autoupdate` is off because Nix owns the binary. To add other providers:

```bash
opencode auth login
```

---

## Repository layout

```
├── flake.nix            # inputs + nixosConfigurations (amd, intel)
├── data/                # ← your personal data lives here
│   ├── hosts/hosts.nix   #   hostnames, users, monitors, timezone
│   └── users/users.nix   #   usernames, names, emails, groups
├── hosts/               # per-host NixOS system config (amd/, intel/)
├── users/               # shared Home Manager user config (user_001/)
├── modules/             # system-level NixOS modules
├── home/                # Home Manager modules (desktop, apps, shells, …)
├── overlays/            # package overlays (incl. the free font)
└── justfile             # helper recipes (`just switch <host>`, …)
```

---

## TODO / roadmap

### Done in this fork

- [x] Remove the private `iridium-rh` flake input
- [x] Replace the paid font (Berkeley Mono) with a free Nerd Font
- [x] Remove hardcoded personal SSH key and private key path
- [x] Move all personal data into `data/` (users + hosts)
- [x] Two portable hosts (`amd`, `intel`) with template hardware configs
- [x] Add a real Intel iGPU niri module (rename the old one to `nvidia.nix`)
- [x] Enable autologin (greetd)
- [x] English + Spanish keyboard layouts
- [x] Keybind cheatsheet (all shortcuts in one file, opened with `Mod + ç`)
- [x] `INSTALL.md` covering both ISO routes, with the recommended user/hostname per machine
- [x] Add `opencode` with the free `deepseek-v4.1-flash-free` model
- [x] Disable hardware/server-specific services by default
- [x] Disable Atuin history sync by default (was pointing to the author's server)
- [x] Translate comments and docs to English

### Pending / do on first install

- [ ] Regenerate `hardware-configuration.nix` on each target machine
- [ ] Set the real `timeZone` / `locale` in `data/hosts/hosts.nix` (currently `Europe/Madrid`)
- [ ] Set the real `fullName` / `emailMain` in `data/users/users.nix` (currently GitHub noreply)
- [ ] Run `nix flake check` and the first `nixos-rebuild switch`
- [ ] (Optional) Add your own public SSH key via `rhSsh.authorizedKeys`
- [ ] (Optional) `opencode auth login` for other providers
- [ ] (Optional) Enable Keychron udev rules / `rh-kmonad` if you own one
- [ ] (Optional) Enable ASUS-specific services on ASUS hardware
- [ ] (Optional) Clean up the author's leftover bookmarks in `data/users/extras/bookmarks.nix`

### Ideas

- [ ] Screenshots of this fork's setup in the README
- [ ] Single generic host profile for "any laptop"
- [ ] Automated `nix flake check` in CI (GitHub Actions)

---

## Credits & license

Upstream rice: **[pabloagn/rhodium](https://github.com/pabloagn/rhodium)** by Pablo Aguirre
(MIT). All original design and the vast majority of this configuration are his work — this
fork only makes it portable and personal. See [LICENSE](./LICENSE).
