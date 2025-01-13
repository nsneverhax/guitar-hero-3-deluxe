#!/bin/bash
SCRIPT_DIR=$(dirname "$(realpath "$0")")
find "$SCRIPT_DIR/../build/pc/DATA/DELUXE" -type f -exec rm -f {} \;
rm -rf "$SCRIPT_DIR/../build/pc/DATA/DELUXE"
echo "Building Guitar Hero 3 Deluxe files..."
honeycomb pak compile "$SCRIPT_DIR/../_qb" -g gh3 -c pc
mkdir -p "$SCRIPT_DIR/../build/pc/DATA/DELUXE"
mv "$SCRIPT_DIR/../_qb.pak.xen" "$SCRIPT_DIR/../build/pc/DATA/DELUXE/gh3dx.pak.xen"
echo "Created Guitar Hero 3 Deluxe files."
echo "Complete! Copy the contents of the pc folder in build into your GH3 install folder."