# Bedrock Linux Installation Guide (Hijacking Fresh Arch Linux)

[![Bedrock Linux](https://img.shields.io/badge/Bedrock%20Linux-0.7%20Poki-blue.svg)](https://bedrocklinux.org)
[![Host Distro](https://img.shields.io/badge/Host-Arch%20Linux-1793d1.svg?logo=archlinux&logoColor=white)](https://archlinux.org)
[![Method](https://img.shields.io/badge/Install%20Method-Hijack-orange.svg)](https://bedrocklinux.org/0.7/installation-instructions.html)

A comprehensive guide and reference repository for installing **Bedrock Linux 0.7 (Poki)** by hijacking a freshly installed **Arch Linux** system.

---

## 🧭 What is Bedrock Linux?

[Bedrock Linux](https://bedrocklinux.org) is a meta-distribution that allows users to mix and match components—such as package managers, init systems, desktop environments, development toolchains, and kernels—from otherwise mutually incompatible Linux distributions seamlessly in a single unified operating system.

When you install Bedrock Linux by "hijacking" an existing distribution, Bedrock restructures the filesystem in-place:
* Your existing distribution (Arch Linux) becomes an isolated **stratum** (named `arch`).
* Bedrock installs its core multiplexing layer (`/bedrock`), which bridges executables, libraries, fonts, themes, manpages, and services across strata.
* You retain all capabilities of your Arch Linux installation while gaining the ability to instantly pull in packages from Debian, Ubuntu, Fedora, Void, Alpine, Gentoo, and more.

```
+--------------------------------------------------------------+
|                      Bedrock Linux System                    |
|                                                              |
|   /bedrock (multiplexing layer, brl, cross-strata routing)   |
+--------------------------------------------------------------+
|   strata/arch      |   strata/debian    |   strata/alpine    |
|   (Pacman + AUR)   |   (APT + .deb)     |   (apk + musl)     |
+--------------------+--------------------+--------------------+
|       Shared Linux Kernel & Hardware Drivers (from Arch)     |
+--------------------------------------------------------------+
```

---

## 📚 Documentation Index

| Step | Document | Description |
| :--- | :--- | :--- |
| **01** | [Prerequisites & Planning](docs/01-prerequisites.md) | Hardware requirements, filesystem requirements (extended attributes), and backup recommendations. |
| **02** | [Fresh Arch Linux Preparation](docs/02-arch-linux-preparation.md) | Setting up an optimal, minimal Arch Linux baseline with network, bootloader, and admin privileges. |
| **03** | [Hijack Installation](docs/03-hijack-installation.md) | Step-by-step instructions for downloading, verifying, and executing the hijack script. |
| **04** | [Post-Installation & Verification](docs/04-post-installation.md) | Rebooting, navigating the Bedrock boot menu, verifying `brl status`, and running interactive tutorials. |
| **05** | [Strata Management & Cross-Distro Operations](docs/05-strata-management.md) | Fetching secondary distributions (`brl fetch`), executing cross-strata commands with `strat`, and configuring priorities. |
| **06** | [Arch Maintenance & AUR Integration](docs/06-arch-maintenance-and-aur.md) | Updating Arch (`pacman -Syu`), AUR helpers (`paru`/`yay`), kernel updates, and desktop integration. |
| **07** | [Troubleshooting & Recovery](docs/07-troubleshooting-and-recovery.md) | Live USB rescue procedures, chrooting into Bedrock, init repair, and common issue resolutions. |

---

## 🛠️ Verification Script

A diagnostic script [`scripts/pre-hijack-check.sh`](scripts/pre-hijack-check.sh) is provided to validate your fresh Arch Linux setup before initiating the hijack:

```bash
chmod +x scripts/pre-hijack-check.sh
./scripts/pre-hijack-check.sh
```

---

## ⚡ Quickstart Summary

For experienced users who already have a clean, booted Arch Linux system with root/sudo privileges:

```bash
# 1. Ensure system is up to date and prerequisites are present
sudo pacman -Syu --needed base-devel wget ca-certificates curl

# 2. Download the latest Bedrock Linux Poki x86_64 installer
# (Check https://bedrocklinux.org or GitHub releases for the latest version tag)
wget https://github.com/bedrocklinux/bedrocklinux-userland/releases/download/0.7.31/bedrock-linux-0.7.31-x86_64.sh

# 3. Verify the script integrity (compare SHA256 against release notes)
sha256sum bedrock-linux-0.7.31-x86_64.sh

# 4. Execute the hijack installer as root
sudo sh bedrock-linux-0.7.31-x86_64.sh --hijack

# 5. Reboot your system into Bedrock Linux
sudo reboot
```

After rebooting:

```bash
# Verify installation
brl status

# Fetch another stratum (e.g. Debian bookworm)
sudo brl fetch debian

# Run commands from other strata
strat debian apt update
strat debian apt install neofetch
strat debian neofetch
```

---

## ⚠️ Important Considerations

> [!WARNING]
> **Bedrock Linux hijack is irreversible:** There is no automated "un-hijack" command. Reverting requires restoring from a disk backup or completely reinstalling. Always test in a virtual machine first or back up essential partitions before executing `--hijack`.

> [!NOTE]
> Arch Linux is one of the highest-rated base distributions for Bedrock Linux due to its up-to-date kernel, pure systemd implementation, and robust packaging tools.

---

## 📄 License & Attribution

This guide is provided for educational and administrative reference. Bedrock Linux is created and maintained by the [Bedrock Linux Project](https://bedrocklinux.org). Arch Linux is a trademark of the Arch Linux project.
