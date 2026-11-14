# Hijacking Void Linux & Alpine Linux (Non-Systemd & Minimalist)

This guide covers preparing and hijacking **Void Linux** (powered by `runit`) or **Alpine Linux** (powered by `OpenRC` and `musl-libc`) into Bedrock Linux.

---

## 💡 Why Choose Void or Alpine as Base?

* **Void Linux:** The top choice for non-systemd users. It uses `runit` init, provides instant 2-3 second boots, consumes ~100MB RAM at idle, and offers an independent rolling release.
* **Alpine Linux:** The ultimate lightweight base. Tiny memory footprint (< 50MB RAM), uses `musl-libc` and `OpenRC`.

---

## 1. Void Linux Preparation & Hijack

### Step 1: Install Baseline Utilities
Ensure `xbps` has updated repository metadata and core utilities:

```bash
sudo xbps-install -Syu
sudo xbps-install -y wget curl ca-certificates tar file
```

### Step 2: Run Hijack Script
```bash
wget "https://github.com/bedrocklinux/bedrocklinux-userland/releases/download/0.7.31/bedrock-linux-0.7.31-x86_64.sh"
sudo sh ./bedrock-linux-0.7.31-x86_64.sh --hijack
sudo reboot
```

### Step 3: Booting with `runit`
During boot, the Bedrock init selection menu will display:
```text
Select an init system:
-> 1. void's /usr/bin/runit-init (default)
```
Bedrock integrates seamlessly with Void's `runit`. Services managed in `/var/service` (via `ln -s /etc/sv/<service> /var/service/`) will function normally.

---

## 2. Alpine Linux Preparation & Hijack

### Step 1: Install Baseline Utilities & Bash
Alpine uses BusyBox by default. The Bedrock installer script and common fetch scripts require GNU `bash`, `tar`, and `ca-certificates`:

```bash
apk update
apk add wget curl ca-certificates tar file bash
```

### Step 2: Ensure Root Filesystem Supports Extended Attributes
If you installed Alpine on a standard `ext4` or `btrfs` partition, verify xattrs are active:
```bash
touch /tmp/test && setfattr -n user.test -v 1 /tmp/test && rm /tmp/test
```

### Step 3: Run Hijack Script
```bash
wget "https://github.com/bedrocklinux/bedrocklinux-userland/releases/download/0.7.31/bedrock-linux-0.7.31-x86_64.sh"
sh ./bedrock-linux-0.7.31-x86_64.sh --hijack
reboot
```

---

## 3. Pairing with glibc Strata (Debian / Arch)

Because Alpine uses `musl-libc`, proprietary or pre-compiled glibc binaries (e.g. Steam, Discord, VS Code, CUDA) will not run directly on Alpine's C-library.

Under Bedrock, this limitation vanishes! Simply fetch a glibc stratum:

```bash
# Fetch Debian bookworm as a secondary stratum for glibc binaries
sudo brl fetch debian

# Run glibc software effortlessly
strat debian apt install -y firefox-esr
strat debian firefox-esr
```
Bedrock routes the dynamic loader and glibc dependencies inside the `debian` stratum while keeping Alpine as your lightweight host kernel and init!
