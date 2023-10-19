#!/bin/bash
set -euxo pipefail

DEST_DIR=deps
NODE_VERSION_DIR=$DEST_DIR/node-$(node --version)
rm -rf $NODE_VERSION_DIR/win-x64
mkdir -p $NODE_VERSION_DIR/win-x64
# rm -rf $NODE_VERSION_DIR/win-x86
# mkdir -p $NODE_VERSION_DIR/win-x86

NODE_HEADERS_URL=$(node -p 'process.release.headersUrl')
URL_ROOT=`dirname "$NODE_HEADERS_URL"`

NODE_WIN_X64_EXE_URL="$URL_ROOT/win-x64/node.exe"
NODE_WIN_X64_LIB_URL="$URL_ROOT/win-x64/node.lib"
# NODE_WIN_X86_EXE_URL="$URL_ROOT/win-x86/node.exe"
# NODE_WIN_X86_LIB_URL="$URL_ROOT/win-x86/node.lib"

NODE_WIN_X64_EXE="$NODE_VERSION_DIR/win-x64/node.exe"
NODE_WIN_X64_LIB="$NODE_VERSION_DIR/win-x64/node.lib"
# NODE_WIN_X86_EXE="$NODE_VERSION_DIR/win-x86/node.exe"
# NODE_WIN_X86_LIB="$NODE_VERSION_DIR/win-x86/node.lib"

# Download, making sure we download to the same output document, without wget
# adding "-1" etc. if the file was previously partially downloaded:
if command -v wget &> /dev/null; then
    wget --quiet --show-progress --output-document=$NODE_WIN_X64_EXE $NODE_WIN_X64_EXE_URL
    wget --quiet --show-progress --output-document=$NODE_WIN_X64_LIB $NODE_WIN_X64_LIB_URL
    # wget --quiet --show-progress --output-document=$NODE_WIN_X86_EXE $NODE_WIN_X86_EXE_URL
    # wget --quiet --show-progress --output-document=$NODE_WIN_X86_LIB $NODE_WIN_X86_LIB_URL
else
    curl --silent --progress-bar --output $NODE_WIN_X64_EXE $NODE_WIN_X64_EXE_URL
    curl --silent --progress-bar --output $NODE_WIN_X64_LIB $NODE_WIN_X64_LIB_URL
    # curl --silent --progress-bar --output $NODE_WIN_X86_EXE $NODE_WIN_X86_EXE_URL
    # curl --silent --progress-bar --output $NODE_WIN_X86_LIB $NODE_WIN_X86_LIB_URL
fi
