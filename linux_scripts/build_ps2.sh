#!/bin/bash
SCRIPT_DIR=$(dirname "$(realpath "$0")")
find "$SCRIPT_DIR/../build/ps2/deluxe" -type f -exec rm -f {} \;
rm -rf "$SCRIPT_DIR/../build/ps2/deluxe"
echo "Building Guitar Hero 3 Deluxe files..."
honeycomb pak compile "$SCRIPT_DIR/../_qb" -g gh3 -c ps2
mkdir -p "$SCRIPT_DIR/../build/ps2/deluxe"
mv "$SCRIPT_DIR/../_qb.pak.ps2" "$SCRIPT_DIR/../build/ps2/deluxe/gh3dx.pak.ps2"
echo "Created Guitar Hero 3 Deluxe files."
echo "Complete! Copy the contents of the ps2 folder in build into your GH3 extracted WAD folder."