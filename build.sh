#!/bin/bash

# This repository exists for building thrift deb packages
# for the Wikimedia Foundation.

# To build debs:

# Set thrift version to the version you'd like to build
THRIFT_VERSION="0.8.0"
repo_root="${PWD}"
cd thrift-${THRIFT_VERSION}


## Build thrift packages
echo "Building thrift packages..."
dpkg-buildpackage

# This should build:
# - libthrift0_0.8.0_amd64.deb
# - libthrift-cil_0.8.0_all.deb
# - libthrift-dev_0.8.0_amd64.deb
# - libthrift-erlang_0.8.0_all.deb
# - libthrift-java_0.8.0_all.deb
# - libthrift-perl_0.8.0_all.deb
# - libthrift-ruby_0.8.0_amd64.deb
# - php5-thrift_0.8.0_amd64.deb
# - python-thrift_0.8.0_amd64.deb
# - python-thrift-dbg_0.8.0_amd64.deb
# - thrift-compiler_0.8.0_amd64.deb

cd ${repo_root}
echo "Built these .deb files:"
ls ./*.deb

  
## Build thrift-fb303 packages
cd ${repo_root}/thrift-$THRIFT_VERSION/contrib/fb303
echo "Building fb303 packages..."
dpkg-buildpackage

# This should builds:
# - python-fb303_0.8.0_amd64.deb
# - libfb303-java_0.8.0_amd64.deb
# - thrift-fb303_0.8.0_amd64.deb
cd ..
echo "Built these .deb files:"
ls ./*.deb

# Now move the created .deb, .changes, .dsc, and source files into deb/

cd $repo_root
mkdir -p deb
mv -v {${repo_roo},${repo_root}/thrift-${THRIFT_VERSION}}/*{.deb,dsc,changes,${THRIFT_VERSION}.tar.gz} ${repo_root}/deb/

echo "If you are ready, now commit and push your changes".