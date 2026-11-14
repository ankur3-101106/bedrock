#!/usr/bin/env bash
#
# pre-hijack-check.sh
# Diagnostic script to verify a fresh Arch Linux system before Bedrock Linux hijack.
#

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

pass() {
    echo -e " [ ${GREEN}PASS${NC} ] $1"
}

warn() {
    echo -e " [ ${YELLOW}WARN${NC} ] $1"
}

fail() {
    echo -e " [ ${RED}FAIL${NC} ] $1"
}

info() {
    echo -e " [ ${BLUE}INFO${NC} ] $1"
}

echo "=========================================================="
echo "      Bedrock Linux Pre-Hijack Compatibility Checker      "
echo "=========================================================="
echo

# 1. Architecture Check
ARCH=$(uname -m)
info "Checking CPU architecture..."
if [[ "$ARCH" == "x86_64" || "$ARCH" == "aarch64" || "$ARCH" == "armv7l" || "$ARCH" == "i686" ]]; then
    pass "Supported architecture: $ARCH"
else
    fail "Unsupported architecture: $ARCH. Bedrock official installers target x86_64, aarch64, armv7l, i686."
fi

# 2. Host Distro Identification
info "Checking OS distribution..."
if [[ -f /etc/arch-release ]]; then
    pass "Host distribution confirmed as Arch Linux."
else
    warn "Distribution does not appear to be Arch Linux (/etc/arch-release not found)."
fi

# 3. Root Filesystem & Extended Attributes (xattr) Check
info "Checking root filesystem type and extended attribute support..."
ROOT_FS=$(stat -f -c %T / 2>/dev/null || df --output=fstype / 2>/dev/null | tail -n 1 | tr -d ' ' || echo "unknown")
info "Root filesystem: $ROOT_FS"

if [[ "$ROOT_FS" =~ ^(ext2/ext3|ext4|btrfs|xfs|f2fs|tmpfs)$ ]]; then
    pass "Filesystem $ROOT_FS supports POSIX extended attributes."
else
    warn "Filesystem $ROOT_FS may not support POSIX extended attributes. Check Bedrock compatibility docs."
fi

# Test creating an xattr test file in /tmp or /
TEST_FILE="/tmp/.bedrock_xattr_test_$$"
touch "$TEST_FILE"
if setfattr -n user.bedrock_test -v "ok" "$TEST_FILE" 2>/dev/null; then
    pass "Successfully verified POSIX extended attribute write."
    rm -f "$TEST_FILE"
else
    warn "Could not test setfattr (attribute-utils may not be installed). Ensure xattrs are enabled on /."
    rm -f "$TEST_FILE"
fi

# 4. Free Disk Space
info "Checking root partition free space..."
FREE_MB=$(df --output=avail -m / 2>/dev/null | tail -n 1 | tr -d ' ' || echo "0")
if (( FREE_MB > 5120 )); then
    pass "Free space on /: ${FREE_MB} MB (> 5 GB recommended)."
else
    warn "Free space on /: ${FREE_MB} MB. Less than 5 GB available. May constrain additional strata."
fi

# 5. Essential Tools
info "Checking required utilities..."
MISSING_TOOLS=()
for tool in wget curl tar file ca-certificates; do
    if ! command -v "$tool" >/dev/null 2>&1 && [[ ! -d /etc/ssl/certs ]]; then
        MISSING_TOOLS+=("$tool")
    fi
done

if [[ ${#MISSING_TOOLS[@]} -eq 0 ]]; then
    pass "All recommended download and extraction tools are present."
else
    warn "Missing tools: ${MISSING_TOOLS[*]}. Install with: sudo pacman -S --needed ${MISSING_TOOLS[*]}"
fi

# 6. Sudo / Root Privileges
info "Checking administrative privileges..."
if [[ $EUID -eq 0 ]] || sudo -n true 2>/dev/null || command -v sudo >/dev/null 2>&1; then
    pass "Administrative/sudo capabilities detected."
else
    fail "Sudo or root access is required to run the Bedrock hijack installer."
fi

# 7. Check if already hijacked
info "Checking if Bedrock is already installed..."
if [[ -d /bedrock ]]; then
    warn "/bedrock directory already exists! This system may already be hijacked."
else
    pass "Clean environment: /bedrock does not yet exist."
fi

echo
echo "=========================================================="
echo "Pre-hijack checks complete! Review any WARN or FAIL items."
echo "=========================================================="
