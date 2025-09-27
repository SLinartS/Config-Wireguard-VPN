#!/bin/bash

# CHECK IF THE REQUIRED PARAMETERS ARE PROVIDED
if [ $# -ne 2 ]; then
    echo "Usage: $0 VPN_USER_NAME VPN_USER_PASSWORD [INTERFACE]"
    exit 1
fi

# UPDATE THE SYSTEM
echo "Updating the system..."
apt update

# INSTALL NECESSARY PACKAGES
echo "Installing necessary packages..."
export DEBIAN_FRONTEND=noninteractive
apt -y install wireguard wireguard-tools