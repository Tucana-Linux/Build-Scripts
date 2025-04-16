#!/bin/bash
sed -i 's/\$GNOME_MAJOR\.\$GNOME_MINOR/\$PKG_VER/g' $1
sed -i 's/GNOME_MINOR=.*/MAJOR=\$(echo \$PKG_VER | sed "s\|\.\[\^\.\]\*\$\|\|g")/' $1
sed -i 's/GNOME_MAJOR=.*/PKG_VER=/g' $1
sed -i 's/GNOME_MAJOR/MAJOR/g' $1

