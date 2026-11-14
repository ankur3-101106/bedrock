# Troubleshooting & Recovery

This guide covers diagnostic techniques, recovery procedures using an Arch Linux Live USB, and solutions for common Bedrock Linux scenarios.

---

## 1. Emergency Recovery using Arch Live USB

If a misconfiguration or kernel incompatibility prevents your system from booting, you can recover using an official Arch Linux installation USB or ISO.

### Step 1: Boot into the Arch Live Environment
Insert your Arch install medium and boot from it into the root zsh shell.

### Step 2: Mount Your Partitions
Identify your root partition using `lsblk -f`:

```bash
# Example: root partition is /dev/nvme0n1p2 and EFI is /dev/nvme0n1p1
mount /dev/nvme0n1p2 /mnt
mount /dev/nvme0n1p1 /mnt/boot   # (or /mnt/boot/efi if applicable)
```

### Step 3: Chrooting into the Arch Stratum
To service the underlying Arch system (e.g. reinstall kernels, fix bootloader, repair pacman database), chroot directly into the `arch` stratum root:

```bash
arch-chroot /mnt/bedrock/strata/arch
```

Inside this chroot:
* You are operating directly in pure Arch Linux.
* Run `pacman -Syu`, rebuild `mkinitcpio -P`, or reconfigure GRUB.
* Exit when complete:
  ```bash
  exit
  ```

---

## 2. Emergency Bypass: Booting Arch Directly without Bedrock Init

If Bedrock's init multiplexer (`/bedrock/libexec/init`) ever fails, you can force the Linux kernel to bypass Bedrock and boot directly into Arch's standard `systemd`.

### Method A: Kernel Parameter at Bootloader
At the GRUB or systemd-boot menu:
1. Press `e` to edit the kernel command line.
2. Append the following argument to the end of the `linux` line:
   ```text
   init=/bedrock/strata/arch/usr/lib/systemd/systemd
   ```
3. Press `Ctrl+X` or `F10` to boot. The system boots straight into Arch Linux `systemd`.

### Method B: Symlink Override from Live USB
From an Arch live USB (with root mounted at `/mnt`):
```bash
ln -sf /bedrock/strata/arch/usr/lib/systemd/systemd /mnt/sbin/init
```

---

## 3. Common Issues & Solutions

### A. Hijack Fails with "Extended Attributes not supported"
* **Cause:** The root filesystem was formatted or mounted without POSIX extended attribute (`xattr`) support.
* **Fix:**
  Ensure you are using `ext4`, `btrfs`, `xfs`, or `f2fs`. For `ext4`, check mount options in `/etc/fstab` and ensure `user_xattr` is not explicitly disabled.

---

### B. `brl fetch` Fails or Drops Connection
* **Cause:** Missing CA certificates, proxy interference, or unstable DNS.
* **Fix:**
  Ensure `ca-certificates`, `curl`, and `wget` are installed and up to date in the Arch stratum:
  ```bash
  sudo strat arch pacman -S --needed ca-certificates curl wget
  ```
  Check DNS resolution (`cat /etc/resolv.conf`).

---

### C. Conflicting Binaries / Wrong Version Executing
* **Symptom:** Executing a command (e.g., `python3` or `gcc`) launches a version from an unexpected stratum.
* **Diagnosis:**
  ```bash
  brl which python3
  ```
* **Fix:**
  Explicitly invoke the preferred stratum version:
  ```bash
  strat arch python3
  # or
  strat debian python3
  ```
  To change default priorities permanently, adjust the cross-path precedence rules in `/bedrock/etc/bedrock.conf`.

---

### D. Pacman "Database Locked" Error
* **Symptom:** `error: failed to init transaction (unable to lock database)`.
* **Fix:**
  Verify that no background pacman process is running:
  ```bash
  sudo rm /bedrock/strata/arch/var/lib/pacman/db.lck
  ```

---

### E. GUI Application Installed in Another Stratum Does Not Appear in Launcher
* **Cause:** The desktop environment hasn't re-indexed Bedrock's merged applications directory.
* **Fix:**
  Trigger a desktop database update or restart your application launcher:
  ```bash
  update-desktop-database /bedrock/share/applications
  ```

---

## 4. Useful Diagnostic Commands

| Command | Purpose |
| :--- | :--- |
| `brl status` | Check status of all configured strata. |
| `brl which <binary>` | Determine which stratum provides a specific command. |
| `brl list` | Display list of all active strata. |
| `brl version` | Print Bedrock userland version. |
| `journalctl -xe` | Inspect systemd system logs from the init stratum. |

---

## Conclusion & Further Reading

For additional support, bug reports, and community advice:
* [Bedrock Linux Official Documentation](https://bedrocklinux.org)
* [Bedrock Linux Discord & IRC](https://bedrocklinux.org/community.html)
* [Arch Linux Wiki](https://wiki.archlinux.org)
