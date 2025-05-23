#!/bin/bash

export CFLAGS=-"O2"
export CXXFLAGS="-O2"


PKG_VER=6.14.8
URL=https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$PKG_VER.tar.xz
TAR=$(echo $URL | sed -r 's|(.*)/||')
DIR=$(echo $TAR | sed 's|.tar.*||g')
KERNEL_VERSION=$(echo $DIR | sed 's/linux-//')
PACKAGE=linux-tucana
set -e

# Always use /usr/src
cd /usr/src
wget $URL
tar -xvf $TAR
cd $DIR

# Build

# Copy .config
cp /boot/config-tucana .config
# Add extraversions so that modules directory doesn't confllict with self-builds
sed -i 's/EXTRAVERSION\ =/EXTRAVERSION\ =\ -tucana/' Makefile
make olddefconfig
make -j22

# Install into the proper location

mkdir -p ../$PACKAGE/boot
mkdir -p ../$PACKAGE/usr

make INSTALL_MOD_PATH=../$PACKAGE/usr modules_install

sudo cp arch/x86/boot/bzImage ../$PACKAGE/boot/vmlinuz-$KERNEL_VERSION-tucana
sudo cp .config ../$PACKAGE/boot/config-tucana
sudo rm -r block certs/ crypto/ Documentation/ drivers/ fs/ init/ ipc/ kernel/ lib/ LICENSES/ mm/ MAINTAINERS  modules.* net/ samples/ security/ sound/ usr/ virt/ vmlinux*
cd ../$PACKAGE
echo "cd /boot" > postinst
if [[ $(echo "$KERNEL_VERSION" | sed -n 's/[^.]//g;p' | wc -c) -eq 2 ]]; then
    echo "mkinitramfs $KERNEL_VERSION.0-tucana" >> postinst
else
    echo "mkinitramfs $KERNEL_VERSION-tucana" >> postinst
fi

echo "grub-mkconfig -o /boot/grub/grub.cfg" >> postinst

mkdir -p ../$PACKAGE-headers/usr/src
cd ..
sudo cp -rpv $DIR $PACKAGE-headers/usr/src

# Package

# Setup backup file
cd /usr/src
cd $PACKAGE 
find . -type f | cut -c2- > backup
sed -i '/config-tucana/d'   backup
cd ..

# Move to /pkgs
cd /usr/src
mv $PACKAGE /pkgs
mv $PACKAGE-headers /pkgs
echo "" > /pkgs/$PACKAGE/depend
echo "bc check gcc make bison openssl gawk autoconf" > /pkgs/$PACKAGE/make-depends


# Install
echo "$PACKAGE rsync" > /pkgs/$PACKAGE-headers/depend
cd /pkgs
sudo echo "$PKG_VER" > /pkgs/$PACKAGE/version
tar -cvapf $PACKAGE.tar.xz $PACKAGE
sudo echo "$PKG_VER" > /pkgs/$PACKAGE-headers/version
tar -cvapf $PACKAGE-headers.tar.xz $PACKAGE-headers
cp $PACKAGE.tar.xz /finished
cp $PACKAGE-headers.tar.xz /finished

