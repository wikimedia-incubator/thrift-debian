#!/bin/bash

# This repository exists for building thrift deb packages
# for the Wikimedia Foundation.


# Must be root to install packages
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# package architecture (probably amd64)
DEB_BUILD_ARCH=$(dpkg-architecture -qDEB_BUILD_ARCH | cut -d ';' -f 1)

# package to build, either thrift, fb303, or all.
packages=$1
if [ -z $packages ]; then
	packages="all"
fi

# The thrift version to the version to build.  Must be at thrift-$THRIFT_VERSION
thrift_version=${2}
: ${thrift_version:="0.2.0"} # default to 0.2.0

# The repository root.
repo_root="$(readlink -f $(dirname $0))"
thrift_directory="${repo_root}/thrift-${thrift_version}"


function build_thrift {
	## Build thrift packages
	echo "Building thrift packages..."

	cd $thrift_directory
	dpkg-buildpackage

	# This should build:
	# - libthrift0_${thrift_version}_${DEB_BUILD_ARCH}.deb
	# - libthrift-cil_${thrift_version}_all.deb
	# - libthrift-dev_${thrift_version}_${DEB_BUILD_ARCH}.deb
	# - libthrift-java_${thrift_version}_all.deb
	# - libthrift-perl_${thrift_version}_all.deb
	# - libthrift-ruby_${thrift_version}_${DEB_BUILD_ARCH}.deb
	# - php5-thrift_${thrift_version}_${DEB_BUILD_ARCH}.deb
	# - python-thrift_${thrift_version}_${DEB_BUILD_ARCH}.deb
	# - python-thrift-dbg_${thrift_version}_${DEB_BUILD_ARCH}.deb
	# - thrift-compiler_${thrift_version}_${DEB_BUILD_ARCH}.deb

	cd ${repo_root}
	echo "Built these .deb files:"
	ls ./*.deb
	mkdir -p deb
	mv ${repo_root}/*{.deb,dsc,changes,${thrift_version}.tar.gz} ${repo_root}/deb/
}

function build_fb303
{
	## Build thrift-fb303 packages
	# We need to install libthrift0, libthrift-dev, thrift-compiler, 
	# and python-thrift in order to compile fb303.  Go ahead and install
	# these from the newly created debs.
	echo "Installing newly created debs for libthrift0, libthrift-dev, thrift-compiler, libthrift-java and python-thrift in order to install create fb303 packages."
	# uninstall these packages first
	dpkg -r libthrift0 thrift-compiler libthrift-dev python-thrift libthrift-java
	dpkg -i ${repo_root}/deb/{libthrift0_${thrift_version}*,thrift-compiler_${thrift_version}*,libthrift-dev_${thrift_version},python-thrift_${thrift_version},libthrift-java_${thrift_version}}*.deb || (echo "Could not install dependencies for fb303 packages." && exit 1)

	echo "Building fb303 packages..."
	cd ${thrift_directory}/contrib/fb303
	dpkg-buildpackage

	# This should builds:
	# - python-fb303_${thrift_version}_${DEB_BUILD_ARCH}.deb
	# - libfb303-java_${thrift_version}_${DEB_BUILD_ARCH}.deb
	# - thrift-fb303_${thrift_version}_${DEB_BUILD_ARCH}.deb
	cd ..
	echo "Built these .deb files:"
	ls ./*.deb

	# Now move the created .deb, .changes, .dsc, and source files into deb/

	cd $repo_root
	mv -v ${thrift_directory}/contrib/*{.deb,dsc,changes,${thrift_version}.tar.gz} ${repo_root}/deb/
}



case $packages in
	thrift )
		echo "Building thrift packages"
		build_thrift 
		;;
	fb303 )
		echo "Building fb303 packages"
		build_fb303 
		;;
	all )
		echo "Building thrift and fb303 packages"
		build_thrift;
		build_fb303;
		;;
	* ) echo -e "\n  Usage: $0 [thrift|fb303|all] [thrift_version]\n  or just $0, which is equivalent to $0 all ${thrift_version}\n"
esac