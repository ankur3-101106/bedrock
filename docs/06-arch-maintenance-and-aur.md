# Arch Maintenance & AUR Integration

Because Arch Linux serves as the foundation (and initial stratum) of your hijacked system, understanding how to maintain it properly ensures system stability, kernel synchronization, and seamless AUR (Arch User Repository) usage.

---

## 1. Updating the Arch Stratum

Perform standard Arch Linux system updates using `pacman`:

```bash
sudo strat arch pacman -Syu
```
*(Or simply `sudo pacman -Syu` if `pacman` only exists in the `arch` stratum).*

> [!TIP]
> Always run package manager updates within their explicit stratum context (e.g., `strat arch pacman -Syu` vs. `strat debian apt upgrade`) to avoid ambiguous PATH resolution when invoking package management hooks.

---

## 2. Kernel Updates & Bootloader Management

In a Bedrock Linux installation, **one stratum provides the active Linux kernel** booted by your hardware bootloader. In this setup, that stratum is `arch`.

### How Kernel Updates Work:
1. When `pacman` upgrades `linux`, `linux-zen`, or `linux-lts`, Arch executes its `mkinitcpio` pacman hooks.
2. The new kernel (`vmlinuz-linux`) and initramfs (`initramfs-linux.img`) are written to `/boot`.
3. If you use GRUB and change kernel types, regenerate the boot configuration:
   ```bash
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   ```
4. If you use `systemd-boot`, ensure your entry points to the updated kernel and initramfs.

> [!IMPORTANT]
> The running kernel belongs to `arch`. Do not install competing kernel packages from other strata (e.g. `linux-image-amd64` in Debian) into the bootloader unless you intentionally manage separate bootloader entries.

---

## 3. AUR Helpers (`paru` / `yay`)

The Arch User Repository works identically under Bedrock as it does on standard Arch Linux.

### Building `paru` or `yay`
Make sure `base-devel` and `git` are installed in `arch`:

```bash
sudo strat arch pacman -S --needed base-devel git
```

Clone and build your preferred AUR helper (e.g. `paru`):

```bash
cd /tmp
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
```

### Using AUR Helpers
Once installed, use `paru` or `yay` to install software from the AUR:

```bash
# Search and install AUR packages
paru -S visual-studio-code-bin
```

Because Bedrock unifies application desktop files, applications installed via AUR in `arch` will immediately appear in your desktop launcher (GNOME, KDE Plasma, Rofi, etc.) and terminal.

---

## 4. Graphics Drivers & Hardware Acceleration

Hardware acceleration requires close coupling between the kernel modules, display server, and userland graphics libraries:

### Best Practice for Graphics:
* **Host Drivers in Arch:** Install your primary GPU drivers (e.g., `mesa`, `nvidia`, `vulkan-radeon`, `vulkan-intel`) inside the `arch` stratum, as Arch's kernel version matches Arch's package versions.
* **Cross-Strata 3D Acceleration:**  
  Bedrock routes OpenGL and Vulkan calls across strata. However, proprietary drivers like NVIDIA require the userland library version to match the running kernel module version. If running graphical applications from another stratum (such as Debian) with proprietary NVIDIA drivers, install the corresponding userland driver version in that stratum as well.

---

## 5. Audio (PipeWire / PulseAudio)

Audio daemons should run under your active init stratum (Arch):

```bash
sudo strat arch pacman -S pipewire pipewire-pulse pipewire-alsa wireplumber
```

When started as a systemd user service in Arch (`systemctl --user enable --now pipewire wireplumber`), all strata gain audio access through the shared UNIX domain socket located at:
`/run/user/<UID>/pulse/native`

---

## 6. Desktop Application Integration

Bedrock automatically aggregates:
* **Desktop entries:** `/bedrock/share/applications`
* **Icons:** `/bedrock/share/icons`
* **Fonts:** `/bedrock/share/fonts`

If you install a graphical application from Arch (via AUR) or from another stratum (e.g. Debian `apt install gimp`), the desktop menu entry is automatically created and accessible to your window manager or desktop environment.

---

## Next Steps

To prepare for emergencies or fix potential boot/path issues, review [Step 07: Troubleshooting & Recovery](07-troubleshooting-and-recovery.md).
