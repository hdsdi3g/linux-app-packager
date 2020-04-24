#!/bin/bash

set -eu

if ! [ -x "$(command -v xz)" ]; then
	echo "Error: xz is not installed." >&2
	exit 1
fi

cd $(dirname $0)/..

# Get/check makeself presence
scripts/getmakeself.bash

echo "Start ffmpeg packaging...";

ARCHIVE="redistributables/ffmpeg-release-amd64-static.tar.xz";

# Check archive presence: no archive, no build.
if [ ! -f "$ARCHIVE" ] ; then
    exit 0;
fi

EXTRACTED_PATH=".extracted/ffmpeg";

# Clean actual directory
if [ -d "$EXTRACTED_PATH" ] ; then
	rm -rf "$EXTRACTED_PATH"
fi
# Prepare output directory
mkdir -p "$EXTRACTED_PATH"
# Extract archive in output directory
tar xf "$ARCHIVE" -C "$EXTRACTED_PATH" --strip-components=1

# Check executable presence
if [ ! -f "$EXTRACTED_PATH/ffmpeg" ] ; then
    echo "Can't found ffmpeg binary in $ARCHIVE. Please check it."
    exit 2;
fi
chmod +x "$EXTRACTED_PATH/ffmpeg"

if [ ! -f "$EXTRACTED_PATH/ffprobe" ] ; then
    echo "Can't found ffprobe binary in $ARCHIVE. Please check it."
    exit 2;
fi
chmod +x "$EXTRACTED_PATH/ffprobe"

if [ ! -f "$EXTRACTED_PATH/qt-faststart" ] ; then
    echo "Can't found qt-faststart binary in $ARCHIVE. Please check it."
    exit 2;
fi
chmod +x "$EXTRACTED_PATH/qt-faststart"

# Copy setup script in output directory
BASE_SETUP_NAME="setup-linux-base.bash";
SETUP_NAME="setup-linux-ffmpeg.bash";
cat "scripts/$BASE_SETUP_NAME" > "$EXTRACTED_PATH/setup.bash"
cat "scripts/$SETUP_NAME" >> "$EXTRACTED_PATH/setup.bash"
chmod +x "$EXTRACTED_PATH/setup.bash"

# Prepare package
PACKAGE_FILE="packages/ffmpeg.run.sh";

if [ -f "$PACKAGE_FILE" ] ; then
    rm -f "$PACKAGE_FILE";
fi

scripts/makeself.sh "$EXTRACTED_PATH" "$PACKAGE_FILE" "ffmpeg amd64 static binaries" "./setup.bash"

chmod +x "$PACKAGE_FILE"
