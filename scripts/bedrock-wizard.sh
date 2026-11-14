#!/usr/bin/env bash
#
# bedrock-wizard.sh
# Interactive Bedrock Linux Distro Selection & Hijack Installation Assistant
#

set -euo pipefail

# ANSI Color Codes
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

clear_screen() {
    clear 2>/dev/null || true
}

header() {
    echo -e "${CYAN}${BOLD}========================================================================${NC}"
    echo -e "${CYAN}${BOLD}       Bedrock Linux 0.7 (Poki) - Interactive Selection & Install       ${NC}"
    echo -e "${CYAN}${BOLD}========================================================================${NC}"
    echo
}

pause() {
    echo
    read -rp "Press [Enter] to return to the menu..."
}

# -------------------------------------------------------------
# Module 1: Interactive Feature-Based Distro Matchmaker
# -------------------------------------------------------------
run_distro_matchmaker() {
    clear_screen
    header
    echo -e "${BOLD}🎯 Feature-Based Distro Matchmaker Quiz${NC}"
    echo "Answer the following questions to determine the optimal host base distro for your needs."
    echo

    # Initialize scores
    score_arch=0
    score_debian=0
    score_ubuntu=0
    score_void=0
    score_alpine=0
    score_fedora=0

    # Question 1: Primary Use Case
    echo -e "${YELLOW}${BOLD}[Question 1/5] What is the primary purpose of this machine?${NC}"
    echo "  1) High-Performance Gaming & Modern Desktop Workstation"
    echo "  2) Rock-Solid Server, Homelab, or 24/7 Production Workstation"
    echo "  3) Standard Desktop with Commercial Tooling & Broad Hardware Compatibility"
    echo "  4) Fast, Lightweight, Non-Systemd Desktop or Laptop"
    echo "  5) Minimalist, Low-RAM Embedded Box or Tiny Virtual Machine"
    echo "  6) Modern Enterprise Linux Workstation (Red Hat / Fedora ecosystem)"
    read -rp "Select option [1-6]: " q1
    case "$q1" in
        1) ((score_arch+=4)); ((score_fedora+=2)) ;;
        2) ((score_debian+=5)); ((score_ubuntu+=2)) ;;
        3) ((score_ubuntu+=5)); ((score_debian+=2)) ;;
        4) ((score_void+=5)); ((score_alpine+=2)) ;;
        5) ((score_alpine+=5)); ((score_void+=3)) ;;
        6) ((score_fedora+=5)); ((score_arch+=2)) ;;
        *) ((score_arch+=1)); ((score_debian+=1)) ;;
    esac
    echo

    # Question 2: Kernel & Update Model
    echo -e "${YELLOW}${BOLD}[Question 2/5] What kernel and update philosophy do you prefer?${NC}"
    echo "  1) Rolling Bleeding-Edge: I want the absolute newest Linux kernel and Mesa drivers."
    echo "  2) Point-Release LTS: I want rock-solid stability where updates never break drivers."
    echo "  3) Modern 6-Month Cadence: Fresh upstream packages with structured releases."
    echo "  4) Independent Rolling: Fast rolling updates without the complexity of systemd."
    read -rp "Select option [1-4]: " q2
    case "$q2" in
        1) ((score_arch+=4)); ((score_void+=2)) ;;
        2) ((score_debian+=4)); ((score_ubuntu+=4)) ;;
        3) ((score_fedora+=4)); ((score_ubuntu+=2)) ;;
        4) ((score_void+=4)); ((score_alpine+=2)) ;;
        *) ((score_arch+=1)) ;;
    esac
    echo

    # Question 3: Init System
    echo -e "${YELLOW}${BOLD}[Question 3/5] Which init system do you want managing host hardware?${NC}"
    echo "  1) systemd (Default standard, universal service support)"
    echo "  2) runit (Ultra-fast 2-second boot, simple supervision, no systemd)"
    echo "  3) OpenRC (Traditional script-based runlevels, minimal footprint)"
    echo "  4) No preference / Whichever works best"
    read -rp "Select option [1-4]: " q3
    case "$q3" in
        1) ((score_arch+=2)); ((score_debian+=2)); ((score_ubuntu+=2)); ((score_fedora+=2)) ;;
        2) ((score_void+=6)) ;;
        3) ((score_alpine+=6)) ;;
        4) ((score_arch+=1)); ((score_debian+=1)); ((score_ubuntu+=1)) ;;
        *) ;;
    esac
    echo

    # Question 4: GPU & Hardware Drivers
    echo -e "${YELLOW}${BOLD}[Question 4/5] What is your GPU / hardware setup?${NC}"
    echo "  1) Brand new GPU (NVIDIA RTX 40/50 series, AMD RX 7000/8000, Intel Arc)"
    echo "  2) Well-supported modern desktop/laptop GPU or integrated graphics"
    echo "  3) Older hardware, low-spec machine (<4 GB RAM), or headless VM"
    echo "  4) Enterprise GPU requiring proprietary CUDA / ROCm binary blobs"
    read -rp "Select option [1-4]: " q4
    case "$q4" in
        1) ((score_arch+=4)); ((score_fedora+=2)) ;;
        2) ((score_ubuntu+=3)); ((score_fedora+=3)); ((score_debian+=2)) ;;
        3) ((score_void+=4)); ((score_alpine+=4)); ((score_debian+=2)) ;;
        4) ((score_ubuntu+=5)); ((score_debian+=3)) ;;
        *) ;;
    esac
    echo

    # Question 5: Desired Core Packaging Feature
    echo -e "${YELLOW}${BOLD}[Question 5/5] Which packaging feature matters most for your host?${NC}"
    echo "  1) Arch User Repository (AUR) for unlimited software compilation"
    echo "  2) Huge, reliable Debian/Ubuntu .deb binary package repositories"
    echo "  3) Blazing-fast XBPS package manager with minimal bloat"
    echo "  4) Ultra-light APK packages on musl-libc"
    echo "  5) Modern DNF, RPM ecosystem, and Flatpak integration"
    read -rp "Select option [1-5]: " q5
    case "$q5" in
        1) ((score_arch+=5)) ;;
        2) ((score_debian+=3)); ((score_ubuntu+=3)) ;;
        3) ((score_void+=5)) ;;
        4) ((score_alpine+=5)) ;;
        5) ((score_fedora+=5)) ;;
        *) ;;
    esac
    echo

    # Calculate best match
    best_distro="Arch Linux"
    highest_score=$score_arch
    guide_file="docs/03-hijack-installation.md"

    if (( score_debian > highest_score )); then
        best_distro="Debian Stable"
        highest_score=$score_debian
        guide_file="docs/hijack-debian-ubuntu.md"
    fi
    if (( score_ubuntu > highest_score )); then
        best_distro="Ubuntu LTS"
        highest_score=$score_ubuntu
        guide_file="docs/hijack-debian-ubuntu.md"
    fi
    if (( score_void > highest_score )); then
        best_distro="Void Linux"
        highest_score=$score_void
        guide_file="docs/hijack-void-alpine.md"
    fi
    if (( score_alpine > highest_score )); then
        best_distro="Alpine Linux"
        highest_score=$score_alpine
        guide_file="docs/hijack-void-alpine.md"
    fi
    if (( score_fedora > highest_score )); then
        best_distro="Fedora Workstation"
        highest_score=$score_fedora
        guide_file="docs/hijack-fedora.md"
    fi

    # Display Results
    echo -e "${GREEN}${BOLD}========================================================================${NC}"
    echo -e "${GREEN}${BOLD}              🏆 RECOMMENDED BASE DISTRO: ${best_distro}                 ${NC}"
    echo -e "${GREEN}${BOLD}========================================================================${NC}"
    echo
    echo "Detailed Score Breakdown:"
    printf "  • %-18s : %2d points\n" "Arch Linux" "$score_arch"
    printf "  • %-18s : %2d points\n" "Debian Stable" "$score_debian"
    printf "  • %-18s : %2d points\n" "Ubuntu LTS" "$score_ubuntu"
    printf "  • %-18s : %2d points\n" "Void Linux" "$score_void"
    printf "  • %-18s : %2d points\n" "Alpine Linux" "$score_alpine"
    printf "  • %-18s : %2d points\n" "Fedora" "$score_fedora"
    echo
    echo -e "${BOLD}Why this distro is recommended for you:${NC}"
    case "$best_distro" in
        "Arch Linux")
            echo "  ✓ Latest Linux kernel releases ensure full support for modern GPUs and Wi-Fi."
            echo "  ✓ Direct access to pacman and the AUR for cutting-edge software."
            echo "  ✓ Standard systemd environment with zero compatibility issues in Bedrock."
            echo "  💡 Recommended Stratum Pairing: Fetch 'debian' for stable legacy tools."
            ;;
        "Debian Stable")
            echo "  ✓ Rock-solid stability; kernel and drivers will not break under sudden updates."
            echo "  ✓ Proven track record for servers, homelabs, and long-term workstations."
            echo "  💡 Recommended Stratum Pairing: Fetch 'arch' for newest desktop apps or AUR."
            ;;
        "Ubuntu LTS")
            echo "  ✓ Best-in-class commercial hardware support and proprietary driver installers."
            echo "  ✓ Native ZFS-on-root and enterprise cloud/tooling support."
            echo "  💡 Recommended Stratum Pairing: Fetch 'arch' for gamescope/AUR packages."
            ;;
        "Void Linux")
            echo "  ✓ Ultra-fast boots with runit init, avoiding systemd overhead entirely."
            echo "  ✓ Independent rolling release with blazing-fast XBPS package manager."
            echo "  💡 Recommended Stratum Pairing: Fetch 'debian' or 'arch' for broad application support."
            ;;
        "Alpine Linux")
            echo "  ✓ Tiny memory footprint (<50MB idle) and lightweight OpenRC init."
            echo "  ✓ Ideal for minimal appliances, containers, or constrained hardware."
            echo "  💡 Recommended Stratum Pairing: Fetch 'debian' immediately to provide glibc runtime."
            ;;
        "Fedora Workstation")
            echo "  ✓ Modern Wayland/GNOME stack with bleeding-edge upstream tools."
            echo "  ✓ Robust SELinux and enterprise-level developer tooling."
            echo "  💡 Remember: SELinux must be set to 'Permissive' before running the hijack!"
            ;;
    esac
    echo
    echo -e "${CYAN}Read the complete installation guide: ${BOLD}${guide_file}${NC}"
    pause
}

