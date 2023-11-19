#!/bin/bash
# Author of install script: TheBossT710192
# Note: Oversteer is NOT my program. Many thanks to the folks who made this program and have contributed to it!
# Oversteer repository: https://github.com/berarma/oversteer

#disabling read-only permission
steamos-readonly disable

#installing packages
pacman -S python python-pip python-numpy ninja blas

#dependencies needed for Oversteer
pacman -S python-gobject python-pyudev python-pyxdg python-evdev gettext meson appstream-glib desktop-file-utils python-matplotlib python-scipy

#more installing
pacman -S python-cycler python-fonttools python-kiwisolver python-packaging python-pillow python-pyparsing python-dateutil python-cairo python-cairocffi lapack

#upgrading some stuff for extra measure
pip install --upgrade numpy
pip install --upgrade matplotlib

#allowing usb input of steering wheel
sudo pacman -S usb_modeswitch

#installing Oversteer
git clone https://github.com/berarma/oversteer.git
cd oversteer

#Prepare build system
meson build
cd build

#installing
ninja install

#Print install completed message
zenity --info --text="Install of Oversteer has been completed! Please restart your Steam Deck for Oversteer to begin to work properly!" --width=300
