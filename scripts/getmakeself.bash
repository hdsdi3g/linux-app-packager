#!/bin/bash

set -eu

if ! [ -x "$(command -v curl)" ]; then
	echo "Error: curl is not installed." >&2
	exit 1
fi

cd $(dirname $0)

if [ ! -f "makeself.sh" ] ; then
    echo "Can't found makeself script, download it now".
	curl https://raw.githubusercontent.com/megastep/makeself/master/makeself.sh > makeself.sh
	curl https://raw.githubusercontent.com/megastep/makeself/master/makeself-header.sh > makeself-header.sh
fi
chmod +x makeself.sh
