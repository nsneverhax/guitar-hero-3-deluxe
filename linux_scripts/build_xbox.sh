#!/bin/bash
cd ..
SCRIPT_DIR=$(dirname "$(realpath "$0")")
find "$SCRIPT_DIR/build/xbox/DATA/DELUXE" -type f -exec rm -f {} \;
rm -rf "$SCRIPT_DIR/build/xbox/DATA/DELUXE"
echo "Building Guitar Hero 3 Deluxe files..."
dependencies/linux/Honeycomb-CLI/Honeycomb pak compile "$SCRIPT_DIR/_qb" -g gh3 -c xbox
mkdir -p "$SCRIPT_DIR/build/xbox/DATA/DELUXE"
mv "$SCRIPT_DIR/_qb.pak.xen" "$SCRIPT_DIR/build/xbox/DATA/DELUXE/gh3dx.pak.xen"
echo "Created Guitar Hero 3 Deluxe files."
echo "Complete! Copy the contents of the xbox folder in build into your GH3 install folder."