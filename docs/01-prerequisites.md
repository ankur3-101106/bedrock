# Prerequisites & Planning

Before hijacking your Arch Linux system with Bedrock Linux, review the hardware, filesystem, and system requirements outlined in this guide.

---

## 1. System & Architecture Compatibility

Bedrock Linux 0.7 (Poki) supports multiple CPU architectures:
* `x86_64` (Recommended / Most Common)
* `aarch64` / `arm64`
* `armv7l`
* `i686`
* `ppc64le`
* `mips64el`

Ensure your host Arch Linux installation matches the target Bedrock architecture by running:

```bash
uname -m
```
Expected output for standard modern systems: `x86_64`.

---

## 2. Filesystem Requirements

Bedrock relies heavily on **POSIX Extended Attributes (xattrs)** to track file ownership and cross-stratum metadata.

### Supported Filesystems
* `ext4` (Recommended)
* `btrfs`
* `xfs`
* `f2fs`

> [!CAUTION]
> Filesystems without extended attribute support (such as FAT32, exFAT, or NTFS) **cannot** be used as the root (`/`) filesystem for Bedrock Linux.

### Encryption (LUKS)
If you are using LUKS full-disk encryption, Bedrock functions normally because the underlying filesystem inside the decrypted mapper device (e.g., `/dev/mapper/root`) exposes standard POSIX extended attributes to the OS.

---

## 3. Bootloader & Init Compatibility

Arch Linux typically uses:
* **Bootloaders:** GRUB, `systemd-boot`, EFISTUB, or rEFInd.
* **Init System:** `systemd` (standard Arch default).

Bedrock functions by intercepting the init process at boot time. It leaves your existing bootloader intact and places an init selection wrapper (`/bedrock/libexec/init`) in place of `/sbin/init`.
Both UEFI and Legacy BIOS systems are fully supported.

---

## 4. Network & Storage Checklist

| Requirement | Minimum | Recommended | Notes |
| :--- | :--- | :--- | :--- |
| **Free Disk Space** | 5 GB | 20+ GB | Depends on how many additional strata (Debian, Ubuntu, Void, Fedora) you plan to fetch. |
| **RAM** | 1 GB | 4+ GB | Minimal overhead introduced by Bedrock itself (less than a few megabytes). |
| **Internet Connection** | Active | Stable Broadband | Required for downloading Bedrock installer and bootstrapping remote strata. |
| **Privileges** | Root / Sudo | Sudo access | Hijack script must be executed with root permissions. |

---

## 5. Automated Pre-Hijack Verification

A sanity check script is included in this repository to automate pre-flight validation on your Arch machine:

```bash
chmod +x scripts/pre-hijack-check.sh
./scripts/pre-hijack-check.sh
```

It validates:
- Supported CPU architecture (`uname -m`)
- Host distribution detection (`/etc/arch-release`)
- Root filesystem type and extended attribute (`xattr`) read/write support
- Free storage on the root filesystem (> 5 GB)
- Essential extraction and network utilities (`wget`, `curl`, `tar`, `file`, `ca-certificates`)
- Administrative / sudo privileges

---

## 6. Backup Recommendation (Critical)

> [!WARNING]
> **The Hijack Process is Irreversible:**  
> The hijack script moves existing system directories (`/bin`, `/sbin`, `/lib`, `/usr`, `/etc`, etc.) into `/bedrock/strata/arch` and replaces standard root paths with virtual FUSE/bind-mount multiplexers.  
> There is **no automated un-hijack tool**.

### Recommended Backup Methods

Before proceeding:
1. **Virtual Machine Snapshot:** If testing in KVM/QEMU, VirtualBox, or Proxmox, create a snapshot of the clean Arch VM.
2. **Disk Image Backup:** Use `dd`, `Clonezilla`, or `partclone` to back up the raw partition or disk.
3. **Btrfs Snapshot (if on Btrfs):**
   ```bash
   sudo btrfs subvolume snapshot / /snapshots/pre-bedrock-backup
   ```
4. **Tarball Backup:**
   ```bash
   sudo tar -cvpzf /path/to/external/backup.tar.gz --exclude=/path/to/external --one-file-system /
   ```

---

## Next Steps

Once prerequisites and backups are verified, proceed to [Step 02: Fresh Arch Linux Preparation](02-arch-linux-preparation.md).
