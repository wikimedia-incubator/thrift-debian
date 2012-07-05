This repository exists for building thrift deb packages
for the Wikimedia Foundation.

deb packages in deb/ were built on amd64 Ubuntu 10.04.4 LTS

## To Build
  ./build.sh [thrift|fb303|all] [thrift_version]
or just 
  ./build.sh
which is equivalent to 
  ./build.sh all 0.2.0


## Notes
thrift-0.8.0 was downloaded from http://www.apache.org/dyn/closer.cgi?path=/thrift/0.8.0/thrift-0.8.0.tar.gz.  Modifications were made to debian rules and control files, as well as java build.xml files to build the final deb packages. 

thrift-0.2.0 was originally cloned from https://github.com/simplegeo/thrift.  thrift-0.2.0/contrib/fb303/debian was copied from the debian directory included with 0.8.0 in thrift-0.8.0/contrib/fb303/debian.  rules and control files were modified, as well as java build.xml files. 