# -------------------------------------------------------------
# Module 2: Pre-Hijack System Compatibility Audit
# -------------------------------------------------------------
run_system_audit() {
    clear_screen
    header
    echo -e "${BOLD}🔍 Pre-Hijack System Compatibility Audit${NC}"
    echo "Inspecting current host environment for Bedrock Linux compatibility..."
    echo

    # 1. Architecture Check
    ARCH=$(uname -m)
    echo -n "Checking CPU architecture ($ARCH)... "
    if [[ "$ARCH" == "x86_64" || "$ARCH" == "aarch64" || "$ARCH" == "armv7l" || "$ARCH" == "i686" ]]; then
        echo -e "${GREEN}[PASS] Supported ($ARCH)${NC}"
    else
        echo -e "${RED}[FAIL] Unsupported architecture: $ARCH${NC}"
    fi

    # 2. Host Distro Identification
    echo -n "Detecting host distribution... "
    if [[ -f /etc/os-release ]]; then
        # shellcheck disable=SC1091
        source /etc/os-release
        echo -e "${GREEN}[PASS] ${PRETTY_NAME:-$ID}${NC}"
    elif [[ -f /etc/arch-release ]]; then
        echo -e "${GREEN}[PASS] Arch Linux${NC}"
    else
        echo -e "${YELLOW}[WARN] Unknown distribution layout${NC}"
    fi

    # 3. Root Filesystem & xattrs
    ROOT_FS=$(stat -f -c %T / 2>/dev/null || df --output=fstype / 2>/dev/null | tail -n 1 | tr -d ' ' || echo "unknown")
    echo -n "Checking root filesystem ($ROOT_FS)... "
    if [[ "$ROOT_FS" =~ ^(ext2/ext3|ext4|btrfs|xfs|f2fs|tmpfs)$ ]]; then
        echo -e "${GREEN}[PASS] $ROOT_FS supports POSIX extended attributes${NC}"
    else
        echo -e "${YELLOW}[WARN] $ROOT_FS may require verification for POSIX xattrs${NC}"
    fi

    # Test xattr write
    TEST_FILE="/tmp/.bedrock_xattr_audit_$$"
    touch "$TEST_FILE"
    if setfattr -n user.bedrock_test -v "ok" "$TEST_FILE" 2>/dev/null; then
        echo -e "Testing xattr write... ${GREEN}[PASS] Verified${NC}"
        rm -f "$TEST_FILE"
    else
        echo -e "Testing xattr write... ${YELLOW}[WARN] setfattr failed or not installed${NC}"
        rm -f "$TEST_FILE"
    fi

    # 4. Free Space
    FREE_MB=$(df --output=avail -m / 2>/dev/null | tail -n 1 | tr -d ' ' || echo "0")
    echo -n "Checking free disk space on / (${FREE_MB} MB)... "
    if (( FREE_MB > 5120 )); then
        echo -e "${GREEN}[PASS] > 5 GB available${NC}"
    else
        echo -e "${YELLOW}[WARN] Less than 5 GB available. May limit extra strata.${NC}"
    fi

    # 5. Core Utilities
    echo -n "Checking download & extraction utilities... "
    missing=()
    for tool in wget curl tar file; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing+=("$tool")
        fi
    done
    if [[ ${#missing[@]} -eq 0 ]]; then
        echo -e "${GREEN}[PASS] All present${NC}"
    else
        echo -e "${YELLOW}[WARN] Missing: ${missing[*]}${NC}"
    fi

    # 6. Check existing Bedrock
    echo -n "Checking for existing /bedrock installation... "
    if [[ -d /bedrock ]]; then
        echo -e "${YELLOW}[ALERT] /bedrock already exists! System is already hijacked.${NC}"
    else
        echo -e "${GREEN}[PASS] Ready for fresh hijack${NC}"
    fi

    pause
}

# -------------------------------------------------------------
# Module 3: Interactive Hijack Assistant
# -------------------------------------------------------------
run_hijack_assistant() {
    clear_screen
    header
    echo -e "${RED}${BOLD}⚠️  Interactive Hijack Assistant ⚠️${NC}"
    echo "Bedrock Linux installs by taking over (hijacking) your existing system."
    echo "This operation reorganizes root directories and replaces init."
    echo -e "${RED}${BOLD}THIS OPERATION IS NOT AUTOMATICALLY REVERSIBLE.${NC}"
    echo

    read -rp "Have you backed up all important files and partitions? (yes/no): " backed_up
    if [[ "$backed_up" != "yes" ]]; then
        echo -e "${YELLOW}Please create a full backup (or VM snapshot) before continuing!${NC}"
        pause
        return
    fi

    ARCH=$(uname -m)
    BEDROCK_VER="0.7.31"
    INSTALLER_SCRIPT="bedrock-linux-${BEDROCK_VER}-${ARCH}.sh"
    DOWNLOAD_URL="https://github.com/bedrocklinux/bedrocklinux-userland/releases/download/${BEDROCK_VER}/${INSTALLER_SCRIPT}"

    echo
    echo -e "Installer version: ${CYAN}${BEDROCK_VER}${NC}"
    echo -e "Target architecture: ${CYAN}${ARCH}${NC}"
    echo

    if [[ ! -f "$INSTALLER_SCRIPT" ]]; then
        read -rp "Download installer script from GitHub now? (y/n): " do_download
        if [[ "$do_download" =~ ^[Yy]$ ]]; then
            echo "Downloading $DOWNLOAD_URL ..."
            if command -v wget >/dev/null 2>&1; then
                wget "$DOWNLOAD_URL"
            elif command -v curl >/dev/null 2>&1; then
                curl -LO "$DOWNLOAD_URL"
            else
                echo -e "${RED}Error: Neither wget nor curl found.${NC}"
                pause
                return
            fi
        else
            echo "Download aborted."
            pause
            return
        fi
    else
        echo -e "${GREEN}Found existing installer: ${INSTALLER_SCRIPT}${NC}"
    fi

    echo
    echo "To execute the hijack on this machine, the exact command is:"
    echo -e "  ${BOLD}${CYAN}sudo sh ./${INSTALLER_SCRIPT} --hijack${NC}"
    echo
    read -rp "Do you want to run this command now with sudo? (type 'HIJACK' to confirm, anything else to cancel): " confirm_run
    if [[ "$confirm_run" == "HIJACK" ]]; then
        echo -e "${RED}Launching Bedrock Linux hijack installer...${NC}"
        sudo sh "./${INSTALLER_SCRIPT}" --hijack
    else
        echo "Cancelled. You can run the command manually whenever you are ready."
    fi
    pause
}

# -------------------------------------------------------------
# Module 4: Stratum Pairing Recommendations
# -------------------------------------------------------------
run_stratum_guide() {
    clear_screen
    header
    echo -e "${BOLD}📦 Post-Install Stratum Recommendation Guide${NC}"
    echo "Select your current or planned base distro to view recommended companion strata:"
    echo
    echo "  1) Arch Linux Host"
    echo "  2) Debian Stable Host"
    echo "  3) Ubuntu LTS Host"
    echo "  4) Void Linux Host"
    echo "  5) Alpine Linux Host"
    echo "  6) Fedora Host"
    echo "  7) Return to Main Menu"
    read -rp "Select option [1-7]: " host_choice
    echo

    case "$host_choice" in
        1)
            echo -e "${CYAN}${BOLD}Base: Arch Linux${NC}"
            echo "• Fetch 'debian' (Bookworm): sudo brl fetch debian"
            echo "  Use case: Rock-solid production daemons, stable toolchains, or legacy deb software."
            echo "• Fetch 'alpine': sudo brl fetch alpine"
            echo "  Use case: Ultra-lightweight sandbox environments and scripts."
            ;;
        2)
            echo -e "${CYAN}${BOLD}Base: Debian Stable${NC}"
            echo "• Fetch 'arch': sudo brl fetch arch"
            echo "  Use case: Instant access to cutting-edge desktop software and AUR packages via pacman."
            echo "• Fetch 'fedora': sudo brl fetch fedora"
            echo "  Use case: Modern RPM packages and updated developer stacks."
            ;;
        3)
            echo -e "${CYAN}${BOLD}Base: Ubuntu LTS${NC}"
            echo "• Fetch 'arch': sudo brl fetch arch"
            echo "  Use case: Install packages missing from Ubuntu repos via the AUR."
            echo "• Fetch 'void': sudo brl fetch void"
            echo "  Use case: Lightweight CLI tools without canonical snaps."
            ;;
        4)
            echo -e "${CYAN}${BOLD}Base: Void Linux (runit)${NC}"
            echo "• Fetch 'arch': sudo brl fetch arch"
            echo "  Use case: Augment Void's curated repository with the full Arch User Repository."
            echo "• Fetch 'debian': sudo brl fetch debian"
            echo "  Use case: Standard .deb packaging and proprietary third-party software."
            ;;
        5)
            echo -e "${CYAN}${BOLD}Base: Alpine Linux (musl + OpenRC)${NC}"
            echo "• Fetch 'debian' or 'arch' (MANDATORY for glibc apps):"
            echo "  sudo brl fetch debian"
            echo "  Use case: Provides the GNU C Library (glibc) necessary to run Steam, Discord, VS Code."
            ;;
        6)
            echo -e "${CYAN}${BOLD}Base: Fedora${NC}"
            echo "• Fetch 'arch': sudo brl fetch arch"
            echo "  Use case: AUR software not present in Fedora COPR."
            echo "• Fetch 'debian': sudo brl fetch debian"
            echo "  Use case: Direct execution of Debian-specific deb packages."
            ;;
        *)
            return
            ;;
    esac
    pause
}

# -------------------------------------------------------------
# Main Menu Loop
# -------------------------------------------------------------
main() {
    while true; do
        clear_screen
        header
        echo -e "${BOLD}Please choose an option:${NC}"
        echo
        echo -e "  ${CYAN}1)${NC} ${BOLD}Distro Matchmaker Quiz${NC}       (Find the best base distro for your features)"
        echo -e "  ${CYAN}2)${NC} ${BOLD}Pre-Hijack System Audit${NC}      (Test current machine compatibility)"
        echo -e "  ${CYAN}3)${NC} ${BOLD}Interactive Hijack Assistant${NC} (Download and run installer safely)"
        echo -e "  ${CYAN}4)${NC} ${BOLD}Stratum Pairing Guide${NC}        (Discover which distros to mix and match)"
        echo -e "  ${CYAN}5)${NC} ${BOLD}Exit${NC}"
        echo
        read -rp "Enter choice [1-5]: " choice

        case "$choice" in
            1) run_distro_matchmaker ;;
            2) run_system_audit ;;
            3) run_hijack_assistant ;;
            4) run_stratum_guide ;;
            5)
                echo "Exiting Bedrock Linux wizard. Happy tinkering!"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                sleep 1
                ;;
        esac
    done
}

main "$@"
