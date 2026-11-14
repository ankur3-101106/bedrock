# Post-Installation & Verification

After running the hijack script and rebooting, your machine will boot under the control of Bedrock Linux's init multiplexer. This document details how to verify the installation, navigate the boot menu, and configure essential Bedrock settings.

---

## 1. The Bedrock Init Boot Menu

When your system boots:
1. Your bootloader (e.g., GRUB or `systemd-boot`) loads the Linux kernel and initramfs as usual.
2. The kernel executes `/sbin/init` (which is now Bedrock's init shim).
3. Bedrock detects all installed strata with valid init systems and presents an interactive menu in the terminal:
   ```text
   Bedrock Linux 0.7 Poki

   Select an init system:
   -> 1. arch's /usr/lib/systemd/systemd (default)

   Press [Enter] to boot default, or select an option...
   ```
4. If no key is pressed within the timeout (default: 10 seconds), Bedrock automatically boots into the default choice (`arch`).
5. Arch's `systemd` initializes all background services, graphical environments, and login prompts normally.

---

## 2. Initial Status Checks

Log in using your existing user credentials (or as `root`). Open a terminal and run:

### Check Bedrock Overall Status
```bash
brl status
```
Expected output:
```text
arch: enabled
bedrock: enabled
```

### List Installed Strata
```bash
brl list
```
Expected output:
```text
arch
bedrock
```

### Verify Command Provenance (`brl which`)
Use `brl which` to see which stratum supplies a given binary:
```bash
brl which pacman
# Output: arch

brl which brl
# Output: bedrock

brl which bash
# Output: arch
```

---

## 3. Understanding the Bedrock Filesystem Structure

Take a look at `/bedrock`:

```bash
ls -la /bedrock
```

Key directories:
* `/bedrock/strata/` — Houses the isolated roots of each distribution (e.g. `/bedrock/strata/arch`).
* `/bedrock/etc/bedrock.conf` — The primary configuration file for Bedrock Linux.
* `/bedrock/bin/` — Bedrock management utilities (`brl`, `strat`).
* `/bedrock/share/` — Cross-stratum merged mounts (such as desktop icons, application entries, manpages, and fonts).
* `/bedrock/run/` — Ephemeral runtime state and mount namespaces.

---

## 4. Run the Built-in Interactive Tutorial

Bedrock Linux comes with an interactive CLI tutorial that teaches its core concepts and command-line usage. It is highly recommended to run this immediately after installing:

```bash
brl tutorial basics
```

Follow the prompts on screen to understand:
* How cross-strata execution works.
* How file paths and symlinks are resolved.
* How to explicitly call binaries from specific strata using `strat`.

---

## 5. Configuring `/bedrock/etc/bedrock.conf`

Edit the configuration file to customize Bedrock's behavior:

```bash
sudo nano /bedrock/etc/bedrock.conf
```

### Useful Tweaks:

#### 1. Adjust Init Menu Timeout:
Under the `[init]` section:
```ini
[init]
# Seconds to wait before automatically selecting default init
timeout = 3
# Default stratum init to select
default = arch
```

#### 2. Set Default Stratum Priority:
Under `[cross]` or stratum settings, specify preference order when multiple strata provide identical commands.

After modifying `/bedrock/etc/bedrock.conf`, apply changes (or reboot) if needed.

---

## Next Steps

With Bedrock verified on your fresh Arch system, proceed to [Step 05: Strata Management & Cross-Distro Operations](05-strata-management.md) to fetch other distributions like Debian, Ubuntu, Void, or Alpine.
