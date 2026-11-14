# Fresh Arch Linux Preparation

This guide covers the recommended preparation steps for a newly installed Arch Linux system prior to hijacking it with Bedrock Linux.

Starting with a clean, fully functional baseline ensures that the hijack process proceeds without encountering missing dependencies, network failures, or bootloader misconfigurations.

---

## 1. Minimal Recommended Arch Package Selection

When performing `pacstrap` during the initial Arch Linux install, or immediately after first boot, ensure you have installed the baseline tools needed for administration and network fetching:

```bash
sudo pacman -Syu --needed \
    base \
    base-devel \
    linux \
    linux-firmware \
    sudo \
    wget \
    curl \
    git \
    tar \
    file \
    which \
    ca-certificates \
    networkmanager
```

> [!NOTE]
> While Bedrock can function with minimal packages, `wget`, `curl`, `tar`, `file`, and `ca-certificates` are essential for Bedrock to download stratum tarballs and bootstrap other distributions.

---

## 2. User & Sudo Configuration

Avoid running purely as `root` for everyday tasks. Ensure a primary user account belongs to the `wheel` administrative group.

```bash
# Create user (e.g. archer) with home directory and wheel group
useradd -m -G wheel -s /bin/bash archer

# Set password
passwd archer
```

Allow the `wheel` group password-authenticated sudo privileges:

```bash
# Edit sudoers safely
sudo EDITOR=nano visudo
```
Uncomment the line:
```text
%wheel ALL=(ALL:ALL) ALL
```

Verify that your regular user can run commands with `sudo`:
```bash
sudo whoami
# Should output: root
```

---

## 3. Network & DNS Verification

A stable network connection is required for both the Bedrock installer script and subsequent `brl fetch` operations.

Enable and verify your network service (e.g. NetworkManager):

```bash
sudo systemctl enable --now NetworkManager
```

Test DNS resolution and external connectivity:

```bash
ping -c 3 archlinux.org
curl -I https://github.com
```

---

## 4. Bootloader Verification

Ensure your bootloader (e.g., GRUB or `systemd-boot`) boots reliably into Arch Linux before you hijack the system.

### If using GRUB:
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### If using systemd-boot:
Ensure `/boot/loader/loader.conf` and `/boot/loader/entries/arch.conf` exist and are configured with the correct `root=UUID=... rw` parameters.

---

## 5. Pacman Keyring & Full System Upgrade

A common issue on newly installed Arch systems is outdated keyring signatures. Synchronize pacman databases and upgrade all installed packages:

```bash
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -Syu
```

---

## 6. Pre-Hijack System Sanity Check

Run the following checks to confirm readiness:

```bash
# 1. Verify kernel version and architecture
uname -r
uname -m  # Should be x86_64

# 2. Check root filesystem type
df -T /
# Supported types: ext4, btrfs, xfs, f2fs

# 3. Check disk space (at least 5-10 GB free)
df -h /
```

If all tests pass, reboot the machine once to guarantee that the current kernel matches the running system:

```bash
sudo reboot
```

---

## Next Steps

Once the Arch baseline is clean and verified, proceed to [Step 03: Hijack Installation](03-hijack-installation.md).
