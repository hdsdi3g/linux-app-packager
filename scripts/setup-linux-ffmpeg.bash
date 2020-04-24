#!/bin/bash

LIB_DIR="$ROOT/usr/lib/ffmpeg-static";

################
# WELCOME ABOARD
################
echo "This setup script is intended for deploy ffmpeg amd64 static binaries to $LIB_DIR"
echo "This script will extract the application and overwrite it's actual presence (if it was previsonly installed).";
read -n 1 -r -p "Press any key to continue"

##############
# DEPLOY FILES
##############
if [ -e "$BIN_DIR/ffmpeg" ]; then
    rm -f "$BIN_DIR/ffmpeg"
fi
if [ -d "$LIB_DIR" ]; then
    echo "Delete old $LIB_DIR directory.";
    rm -rf "$LIB_DIR"
fi

mkdir -p "$LIB_DIR"
cp -R * "$LIB_DIR"

chmod -R 755 "$LIB_DIR/ffmpeg"
ln -s "$LIB_DIR/ffmpeg" "$BIN_DIR"
