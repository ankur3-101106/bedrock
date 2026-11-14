# Hijack Installation Guide

This guide walks through the exact process of downloading, verifying, and executing the Bedrock Linux hijacking script on a fresh Arch Linux system.

---

## 1. Understanding the Hijack Process

When you run Bedrock's hijack installer with the `--hijack` flag:
1. **Safety Pre-checks:** It validates your architecture (`x86_64`), checks that the filesystem supports POSIX extended attributes (`xattrs`), and tests for available storage.
2. **Directory Relocation:** It moves existing Arch root directories (`/bin`, `/sbin`, `/lib`, `/usr`, `/etc`, `/var`, `/opt`, etc.) into `/bedrock/strata/arch`.
3. **Bedrock Core Deployment:** It populates `/bedrock` with core binaries (`brl`, `strat`), configuration files (`/bedrock/etc/bedrock.conf`), and cross-filesystem virtualization utilities.
4. **Init Hijacking:** It replaces `/sbin/init` with `/bedrock/libexec/init`. At boot time, this shim allows you to select which stratum's init system to run (by default, Arch's `systemd`).

```
Before Hijack:
/ (Arch Linux Root)
├── bin -> usr/bin
├── etc/
├── usr/
└── var/

After Hijack:
/
├── bedrock/
│   ├── bin/
│   │   ├── brl
│   │   └── strat
│   ├── etc/
│   │   └── bedrock.conf
│   └── strata/
│       └── arch/          <--- Your original Arch Linux installation!
│           ├── etc/
│           ├── usr/
│           └── var/
├── etc/ -> /bedrock/share/etc
└── usr/ -> /bedrock/share/usr
```

---

## 2. Step 1: Download the Installer Script

Navigate to a temporary or home working directory on your Arch machine:

```bash
cd ~
```

Download the latest stable release of the Bedrock Linux installer for `x86_64`:

```bash
# Check https://github.com/bedrocklinux/bedrocklinux-userland/releases for the latest version tag
BEDROCK_VERSION="0.7.31"
ARCH="x86_64"

wget "https://github.com/bedrocklinux/bedrocklinux-userland/releases/download/${BEDROCK_VERSION}/bedrock-linux-${BEDROCK_VERSION}-${ARCH}.sh"
```

Verify that the script downloaded completely:
```bash
ls -lh bedrock-linux-*.sh
```

---

## 3. Step 2: Verify Script Integrity

Always verify the SHA256 checksum against the official hash provided on the [Bedrock Linux Releases](https://github.com/bedrocklinux/bedrocklinux-userland/releases) page:

```bash
sha256sum bedrock-linux-${BEDROCK_VERSION}-${ARCH}.sh
```

Ensure the calculated hash matches the hash specified in the release notes before proceeding.

---

## 4. Step 3: Run the Hijack Script

> [!WARNING]
> Do **NOT** run this script over a fragile remote SSH session that might drop mid-execution. If running remotely over SSH, use `tmux` or `screen`.

Execute the installer script with root privileges and the `--hijack` flag:

```bash
sudo sh ./bedrock-linux-${BEDROCK_VERSION}-${ARCH}.sh --hijack
```

### What to Expect During the Script:

1. **Interactive Prompt:**  
   The script displays an explanation that the hijack process is irreversible. You will be required to type a confirmation phrase (typically `Not revertible` or similar prompt as requested on screen) to acknowledge and continue.
2. **System Inspection:**  
   The script checks kernel capabilities, filesystem extended attributes, and disk layout.
3. **Execution & File Migration:**  
   The script migrates the current Arch system into `/bedrock/strata/arch`. This typically takes under two minutes on a fresh install.
4. **Completion Message:**  
   Once finished, the script informs you that the hijack succeeded and instructs you to reboot.

---

## 5. Step 4: Reboot into Bedrock Linux

Do not manually alter system files immediately after the script finishes. Safely reboot the machine:

```bash
sudo reboot
```

---

## Next Steps

Once the machine reboots, proceed to [Step 04: Post-Installation & Verification](04-post-installation.md) to verify your system and test cross-stratum commands.
