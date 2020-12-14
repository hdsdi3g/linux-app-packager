#!/bin/bash

set -eu

cd "$(dirname "$0")"/..

# Get/check makeself presence
scripts/getmakeself.bash

echo "Start liquibase packaging...";

ARCHIVE=$(find redistributables -name "liquibase-*.tar.gz" | sort -r -V | head -1);

# Check archive presence: no archive, no build.
if [ ! -f "$ARCHIVE" ] ; then
    exit 0;
fi

EXTRACTED_PATH=".extracted/liquibase";

# Clean actual directory
if [ -d "$EXTRACTED_PATH" ] ; then
	rm -rf "$EXTRACTED_PATH"
fi
# Prepare output directory
mkdir -p "$EXTRACTED_PATH"
# Extract archive in output directory
tar xf "$ARCHIVE" -C "$EXTRACTED_PATH"

# Check executable presence
if [ ! -f "$EXTRACTED_PATH/liquibase" ] ; then
    echo "Can't found liquibase startup script in $ARCHIVE. Please check it."
    exit 2;
fi
chmod +x "$EXTRACTED_PATH/liquibase"

# Try and extract JDBC Drivers
# MySQL
ARCHIVE_MYSQL=$(find redistributables -name "mysql-connector-java-*.tar.gz" | sort -r -V | head -1);
if [ -f "$ARCHIVE_MYSQL" ] ; then
	echo "Extract MySQL JDBC Driver to Liquibase lib dir"
	JDBC_EXTRACTED_PATH=".extracted/jdbc";
	if [ -d "$JDBC_EXTRACTED_PATH" ] ; then
		rm -rf "$JDBC_EXTRACTED_PATH"
	fi
	mkdir -p "$JDBC_EXTRACTED_PATH"
    tar xf "$ARCHIVE_MYSQL" -C "$JDBC_EXTRACTED_PATH" --strip-components=1
	JAR_MYSQL=$(find "$JDBC_EXTRACTED_PATH" -name "mysql-connector-java-*.jar" | head -1);
	mv "$JAR_MYSQL" "$EXTRACTED_PATH/lib/"
else
	echo "Please put in $(realpath $EXTRACTED_PATH/lib/) any necessary JDBC Driver (Jar files) for your Liquibase needs";
	read -n 1 -r -p "Press any key to continue the packaging (no verifications will be done)"
fi

# Copy setup script in output directory
BASE_SETUP_NAME="setup-linux-base.bash";
SETUP_NAME="setup-linux-liquibase.bash";
cat "scripts/$BASE_SETUP_NAME" > "$EXTRACTED_PATH/setup.bash"
cat "scripts/$SETUP_NAME" >> "$EXTRACTED_PATH/setup.bash"
chmod +x "$EXTRACTED_PATH/setup.bash"

# Prepare package
PACKAGE_FILE="packages/liquibase.run.sh";

if [ -f "$PACKAGE_FILE" ] ; then
    rm -f "$PACKAGE_FILE";
fi

scripts/makeself.sh \
    --tar-extra "--owner=root --group=root --no-xattrs --no-acls --no-selinux" \
    --nooverwrite \
	"$EXTRACTED_PATH" "$PACKAGE_FILE" "liquibase java binaries" "./setup.bash"

chmod +x "$PACKAGE_FILE"
