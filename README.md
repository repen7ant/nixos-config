# nixos-config

Personal NixOS configuration: **niri** (scrollable-tiling Wayland compositor) +
a custom **quickshell** bar/shell, managed with flakes and home-manager.

- Username: `ilya`
- Hostname: `nixos`
- Flake outputs: `thinkpad`, `desktop`
- Bootloader: **GRUB (UEFI)**
- **Load-bearing repo path:** the repo MUST live at `/home/ilya/git/nixos-config`.
  Dotfiles are live-symlinked from there (`mkOutOfStoreSymlink`) and `nh` uses it.
  A different path breaks every symlink.

---

## Install on a fresh machine

Boot the **NixOS minimal ISO** (UEFI mode) and become root: `sudo -i`.

### 1. Partition the disk

Find your disk with `lsblk` (e.g. `/dev/sda`, or `/dev/nvme0n1` whose partitions
are `p1`, `p2`). Below assumes `/dev/sda` — adjust to yours.

Make a **GPT** table with three partitions in `cfdisk`:

```bash
cfdisk /dev/sda
```

In the TUI:

1. If asked for a label, choose **gpt**.
2. Partition 1 — size `1G`, set **Type → EFI System**.
3. Partition 2 — size `8G` (≥ RAM for hibernation), set **Type → Linux swap**.
4. Partition 3 — remaining space, type **Linux filesystem** (default).
5. **Write**, confirm `yes`, **Quit**.

> No swap needed? zram is enabled in the config. Skip partition 2 and its
> `mkswap`/`swapon` lines below, and use `/dev/sda2` for root instead of `sda3`.

Format + mount:

```bash
mkfs.fat -F32 -n boot /dev/sda1
mkswap -L swap /dev/sda2
mkfs.ext4 -L nixos /dev/sda3

mount /dev/sda3 /mnt
mount --mkdir /dev/sda1 /mnt/boot
swapon /dev/sda2
```

### 2. Get the config + hardware file

```bash
# generate hardware-configuration.nix for THIS machine
nixos-generate-config --root /mnt

# clone the repo to the load-bearing path inside the new system
nix-shell -p git --run \
  'git clone https://github.com/repen7ant/nixos-config /mnt/home/ilya/git/nixos-config'

# copy the freshly generated hardware file into the host dir
cp /mnt/etc/nixos/hardware-configuration.nix \
   /mnt/home/ilya/git/nixos-config/hosts/thinkpad/hardware-configuration.nix
```

### 3. Make the files visible to the flake

The flake only sees git-tracked files. Stage everything (do NOT need to commit):

```bash
cd /mnt/home/ilya/git/nixos-config
nix-shell -p git --run 'git add -A'
```

### 4. Install

```bash
nixos-install --root /mnt --flake /mnt/home/ilya/git/nixos-config#thinkpad \
  --option extra-substituters "https://niri.cachix.org" \
  --option extra-trusted-public-keys "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
```

The `--option` flags add the niri binary cache so niri-unstable is downloaded,
not compiled. (After first boot this comes from the config automatically.)

Set the user password when prompted (or `nixos-enter` then `passwd ilya`).

### 5. Reboot

```bash
reboot
```

Remove the ISO. GRUB → boot → **ly** login → log in as `ilya` →
niri starts → quickshell bar appears.

---

## First boot: fix ownership + git remote

The repo (and `/home/ilya` itself) were created by root during install, so fix
ownership of the whole home, then switch the remote to SSH (GitHub no longer
accepts password auth over HTTPS):

```bash
sudo chown -R ilya:users /home/ilya
cd ~/git/nixos-config
git remote set-url origin git@github.com:repen7ant/nixos-config.git
```

SSH needs your private key in `~/.ssh/` first (restore it from your backup).

---

## Rebuilding

```bash
cd ~/git/nixos-config
git add -A                                   # flake sees staged files
sudo nixos-rebuild switch --flake .#thinkpad
```

Update package versions:

```bash
nix flake update          # bump flake.lock
git add -A
sudo nixos-rebuild switch --flake .#thinkpad
```

`nh` is also available: `nh os switch -H thinkpad`.

---

## Notes / gotchas

- **GRUB, not systemd-boot.** systemd-boot's `bootctl` step failed on this
  hardware; the config uses GRUB-EFI (`boot.loader.grub` with `device="nodev"`).
- **IPv6 disabled** (`networking.enableIPv6 = false`) — the test VM's NAT had no
  IPv6 route, causing 15s timeouts in nix/git. Re-enable if a real network needs it.
- **niri = niri-unstable** (for the `include` directive); the overlay is applied
  manually in `common.nix`.
- **xdg portals:** gnome (screencast) + gtk (file chooser). FileChooser is routed
  to gtk explicitly, else file dialogs/downloads break.
- **nvim:** no Mason (doesn't run on NixOS). LSP servers/formatters come from
  `home/nvim-tools.nix`; treesitter compiles parsers via `gcc` + `tree-sitter`.
- **Dark theme** is declarative in `home/theme.nix` (dconf color-scheme + gtk + qt).
- HM/nixpkgs release-skew warning is benign (we track unstable); resolves on a
  later `nix flake update`.
