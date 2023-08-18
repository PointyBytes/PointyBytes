#!/bin/bash

# Installation Prerequisites
# The instructions are based on the following prerequisites.
# * The user prowlarr is created
# * The directory /var/lib/prowlarr is created and the user prowlarr has read/write permissions for it

# Architecture variable: arm, arm64, or x64
ARCHITECTURE="CHANGE_THIS"

# Update system
sudo apt-get update

# Install necessary dependencies for Bazarr
sudo apt-get install libxml2-dev libxslt1-dev python3-dev python3-libxml2 python3-lxml unrar-free ffmpeg libatlas-base-dev -y

# Upgrade Python to version 3.8 or greater (assuming you have a method to do this, if not you'll need to add one)

# Install Prowlarr
sudo curl -L -o /tmp/prowlarr.tar.gz https://prowlarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=$ARCHITECTURE
sudo tar -xvzf /tmp/prowlarr.tar.gz -C /opt/
sudo chown -R prowlarr:prowlarr /opt/Prowlarr

# Install other Servarr suite applications (Lidarr, Radarr, Readarr, Sonarr) similarly...

# Install Bazarr
wget https://github.com/morpheus65535/bazarr/releases/latest/download/bazarr.zip
sudo mkdir -p /opt/bazarr
sudo unzip bazarr.zip -d /opt/bazarr
cd /opt/bazarr
python3 -m pip install -r requirements.txt

# Check for ARMv6 architecture and apply necessary fix
if [ "$(uname -m)" = "armv6l" ]; then
    python3 -m pip uninstall numpy -y
    sudo apt-get install python3-numpy -y
fi

# Change ownership to your preferred user for running programs
sudo chown -R $USER:$USER /opt/bazarr

echo "Installation of Prowlarr, Lidarr, Radarr, Readarr, Sonarr, and Bazarr is complete!"
echo "You can start Bazarr with the command: python3 /opt/bazarr/bazarr.py"
echo "Visit http://localhost:6767/ in your browser to access Bazarr."
