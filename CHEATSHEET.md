# NixOS Cheatsheet

Day-to-day workflow for this config. Coming from Arch: NixOS is **declarative** —
you don't install software, you *describe* it in config, then rebuild. Exceptions
are temporary/per-project environments (`nix shell`, `nix develop`).

Repo lives at `~/git/nixos-config`. Active host: `thinkpad`.

---

## Permanent software (into the system)

Add a package = edit config:

```nix
# home/packages.nix
home.packages = with pkgs; [ foo bar ];
```

Apply:

```bash
cd ~/git/nixos-config
git add -A                                   # flake only sees git-tracked files
sudo nixos-rebuild switch --flake .#thinkpad
```

Remove = delete the line + rebuild. No orphaned deps — GC cleans them.

**Where things go:**
- system (services, hardware) → `hosts/`
- user software → `home/packages.nix`

---

## Updating packages

Versions are frozen in `flake.lock`. Update explicitly:

```bash
nix flake update                  # all inputs (nixpkgs, niri, ...)
nix flake update nixpkgs          # just nixpkgs
git add -A
sudo nixos-rebuild switch --flake .#thinkpad
```

Without `flake update`, a rebuild does NOT change versions — that's the point
(reproducible). Update when you choose, not on every rebuild.

---

## Run something once (don't install)

```bash
nix run nixpkgs#cowsay -- hello     # run once, nothing installed
nix shell nixpkgs#python3 nodejs    # temp shell with these; exit -> gone
```

`nix shell` = temporary PATH with packages. Exit and they're gone. Great for
"just try it".

---

## Dev environments (per-project) ⭐

The big shift from Arch: do NOT install python/node/jdk globally. Each project
ships its own in a `flake.nix`:

```nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs = { nixpkgs, ... }:
    let pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = [ pkgs.python312 pkgs.nodejs pkgs.postgresql ];
      };
    };
}
```

```bash
cd ~/git/myproject
nix develop        # enter env: python312/node/pg available
python --version   # works only here
exit               # gone outside
```

Different projects → different versions, no conflicts. `flake.lock` pins them so
collaborators get the same.

**direnv** (convenience): an `.envrc` with `use flake` auto-loads the env on `cd`
into the dir and unloads on exit. Needs direnv set up (package + bash hook).

---

## Generations + rollback

Every `switch` = a new **generation** (system snapshot). Old ones live until GC.

```bash
# list system generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# roll back to the previous one (if a new build misbehaves)
sudo nixos-rebuild switch --rollback

# or pick an old generation in the GRUB menu at boot
```

Broke the config? Roll back. Safe to experiment.

---

## Garbage collection

```bash
sudo nix-collect-garbage -d      # system profile: drop old generations
nix-collect-garbage -d           # WITHOUT sudo: user/home-manager profile (separate!)
```

This config already runs auto-GC weekly (>14 days old) plus `auto-optimise-store`
(file dedup via hardlinks).

---

## Searching packages

```bash
nix search nixpkgs firefox
```

Or the web: **search.nixos.org** — packages and **Options** (e.g. search
`services.openssh` for module options).

---

## Arch → NixOS

| Arch | NixOS |
|------|-------|
| `pacman -S foo` | edit config + `nixos-rebuild switch` |
| `pacman -Syu` | `nix flake update` + switch |
| `pacman -R foo` | remove the line + switch |
| `yay` / AUR | flake inputs / overlays |
| `python -m venv` | `nix develop` (devShell) |
| global python | per-project devShell |
| broke the system | `--rollback` / GRUB menu |
| `pacman -Qdt` orphans | `nix-collect-garbage -d` |

---

## Typical day

```bash
# install a program: edit packages.nix, then
cd ~/git/nixos-config && git add -A && sudo nixos-rebuild switch --flake .#thinkpad

# work on a project
cd ~/git/proj && nix develop

# try a tool once
nix shell nixpkgs#htop

# update the system (every week or two)
cd ~/git/nixos-config && nix flake update && git add -A && sudo nixos-rebuild switch --flake .#thinkpad
```
