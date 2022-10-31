#!/bin/bash
# shellcheck disable=SC1091

. release

LIB_DIR="$ROOT/usr/lib/jvm/$IMPLEMENTOR-$JAVA_VERSION";

################
# WELCOME ABOARD
################
echo "This setup script is intended for deploy $IMPLEMENTOR $JAVA_VERSION $OS_ARCH static binaries to $LIB_DIR"
echo "This script will extract the application and overwrite it's actual presence (if it was previsonly installed).";
read -n 1 -r -p "Press any key to continue"

##############
# DEPLOY FILES
##############
tools="jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jfr jhsdb jimage jinfo jlink jmap jmod jpackage jps jrunscript jshell jstack jstat jstatd keytool rmiregistry serialver"
if [ "$EUID" -eq 0 ]; then
   	####################
	# CLEAN ALTERNATIVES
	####################
	# Only by root
	# Script inspired by AdopteOpenJDK Debian Archive prerm file
	for tool in $tools ; do
		for tool_path in "$LIB_DIR/bin/$tool" "$LIB_DIR/lib/$tool" ; do
			if [ ! -e "$tool_path" ] ; then
				continue
			fi
			update-alternatives --remove "$tool" "$tool_path"
		done
	done
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
	for tool in $tools ; do
		for tool_path in "$LIB_DIR/bin/$tool" "$LIB_DIR/lib/$tool" ; do
			if [ ! -e "$tool_path" ]; then
				continue
			fi
			slave=""
			tool_man_path="$LIB_DIR/man/man1/$tool.1"
			if [ -e "$tool_man_path" ]; then
				slave="--slave $ROOT/usr/share/man/man1/$tool.1 $tool.1 $tool_man_path"
			fi
			update-alternatives --install "$ROOT/usr/bin/$tool" "$tool" "$tool_path" "$priority" $slave
		done
	done
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
