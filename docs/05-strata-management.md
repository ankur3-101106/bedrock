# Strata Management & Cross-Distro Operations

The real power of Bedrock Linux is its ability to seamlessly integrate multiple distributions (strata) side-by-side. This guide covers how to fetch other distributions, run cross-strata software, and manage strata lifecycles.

---

## 1. What is a Stratum?

In Bedrock terminology, a **stratum** is an isolated userland filesystem root representing a specific Linux distribution (or custom environment).
* Each stratum maintains its own package manager (`pacman`, `apt`, `apk`, `dnf`, `xbps`).
* Strata share the same running kernel, hardware drivers, memory space, network interfaces, `/home`, and `/tmp`.
* Bedrock's virtualization layer transparently exposes binaries, libraries, man pages, application menu entries, and fonts across all active strata.

---

## 2. Listing Available Distributions to Fetch

Bedrock provides pre-configured bootstrap fetch scripts for popular distributions:

```bash
brl fetch --list
```

Supported fetch targets include:
* `debian` (Stable, Testing, or Unstable)
* `ubuntu` (LTS or standard releases)
* `alpine` (Ultra-lightweight, musl-based)
* `void` (Fast `xbps` package manager, runit init option)
* `fedora` (RPM and modern DNF stack)
* `gentoo` (Source-based Portage system)
* `centos` / `rocky` / `almalinux`

---

## 3. Fetching New Strata

Use `brl fetch` with root privileges to automatically download and configure a new stratum.

### Example A: Fetching Debian
```bash
sudo brl fetch debian
```
*Follow the interactive prompts to choose the release suite (e.g. `bookworm` for stable).*

### Example B: Fetching Ubuntu
```bash
sudo brl fetch ubuntu
```

### Example C: Fetching Alpine Linux (Minimal & Fast)
```bash
sudo brl fetch alpine
```

Once fetched, check your updated strata list:
```bash
brl list
# Output:
# arch
# bedrock
# debian
# alpine
```

---

## 4. The `strat` Command

The `strat` utility allows you to explicitly invoke a binary or shell inside the context of a specific stratum.

### Syntax
```bash
strat <stratum-name> <command> [arguments...]
```

### Practical Examples

#### Update Debian Repositories and Install a Package:
```bash
sudo strat debian apt update
sudo strat debian apt install neofetch
```

#### Install Packages from Alpine with `apk`:
```bash
sudo strat alpine apk add ripgrep
```

#### Run an Interactive Shell within a Specific Stratum:
```bash
strat debian bash
# You are now in a bash shell whose primary PATH is Debian
exit
```

---

## 5. Implicit vs. Explicit Cross-Strata Execution

Bedrock creates a merged PATH across all enabled strata:

* **Unique Binaries:**  
  If a binary exists in only one stratum (e.g., `apt` in Debian or `pacman` in Arch), you can invoke it directly from any shell without specifying `strat`:
  ```bash
  sudo apt install sl
  ```
* **Conflicting Binaries:**  
  If multiple strata provide the same binary (e.g., both Arch and Debian provide `git`), Bedrock uses the priority defined in `/bedrock/etc/bedrock.conf`.  
  To bypass priority and ensure a specific version runs:
  ```bash
  strat arch git --version
  strat debian git --version
  ```
* **Verify Which Stratum Runs:**
  ```bash
  brl which git
  ```

---

## 6. Managing Strata Lifecycle

### Enabling and Disabling Strata
If you want to temporarily disable a stratum without deleting its files:
```bash
# Disable a stratum
sudo brl disable debian

# Re-enable a stratum
sudo brl enable debian
```

### Renaming a Stratum
```bash
sudo brl rename debian debian-bookworm
```

### Removing a Stratum
To permanently delete an unnecessary stratum and free disk space:
```bash
# 1. Disable the stratum first
sudo brl disable alpine

# 2. Remove the stratum from Bedrock
sudo brl remove alpine
```

---

## Next Steps

To maintain your host Arch stratum, configure AUR helpers, and manage kernels safely, proceed to [Step 06: Arch Maintenance & AUR Integration](06-arch-maintenance-and-aur.md).
