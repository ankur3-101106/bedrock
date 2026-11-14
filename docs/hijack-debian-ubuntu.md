# Hijacking Debian & Ubuntu

This guide covers preparing and hijacking a freshly installed **Debian** (e.g., Debian 12 Bookworm) or **Ubuntu** (e.g., Ubuntu 24.04 / 22.04 LTS) system into Bedrock Linux.

---

## 💡 Why Choose Debian or Ubuntu as Base?

* **Debian:** Unrivaled kernel and system stability. Ideal for production servers, homelabs, or workstations where hardware drivers never break.
* **Ubuntu:** Unmatched commercial hardware certification, seamless proprietary GPU installation wizards, and native ZFS-on-root support.

---

## 1. Pre-Hijack Preparation

### A. Debian Specifics: Sudo & Path
On a minimal Debian install, `sudo` is often not configured for the default user:

```bash
# As root:
apt update
apt install -y sudo wget curl ca-certificates tar file

# Add your user to the sudo group
usermod -aG sudo <your-username>
```

Verify that `/sbin` and `/usr/sbin` are in your user's `$PATH`.

### B. Ubuntu Specifics: Snap Considerations
Ubuntu includes `snapd` by default. Under Bedrock:
* Native `.deb` packages and cross-stratum software integrate cleanly.
* Snaps that rely on AppArmor strict confinement may require classical confinement flags or running directly from the Ubuntu stratum context.
* If you do not need snap, you can keep it or remove it before hijacking:
  ```bash
  sudo apt update
  sudo apt install -y wget curl ca-certificates tar file
  ```

---

## 2. Execute the Bedrock Hijack

1. Download the Bedrock Linux installer script:
   ```bash
   cd ~
   BEDROCK_VER="0.7.31"
   wget "https://github.com/bedrocklinux/bedrocklinux-userland/releases/download/${BEDROCK_VER}/bedrock-linux-${BEDROCK_VER}-x86_64.sh"
   ```

2. Verify integrity:
   ```bash
   sha256sum bedrock-linux-${BEDROCK_VER}-x86_64.sh
   ```

3. Run the hijack script with root permissions:
   ```bash
   sudo sh ./bedrock-linux-${BEDROCK_VER}-x86_64.sh --hijack
   ```

4. Confirm the prompt by typing the confirmation phrase required on screen (`Not revertible`).

5. Once completed, reboot the system:
   ```bash
   sudo reboot
   ```

---

## 3. Post-Hijack Verification & Configuration

At boot, the Bedrock init menu will detect Debian/Ubuntu's `systemd` (`/lib/systemd/systemd`). Press Enter or wait for timeout.

Verify status:
```bash
brl status
# Output:
# debian: enabled (or ubuntu: enabled)
# bedrock: enabled
```

---

## 4. Recommended Next Step: Fetch Arch for AUR Access

Since Debian and Ubuntu have conservative package cycles, the best companion stratum is **Arch Linux**, which grants access to the Arch User Repository (AUR) and cutting-edge desktop applications:

```bash
# Fetch Arch Linux stratum
sudo brl fetch arch

# Install bleeding-edge software from Arch pacman
sudo strat arch pacman -Syu --needed neovim ripgrep
```
