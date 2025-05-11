#!/bin/bash

export CFLAGS=-"O2"
export CXXFLAGS="-O2"


PKG_VER=22.0.2
URL=https://github.com/openjdk/jdk22u/archive/jdk-$PKG_VER-ga.tar.gz
TAR=$(echo $URL | sed -r 's|(.*)/||')
DIR=jdk22u-jdk-$PKG_VER-ga
PACKAGE=openjdk

# Get Package

cd /blfs/builds
#wget $URL
tar -xvf $TAR
cd $DIR

# Build

# Assuming Java binary is in /opt/java/bin
export PATH=/opt/java/bin:$PATH


unset JAVA_HOME                                       &&
bash configure --enable-unlimited-crypto              \
               --disable-warnings-as-errors           \
               --with-stdc++lib=dynamic               \
               --with-giflib=system                   \
               --with-lcms=system                     \
               --with-libjpeg=system                  \
               --with-libpng=system                   \
               --with-zlib=system                     \
               --with-version-build="9"               \
               --with-version-pre=""                  \
	       --with-jobs=20                         \
               --with-version-opt=""                  \
               --with-cacerts-file=/etc/pki/tls/java/cacerts 


make images


# Install
install -vdm755 /pkgs/$PACKAGE/usr
cp -Rv build/*/images/jdk/* /pkgs/$PACKAGE/usr &&
chown -R root:root /pkgs/$PACKAGE/usr          &&
for s in 16 24 32 48; do
  install -vDm644 src/java.desktop/unix/classes/sun/awt/X11/java-icon${s}.png \
                  /pkgs/$PACKAGE/usr/share/icons/hicolor/${s}x${s}/apps/java.png
done
ln -sfv /etc/pki/tls/java/cacerts /pkgs/$PACKAGE/usr/lib/security/cacerts
cd /pkgs



sudo echo "" > /pkgs/$PACKAGE/depends
sudo echo "" > /pkgs/$PACKAGE/make-depends
sudo echo "$PKG_VER" > /pkgs/$PACKAGE/version
sudo tar -cvapf $PACKAGE.tar.xz $PACKAGE
sudo cp $PACKAGE.tar.xz /finished


cd /blfs/builds
sudo rm -r $DIR


