# Bedrock Linux Multi-Distro Installation & Feature Selection Guide

[![Bedrock Linux](https://img.shields.io/badge/Bedrock%20Linux-0.7%20Poki-blue.svg)](https://bedrocklinux.org)
[![Host Options](https://img.shields.io/badge/Host%20Distros-Arch%20%7C%20Debian%20%7C%20Ubuntu%20%7C%20Void%20%7C%20Alpine%20%7C%20Fedora-success.svg)](docs/distro-selection-matrix.md)
[![Interactive Wizard](https://img.shields.io/badge/Wizard-Interactive%20CLI-brightgreen.svg)](scripts/bedrock-wizard.sh)
[![Method](https://img.shields.io/badge/Install%20Method-Hijack-orange.svg)](https://bedrocklinux.org/0.7/installation-instructions.html)

An interactive, comprehensive guide and toolkit for installing **Bedrock Linux 0.7 (Poki)** via the in-place **hijack method**.

Select your foundational base distribution based on your hardware, kernel, init, and workflow requirements, or launch our interactive terminal matchmaker to decide for you.

---

## 🧭 What is Bedrock Linux?

[Bedrock Linux](https://bedrocklinux.org) is a meta-distribution that allows users to mix and match components—such as package managers, init systems, desktop environments, development toolchains, and kernels—from otherwise mutually incompatible Linux distributions seamlessly in a single unified operating system.

When you install Bedrock Linux by "hijacking" an existing distribution, Bedrock restructures the filesystem in-place:
* Your chosen base distribution (e.g. Arch, Debian, Ubuntu, Void, Alpine, Fedora) becomes the primary **stratum**.
* Bedrock installs its core multiplexing layer (`/bedrock`), which bridges executables, libraries, fonts, themes, manpages, and services across strata.
* You can fetch other distributions side-by-side using `brl fetch`, allowing you to combine Arch's AUR, Debian's rock-solid stability, Ubuntu's commercial driver support, and Void's `runit` init in one running system.

```
+-------------------------------------------------------------------------+
|                          Bedrock Linux System                           |
|                                                                         |
|        /bedrock (multiplexing layer, brl, cross-strata routing)         |
+-------------------------------------------------------------------------+
|   strata/arch     |   strata/debian   |   strata/void   | strata/alpine |
|  (Pacman + AUR)   |   (APT + .deb)    |  (xbps + runit) |  (apk + musl) |
+-------------------+-------------------+-----------------+---------------+
|        Shared Linux Kernel & Hardware Drivers (from Host Base)          |
+-------------------------------------------------------------------------+
```

---

## 🎮 Interactive Distro Selection & Hijack Wizard

Run our interactive terminal wizard directly on your machine:

```bash
chmod +x scripts/bedrock-wizard.sh
./scripts/bedrock-wizard.sh
```

### Features included in the wizard:
1. **Distro Matchmaker Quiz:** Asks about your hardware, kernel updates, init preferences, and gaming needs to score and recommend your optimal base distro.
2. **Pre-Hijack System Compatibility Audit:** Inspects your live machine for architecture, filesystem xattr support, disk space, and core utilities.
3. **Interactive Hijack Assistant:** Downloads the verified release installer and provides guided execution.
4. **Post-Install Stratum Guide:** Recommends companion strata tailored to your chosen host.

---

## 📊 Feature vs. Base Distro Decision Matrix

| Desired Feature / Focus | Recommended Base Distro | Alternative | Key Benefit | Dedicated Guide |
| :--- | :--- | :--- | :--- | :--- |
| **Latest Gaming & Hardware** | **Arch Linux** | Fedora | Newest Linux kernel, cutting-edge Mesa, direct NVIDIA proprietary blobs, AUR gaming utilities. | [Arch Linux Guide](docs/03-hijack-installation.md) |
| **Rock-Solid Stability / Server** | **Debian Stable** | Ubuntu LTS | Minimal kernel churn, battle-tested packages, zero unexpected breaking changes across updates. | [Debian & Ubuntu Guide](docs/hijack-debian-ubuntu.md) |
| **Commercial Hardware / ZFS** | **Ubuntu LTS** | Debian | Canonical proprietary driver wizard, extensive OEM certified hardware, native ZFS-on-root. | [Debian & Ubuntu Guide](docs/hijack-debian-ubuntu.md) |
| **Non-Systemd / Ultra-Fast Boot** | **Void Linux** | Alpine | Powered by `runit` init, boots in 2–4 seconds, glibc or musl options, light footprint (~100MB RAM). | [Void & Alpine Guide](docs/hijack-void-alpine.md) |
| **Minimal RAM (<512MB) / Embedded** | **Alpine Linux** | Void (musl) | Ultra-lightweight `musl-libc` and `OpenRC`, tiny container-friendly footprint (~40MB RAM). | [Void & Alpine Guide](docs/hijack-void-alpine.md) |
| **Enterprise Dev / SELinux** | **Fedora** | Debian | Modern upstream stack, excellent Wayland/GNOME experience, SELinux security integration. | [Fedora Guide](docs/hijack-fedora.md) |

For the complete decision tree, flowchart, and scoring questionnaire, see the [Base Distro Selection Matrix](docs/distro-selection-matrix.md).

---

## 📚 Documentation Index

### Core Architecture & Decision Planning
* **[Base Distro Selection Matrix](docs/distro-selection-matrix.md)** — Decision flowchart, scoring quiz, and in-depth distro profiles.
* **[01. Prerequisites & Planning](docs/01-prerequisites.md)** — System requirements, filesystem extended attributes (`xattrs`), and backup protocols.

### Base Distro Hijack Guides
* **[Arch Linux Hijack Guide](docs/03-hijack-installation.md)** — Detailed hijack walkthrough on a fresh Arch installation.
  * *(See also [Arch Preparation](docs/02-arch-linux-preparation.md) and [Arch Maintenance & AUR](docs/06-arch-maintenance-and-aur.md))*
* **[Debian & Ubuntu Hijack Guide](docs/hijack-debian-ubuntu.md)** — Preparing Debian/Ubuntu, sudo/snap considerations, and pairing with Arch strata.
* **[Void & Alpine Linux Hijack Guide](docs/hijack-void-alpine.md)** — Non-systemd setup with `runit` or `OpenRC`, plus glibc strata pairing.
* **[Fedora Linux Hijack Guide](docs/hijack-fedora.md)** — DNF setup, critical SELinux permissive requirements, and rpm-ostree caveats.

### Post-Install Operations & Maintenance
* **[04. Post-Installation & Verification](docs/04-post-installation.md)** — Bedrock boot menu selection, `brl status`, and interactive tutorial.
* **[05. Strata Management & Cross-Distro Operations](docs/05-strata-management.md)** — Fetching strata (`brl fetch`), using `strat`, and lifecycle controls.
* **[06. Arch Maintenance & AUR Integration](docs/06-arch-maintenance-and-aur.md)** — Updating pacman, building AUR packages, and handling desktop integration.
* **[07. Troubleshooting & Recovery](docs/07-troubleshooting-and-recovery.md)** — Live USB rescue procedures, chrooting into Bedrock, init repair, and FAQs.

---

## 🛠️ Verification & Helper Scripts

| Script | Purpose |
| :--- | :--- |
| [`scripts/bedrock-wizard.sh`](scripts/bedrock-wizard.sh) | **Full interactive terminal wizard**: Distro matchmaker quiz, live system audit, guided hijack installer, and stratum recommendations. |
| [`scripts/pre-hijack-check.sh`](scripts/pre-hijack-check.sh) | Quick standalone sanity check script to test host architecture, xattrs, disk space, and tools. |

---

## ⚡ Quickstart Summary (Arch Linux Host Example)

```bash
# 1. Update system and ensure prerequisites are present
sudo pacman -Syu --needed base-devel wget ca-certificates curl

# 2. Download the latest Bedrock Linux Poki x86_64 installer
wget https://github.com/bedrocklinux/bedrocklinux-userland/releases/download/0.7.31/bedrock-linux-0.7.31-x86_64.sh

# 3. Verify integrity
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

---

## 📄 License & Attribution

This guide is provided for educational and administrative reference. Bedrock Linux is created and maintained by the [Bedrock Linux Project](https://bedrocklinux.org). All referenced distribution trademarks belong to their respective projects.
