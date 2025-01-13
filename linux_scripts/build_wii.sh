#!/bin/bash
SCRIPT_DIR=$(dirname "$(realpath "$0")")
find "$SCRIPT_DIR/../build/wii/files/deluxe" -type f -exec rm -f {} \;
rm -rf "$SCRIPT_DIR/../build/wii/files/deluxe"
echo "Building Guitar Hero 3 Deluxe files..."
honeycomb pak compile "$SCRIPT_DIR/../_qb" -g gh3 -c wii
mkdir -p "$SCRIPT_DIR/../build/wii/files/deluxe"
mv "$SCRIPT_DIR/../_qb.pak.ngc" "$SCRIPT_DIR/../build/wii/files/deluxe/gh3dx.pak.ngc"
echo "Created Guitar Hero 3 Deluxe files."
echo "Complete! Copy the contents of the wii folder in build into your GH3 install folder."