#!/bin/bash
# shellcheck disable=SC1091,SC2045

. release

LIB_DIR="$ROOT/usr/lib/jvm/${IMPLEMENTOR_VERSION,,}";

################
# WELCOME ABOARD
################
echo "This setup script is intended for deploy $IMPLEMENTOR $JAVA_VERSION $OS_ARCH static binaries to $LIB_DIR"
echo "This script will extract the application and overwrite it's actual presence (if it was previsonly installed).";
read -n 1 -r -p "Press any key to continue"

##############
# DEPLOY FILES
##############
JAVA_HOME_EMULATE=$(dirname "$(dirname "$(realpath "$(which java)")")");
if [ "$EUID" -eq 0 ] && [ -e "$JAVA_HOME_EMULATE/uninstall.bash" ]; then
	"$JAVA_HOME_EMULATE/uninstall.bash"
fi

if [ -d "$LIB_DIR" ]; then
    echo "Delete old $LIB_DIR directory.";
    rm -rf "$LIB_DIR"
fi

mkdir -p "$LIB_DIR"
cp -R ./* "$LIB_DIR"
chmod -R u=rwX,go=rX,go-w "$LIB_DIR"

if [ "$EUID" -eq 0 ]; then
   	##################
	# SET ALTERNATIVES
	##################
	# Only by root
	# Script inspired by AdopteOpenJDK Debian Archive postinst file
	priority=10000
	UNINSTALL_FILE="$LIB_DIR/uninstall.bash";
	echo "#!/bin/bash" > "$UNINSTALL_FILE";
	for tool in $(ls "$LIB_DIR/bin") ; do
		slave=""
		tool_path="$LIB_DIR/bin/$tool";
		tool_man_path="$LIB_DIR/man/man1/$tool.1"
		if [ -e "$tool_man_path" ]; then
			slave="--slave $ROOT/usr/share/man/man1/$tool.1 $tool.1 $tool_man_path"
		fi
		update-alternatives --install "$ROOT/usr/bin/$tool" "$tool" "$tool_path" "$priority" "$slave"
		echo "update-alternatives --remove \"$tool\" \"$tool_path\"" >> "$UNINSTALL_FILE";
	done
	chmod +x "$UNINSTALL_FILE"
fi

########################
# SET JAVA_HOME VARIABLE
########################

mkdir -p "$ROOT/etc/profile.d"
JAVA_HOME_FILE="$ROOT/etc/profile.d/java-home.sh";
if [ -f "$JAVA_HOME_FILE" ]; then
    echo "Delete old $JAVA_HOME_FILE directory.";
    rm -f "$JAVA_HOME_FILE"
fi
echo "export JAVA_HOME=\"$LIB_DIR\"" > "$JAVA_HOME_FILE"
