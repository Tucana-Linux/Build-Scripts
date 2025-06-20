#!/bin/bash
set -e
# Building Depends
sudo neptune install --y URI lmdb
bash -e ecm
bash -e libdbusmenu-qt
bash -e polkit-qt
bash -e polkit-qt5
bash -e phonon
#bash -e phonon-backend-vlc
bash -e plasma-wayland-protocols
sudo bash -e qca
# Plasma5-limited
cd plasma5-limited
bash -e build_plasma5_limited.sh
cd ..
# KF6
cd kf6
bash -e build_kf6.sh
cd ..
sudo bash -e kirigami-addons
sudo bash -e pulseaudio-qt
# Desktop
cd plasma
 bash -e build_plasma.sh
cd ..
# Apps
sudo bash -e poppler
cd plasma-apps
bash -e build_plasma_apps.sh
