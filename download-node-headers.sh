#!/bin/bash
set -euxo pipefail

DEST_DIR=deps
NODE_VERSION_DIR=$DEST_DIR/node-$(node --version)
rm -rf $NODE_VERSION_DIR
NODE_HEADERS_URL=$(node -p 'process.release.headersUrl')
URL_ROOT=`dirname "$NODE_HEADERS_URL"`

NODE_HEADERS_TARBALL="$DEST_DIR/"`basename "$NODE_HEADERS_URL"`

# Download, making sure we download to the same output document, without wget
# adding "-1" etc. if the file was previously partially downloaded:
if command -v wget &> /dev/null; then
    wget --quiet --show-progress --output-document=$NODE_HEADERS_TARBALL $NODE_HEADERS_URL
else
    curl --silent --progress-bar --output $NODE_HEADERS_TARBALL $NODE_HEADERS_URL
fi

tar -xf $NODE_HEADERS_TARBALL -C $DEST_DIR
rm $NODE_HEADERS_TARBALL
