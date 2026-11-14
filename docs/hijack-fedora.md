# Hijacking Fedora Linux

This guide covers preparing and hijacking a freshly installed **Fedora Workstation** or **Fedora Server** system into Bedrock Linux.

---

## 💡 Why Choose Fedora as Base?

* **Modern Upstream Stack:** Ships with new Linux kernels, Wayland by default, and pure GNOME/KDE upstream releases.
* **Enterprise-Ready:** Backed by Red Hat ecosystem standards, DNF package manager, and SELinux.

---

## ⚠️ Important Compatibility Warnings for Fedora

> [!CAUTION]
> **1. SELinux Must be Set to Permissive Before Hijacking:**  
> By default, Fedora enforces strict SELinux policies that block Bedrock's root filesystem migration and virtual mounts. You **must** switch SELinux to `permissive` mode before executing `--hijack`.
>
> **2. Fedora Silverblue / Atomic Desktops are NOT Supported:**  
> Fedora Silverblue and Kinoite use a read-only `ostree` root filesystem. Bedrock requires a read-write root with extended attributes (`ext4`, `btrfs`, `xfs`). Use standard Fedora Workstation or Server.

---

## 1. Pre-Hijack Preparation

### Step 1: Update Packages & Install Tools
```bash
sudo dnf upgrade -y
sudo dnf install -y wget curl ca-certificates tar file
```

### Step 2: Switch SELinux to Permissive Mode
Temporarily set SELinux to permissive:
```bash
sudo setenforce 0
```

Make it persistent across the hijack reboot by editing `/etc/selinux/config`:
```bash
sudo sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
```

Verify current status:
```bash
getenforce
# Should output: Permissive
```

---

## 2. Execute the Bedrock Hijack

1. Download the Bedrock Linux installer script:
   ```bash
   cd ~
   BEDROCK_VER="0.7.31"
   wget "https://github.com/bedrocklinux/bedrocklinux-userland/releases/download/${BEDROCK_VER}/bedrock-linux-${BEDROCK_VER}-x86_64.sh"
   ```

2. Run the hijack script:
   ```bash
   sudo sh ./bedrock-linux-${BEDROCK_VER}-x86_64.sh --hijack
   ```

3. Type the confirmation phrase as prompted.

4. Reboot:
   ```bash
   sudo reboot
   ```

---

## 3. Post-Hijack Verification & Next Steps

After rebooting, select Fedora's `systemd` in the Bedrock init menu.

Verify status:
```bash
brl status
# Output:
# fedora: enabled
# bedrock: enabled
```

### Recommended Strata Pairing:
Fetch **Arch Linux** to gain access to the Arch User Repository (AUR) or **Debian** for Debian/Ubuntu `.deb` packages:

```bash
# Fetch Arch Linux stratum for AUR packages
sudo brl fetch arch

# Fetch Debian stratum for Debian binaries
sudo brl fetch debian
```
