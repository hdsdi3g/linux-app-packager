# Linux-App-Packager readme

Create self-extractible, offline installable packages for Linux, from original tarball files. The self-extractible script is made by [makeself.sh](https://makeself.io/).

Why ? Sometimes, some Linux production servers are disconnected from the Internet and/or some specific packages (by version or type) are not installable directly. 

In other cases, we may need to install a version on top of that provided by the default repositories, while keeping a clean dependency tree (example: some apps need ffmpeg during their installation, package manager installs it automatically, but this version is very old and lacks some codecs).

Finally, for licensing reasons, it is sometimes difficult (when you do things right) to include compiled versions of some applications for redistribution: being able to make your own installer is easily bypass this kind of limitation.

Actually, it support:

- OpenJDK
- [ffmpeg](https://www.ffmpeg.org/download.html)
- [Liquibase](https://download.liquibase.org/download-community/)
- MySQL JDBC Connector (for Liquibase)

Packages are only make for recent Linux disto, Debian/RHEL (and on Windows/WSL) type.

## Needs

For packaging: ``xz``, ``bash``, ``tar``, ``gzip``, ``curl``

For extracting only: ``bash``, ``tar``, ``gzip``, ``md5sum``.

For installation (after extracting):

- sudo/root rights
- update-alternatives (for Java/OpenJDK)

## Usage

Put in ``redistributables`` directory:

- OpenJDKx-jdk_x_linux_x_x.x.x_x.tar.gz
- ffmpeg-release-x-static.tar.xz
- liquibase-3.x.x.tar.gz
- Liquibase JDBC drivers (actually only ``mysql-connector-java-x.x.x.tar.gz`` is supported)

**No one is mandatory.**

### Get MySQL JDBC redistributables

`mysql-connector-java` can be get from official [MySQL site](https://dev.mysql.com/downloads/connector/j/), choose "Platform Independent (Architecture Independent), Compressed TAR Archive"

### Get OpenJDK redistributables

It can be get from [AdoptOpenJDK site](https://adoptopenjdk.net/releases.html) and select:

- a **Version**
- a **JVM type**
- Operating System: **Linux**
- Architecture: x64

And download **JDK** tar.gz file.

### Run scripts

``./package-all.bash`` on Linux/Windows WSL.

And you will get new setup packages on ``packages`` directory.

### Run setups

By default, as root:

``./apackage-run.sh``

Usage for a simple autoextract test/check (no needs to be root):

``./apackage-run.sh --keep --target "extracted" -- -norun``

Usage for deploy to another root directory:

``./apackage-run.sh -- -chroot "/opt"``

## Security reminder

Remember that manually installing applications no longer allows automatic and transparent updates. **You must keep yourself informed of the security updates of the applications that you deploy manually.**

## Roadmap dev

Free feel to add corrections and/or new features (it's really not rocket science).

Actually, there are not "uninstall script" provided. This is something that could be done if needed (not to mention that it's impossible to do a clean _and_ safe de-installation with this basic installation method).
