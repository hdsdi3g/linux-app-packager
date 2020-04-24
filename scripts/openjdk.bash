#!/bin/bash

set -eu

cd $(dirname $0)/..

# Get/check makeself presence
scripts/getmakeself.bash

echo "Start openjdk packaging...";

ARCHIVE=$(find redistributables -name OpenJDK*.tar.gz | sort -r -V | head -1);

# Check archive presence: no archive, no build.
if [ ! -f "$ARCHIVE" ] ; then
    exit 0;
fi

EXTRACTED_PATH=".extracted/openjdk";

# Clean actual directory
if [ -d "$EXTRACTED_PATH" ] ; then
	rm -rf "$EXTRACTED_PATH"
fi
# Prepare output directory
mkdir -p "$EXTRACTED_PATH"
# Extract archive in output directory
tar xf "$ARCHIVE" -C "$EXTRACTED_PATH" --strip-components=1

# Check executable presence
if [ ! -f "$EXTRACTED_PATH/bin/java" ] ; then
    echo "Can't found java bin in $ARCHIVE. Please check it."
    exit 2;
fi

# Copy setup script in output directory
BASE_SETUP_NAME="setup-linux-base.bash";
SETUP_NAME="setup-linux-openjdk.bash";
cat "scripts/$BASE_SETUP_NAME" > "$EXTRACTED_PATH/setup.bash"
cat "scripts/$SETUP_NAME" >> "$EXTRACTED_PATH/setup.bash"
chmod +x "$EXTRACTED_PATH/setup.bash"

# Prepare package
PACKAGE_FILE="packages/openjdk.run.sh";

if [ -f "$PACKAGE_FILE" ] ; then
    rm -f "$PACKAGE_FILE";
fi

scripts/makeself.sh "$EXTRACTED_PATH" "$PACKAGE_FILE" "OpenJDK binaries" "./setup.bash"

chmod +x "$PACKAGE_FILE"
