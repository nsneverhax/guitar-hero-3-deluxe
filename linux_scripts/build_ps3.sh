#!/bin/bash
# this is extremely hacky as building for ps3 on linux is broken. thisll do for now
SCRIPT_DIR=$(dirname "$(realpath "$0")")
find "$SCRIPT_DIR/../build/ps3/DATA/DELUXE" -type f -exec rm -f {} \;
rm -rf "$SCRIPT_DIR/../build/ps3/DATA/DELUXE"
echo "Building Guitar Hero 3 Deluxe files..."
cp -r "$SCRIPT_DIR/../_qb" "$SCRIPT_DIR/_QB"
honeycomb pak compile "_QB/" -g gh3 -c ps3
mkdir -p "$SCRIPT_DIR/../build/ps3/DATA/DELUXE"
mv "_QB/..PAK.PS3" "$SCRIPT_DIR/../build/ps3/DATA/DELUXE/GH3DX.PAK.PS3"
cp "$SCRIPT_DIR/../build/ps3/DATA/DELUXE/GH3DX.PAK.PS3" "$SCRIPT_DIR/../build/ps3/DATA/DELUXE/GH3DX_VRAM.PAK.PS3"
rm -rf "$SCRIPT_DIR/_QB"
echo "Created Guitar Hero 3 Deluxe files."
echo "Complete! Copy the contents of the ps3 folder in build into your GH3 Disc folder."