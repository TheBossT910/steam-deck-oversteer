#!/bin/bash
# TESTING CODE... BETA, NOT FINAL
# Author of install script: TheBossT710192
# Note: Oversteer is NOT my program. Many thanks to the folks who made this program and have contributed to it!
# Oversteer repository: https://github.com/berarma/oversteer

# Check for root/sudo privileges
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root or with sudo."
   exit 1
fi

# Function to check if a package is installed
check_package() {
    if pacman -Qs "$1" >/dev/null 2>&1; then
        echo "$1 is already installed."
        return 0  # Package is installed
    else
        echo "$1 is not installed."
        return 1  # Package is not installed
    fi
}

# Function to install a package
install_package() {
    echo "Installing $1..."
    if pacman -S --noconfirm "$1"; then
        echo "$1 installed successfully."
    else
        echo "Error installing $1. Exiting."
        exit 1
    fi
}

# Function to check and upgrade pip packages
upgrade_pip_packages() {
    echo "Upgrading pip packages..."
    if pip install --no-cache-dir --upgrade numpy matplotlib; then
        echo "Pip packages upgraded successfully."
    else
        echo "Error upgrading pip packages. Exiting."
        exit 1
    fi
}

# Disabling read-only permission
steamos-readonly disable

# Installing packages
packages=("python" "python-pip" "python-numpy" "ninja" "blas" "python-gobject" "python-pyudev" "python-pyxdg" "python-evdev" "gettext" "meson" "appstream-glib" "desktop-file-utils" "python-matplotlib" "python-scipy" "python-cycler" "python-fonttools" "python-kiwisolver" "python-packaging" "python-pillow" "python-pyparsing" "python-dateutil" "python-cairo" "python-cairocffi" "lapack")

for package in "${packages[@]}"; do
    if check_package "$package"; then
        continue  # Package is already installed, skip to the next one
    else
        install_package "$package"
    fi
done

# Upgrade pip packages
upgrade_pip_packages

# Allow USB input of steering wheel
if pacman -S --noconfirm usb_modeswitch; then
    echo "usb_modeswitch installed successfully."
else
    echo "Error installing usb_modeswitch. Exiting."
    zenity --info --text="Error installing usb_modeswitch. Exiting." --width=300
    exit 1
fi

# Clone Oversteer
echo "Cloning Oversteer repository..."
if git clone https://github.com/berarma/oversteer.git; then
    echo "Oversteer repository cloned successfully."
else
    echo "Error cloning Oversteer repository. Exiting."
    zenity --info --text="Error cloning Oversteer repository. Exiting." --width=300
    exit 1
fi

# Prepare build system
cd oversteer
echo "Preparing build system..."
if meson build; then
    echo "Build system prepared successfully."
else
    echo "Error preparing build system. Exiting."
    zenity --info --text="Error preparing build system. Exiting." --width=300
    exit 1
fi

# Installing Oversteer
cd build
echo "Installing Oversteer..."
if ninja install; then
    echo "Oversteer installed successfully."
    zenity --info --text="Oversteer installed successfully." --width=300
else
    echo "Error installing Oversteer. Exiting."
    zenity --info --text="Error installing Oversteer. Exiting." --width=300
    exit 1
fi

# Print install completed message
zenity --info --text="Install of Oversteer has been completed! Please restart your Steam Deck for Oversteer to begin to work properly!" --width=300
