#!/bin/bash

LIB_DIR="$ROOT/usr/lib/liquibase";

################
# WELCOME ABOARD
################
echo "This setup script is intended for deploy liquibase java binaries to $LIB_DIR"
echo "This script will extract the application and overwrite it's actual presence (if it was previsonly installed).";
read -n 1 -r -p "Press any key to continue"

##############
# DEPLOY FILES
##############
if [ -e "$BIN_DIR/liquibase" ]; then
    rm -f "$BIN_DIR/liquibase"
fi
if [ -d "$LIB_DIR" ]; then
    echo "Delete old $LIB_DIR directory.";
    rm -rf "$LIB_DIR"
fi

mkdir -p "$LIB_DIR"
cp -R * "$LIB_DIR"

chmod -R 755 "$LIB_DIR/liquibase"
ln -s "$LIB_DIR/liquibase" "$BIN_DIR"

#######################
# SETUP AUTO COMPLETION
#######################
BASH_COMPLETION="$ROOT/etc/bash_completion.d/";
mkdir -p "$BASH_COMPLETION";
cp "$LIB_DIR/lib/liquibase_autocomplete.sh" "$BASH_COMPLETION/liquibase";
