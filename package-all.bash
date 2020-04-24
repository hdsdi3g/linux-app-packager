#!/bin/bash

set -eu

cd $(dirname $0)

scripts/ffmpeg.bash
scripts/liquibase.bash
scripts/openjdk.bash

PACKAGEDIR=$(pwd)/packages;

echo "You will found packages in $PACKAGEDIR directory";
echo "They are now ready to deploy on Linux/WSL host";
echo "";
echo "Usage for a simple autoextract test/check: apackage-run.sh --keep --target \"extracted\" [-- -norun]";
echo "Usage for deploy to another root directory: apackage-run.sh [-- -chroot \"/opt\"]";
