#!/bin/bash

set -eu
umask 022

############
# PRE-CHECKS
############
if [ $(uname) != "Linux" ]; then
    echo "This setup script is intended for a Linux host"
    echo "No setup will be done here"
    exit 0;
fi

ROOT="";
if [ $# -gt 0 ]; then
    if [ "$1" == "-norun" ]; then
        echo "This setup script is disabled (norun mode)";
        echo "No setup will be done here";
        exit 0;
    elif [ "$1" == "-chroot" ]; then
        ROOT="$2";
        echo "Change root to $ROOT";
	elif [ "$EUID" -ne 0 ]; then
    	echo "Please run this script as root"
    	exit 1;
    fi
fi

################
# LOAD BASE VARS
################
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
cd "$BASE_DIR";
BIN_DIR="$ROOT/usr/bin";

if [ ! -d "$BIN_DIR" ] ; then
	mkdir -p "$BIN_DIR";
fi
