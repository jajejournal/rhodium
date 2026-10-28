# Installation guide

Two ways to install this configuration:

- **[A. Graphical ISO](#a-graphical-iso--no-desktop-recommended)** — easiest, recommended.
- **[B. Manual install](#b-manual-install-minimal-iso)** — from the minimal ISO, if you
  prefer to partition by hand.

Before you start, read the table below — it decides the **username** you must create
during the installation.

---

## Which host am I?

There are three hosts. Pick yours *before* installing. `amd` and `intel` are the
maintainer's machines; `generic` is the one to use on any other laptop or desktop.

| Your machine                | nixosConfiguration | Hostname | Username   |
| --------------------------- | ------------------ | -------- | ---------- |
| Generic / any other PC      | `generic`          | `nixos`  | `rhodium`  |
| AMD (Radeon iGPU / dGPU)    | `amd`              | `amd`    | `bausserr` |
| Intel (integrated GPU)      | `intel`            | `intel`  | `manssell` |

> **Why does this matter?** The username decides the Home Manager user, `/home/<user>`
> and which session Home Manager configures. If you create **exactly** this user during the installation,
> you don't have to edit a single file afterwards — the flake already knows about it.
>
> The **hostname** is enforced by the flake (`data/hosts/hosts.nix`), so whatever the
> installer sets will be overwritten. Type `nixos` / `amd` / `intel` if it asks, but it
> is not critical.
>
> Steam is off by default. On a machine that can run it, add
> `rhodium.gaming.steam.enable = true;` to the matching `hosts/<host>/default.nix`.

These values are defined in:

- `data/hosts/hosts.nix` → `hostname`, `user`, `timeZone`, `locale`, monitors
- `data/users/users.nix` → `username`, `fullName`, `emailMain`, groups

Need a **different** username/hostname? Just edit those two files (and the directory
`hosts/<name>/`) — nothing else is hardcoded.

---

## A. Graphical ISO + "No desktop" (recommended)

The graphical installer already partitions the disk and generates both
`/etc/nixos/configuration.nix` **and** `/etc/nixos/hardware-configuration.nix`, so you
skip all the manual partitioning.

### 1. Install

Boot the graphical ISO and go through the installer:

| Installer option | What to pick |
| --- | --- |
| Desktop | **No desktop** |
| Username | `rhodium` (generic), `bausserr` (AMD) or `manssell` (Intel) |
| Password | your choice — **remember it, you need it for `sudo`** |
| Hostname | `nixos` / `amd` / `intel` (optional, see note above) |
| Partitioning | automatic / "Erase disk" is fine |
| Boot mode | **UEFI** — this config uses `systemd-boot` |

> ⚠️ The config uses `systemd-boot` (`modules/boot/boot.nix`). If you install in
> legacy/BIOS mode it will not boot. On a BIOS-only machine, switch to GRUB instead.

After installing you get a **black screen with a text login prompt** (no desktop yet).
That's expected.

### 2. First boot: enable flakes, get `git` and `just`

Log in with the user you created.

```bash
sudo nano /etc/nixos/configuration.nix
```

Add these (if `environment.systemPackages` already exists, just add `git` and `just` to
its list instead of duplicating the line):

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
environment.systemPackages = with pkgs; [ git just ];
```

> **Why `just` here?** Every build/install shortcut in this repo is a `just` recipe
> (`justfile`). You need it *before* the rice is installed, so it goes into this temporary
> config; the rice installs it again for your user later anyway.

Apply it (uses the channel the installer already downloaded):

```bash
sudo nixos-rebuild switch
```

Check that you have network:

```bash
ping -c1 github.com     # if this fails: nmtui, or plug in an ethernet cable
```

### 3. Clone the repo

```bash
git clone https://github.com/jajejournal/rhodium ~/rhodium
```

> `main` is the only branch: it already contains the portability work (generic host,
> free font, opencode, both keyboard layouts…).

### 4. Copy the generated hardware configuration

The installer already wrote one — you only have to move it into the matching host:

```bash
# Generic machine (any other PC):
cp /etc/nixos/hardware-configuration.nix ~/rhodium/hosts/generic/hardware-configuration.nix

# Intel machine:
# cp /etc/nixos/hardware-configuration.nix ~/rhodium/hosts/intel/hardware-configuration.nix

# AMD machine:
# cp /etc/nixos/hardware-configuration.nix ~/rhodium/hosts/amd/hardware-configuration.nix
```

Then tell git to leave your machine-specific file alone, so `git pull` does not
conflict with it:

```bash
git update-index --skip-worktree hosts/generic/hardware-configuration.nix
# use the matching path if you chose intel or amd
```

### 5. (Optional) Set your timezone

Only if you don't live in Bogotá (the default is `America/Bogota`):

```bash
nano ~/rhodium/data/hosts/hosts.nix     # edit `timeZone` (and `locale` if you want)
```

### 6. Install the rice

Pick the same host as your machine. Run it **from inside the repo** — `just` reads the
`justfile` from the current directory:

```bash
cd ~/rhodium

just switch-fast generic    # or: just switch-fast intel / amd
```

> **Why `switch-fast` on the first install?** You are still on a text console with no
> desktop running. `just switch` also runs post-build tasks that expect a live desktop
> session (reloading user services, refreshing icon/`mako` caches), which would print
> harmless errors here. `switch-fast` performs exactly the same system rebuild, nothing
> else. Once you are inside niri, use `just switch`.

It is the same as the raw command, if you ever need it:

```bash
sudo nixos-rebuild switch --flake ~/rhodium#generic    # or #intel / #amd
```

### 7. Reboot

```bash
sudo reboot
```

You get a login prompt (tuigreet): pick the user, type the password, and **niri** starts.
Autologin is opt-in: set `rhodium.autologin = true`.

Home Manager also creates the content layout on first switch: `~/documents`,
`~/downloads`, `~/pictures/screenshots`, `~/pictures/ocr`, the OpenCode chat
folders and `~/documents/aprendizaje` (Obsidian vault). No manual `mkdir` needed.

---

## B. Manual install (minimal ISO)

For when you want full control of partitioning. Adapted from the repo README.

1. Boot the minimal ISO and partition (UEFI + ext4 example):

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

2. Generate the hardware config and clone the repo:

   ```bash
   sudo nixos-generate-config --root /mnt
   nix-shell -p git --run "git clone https://github.com/jajejournal/rhodium /tmp/rhodium"
   ```

3. Copy the generated hardware config into the matching host:

   ```bash
   sudo cp /mnt/etc/nixos/hardware-configuration.nix /tmp/rhodium/hosts/generic/hardware-configuration.nix
   # or .../hosts/intel/hardware-configuration.nix / .../hosts/amd/hardware-configuration.nix
   ```

4. Install (choose `generic`, `intel` or `amd`):

   ```bash
   sudo nixos-install --flake /tmp/rhodium#generic --root /mnt
   ```

5. When asked, **set a password for `rhodium`** (generic), `bausserr` (AMD) or
   `manssell` (Intel) — the configuration does not ship a password:

   ```bash
   sudo nixos-enter --root /mnt -c 'passwd rhodium'
   ```

6. Reboot. The rice is already installed, but the repo only lived in `/tmp`, so clone it
   again into your home and re-copy the hardware config (a fresh clone carries the
   template, not your machine's):

   ```bash
   git clone https://github.com/jajejournal/rhodium ~/rhodium
   cp /etc/nixos/hardware-configuration.nix ~/rhodium/hosts/generic/hardware-configuration.nix
   cd ~/rhodium && just switch generic    # or: intel / amd
   git update-index --skip-worktree hosts/generic/hardware-configuration.nix
   ```

---

## Day-to-day

```bash
cd ~/rhodium     # `just` only works from the repo root
git pull
just switch generic    # or: intel / amd
```

`just switch <host>` is the same as `sudo nixos-rebuild switch --flake ~/rhodium#<host>`
plus the post-build refresh (icons, user services, notifications) — that is why you run
it from inside the repo: `FLAKE_PATH` defaults to the current directory.

> **New files must be tracked by git.** Nix flakes only see files that git knows about,
> so `git add` anything new before switching. `just switch` does **not** add it for you.

> **direnv:** the fork whitelists `~/rhodium`, so entering it loads the dev shell
> (`nix develop`) without asking. Clones in another path need a one-time `direnv allow`.

- **Show all keybinds:** `Mod + F1` (searchable menu). `Mod + Shift + F1` opens the
  full plain-text list (`~/.config/niri/shortcuts.txt`).
- **Switch keyboard layout:** click the **ES/US** indicator in the waybar (Spanish first).
- **If the desktop breaks:** `Ctrl + Alt + F3` gives you a TTY. Log in, fix, rebuild.

## Things that are still yours to decide

- [ ] `timeZone` / `locale` in `data/hosts/hosts.nix` (defaults to `America/Bogota` /
      `en_US.UTF-8`).
- [ ] `fullName` / `emailMain` in `data/users/users.nix` (defaults to GitHub noreply).
- [ ] Optional: your own SSH public key (`home/security/network/ssh.nix` →
      `rhSsh.authorizedKeys`).
- [ ] Optional: `opencode auth login` if you want providers other than the free model.
