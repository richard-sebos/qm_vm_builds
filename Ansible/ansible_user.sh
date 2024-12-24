#!/bin/bash
###############################################################################
# Script Name:    setup_ansible_user.sh
# Description:    Automates the creation and configuration of a dedicated
#                 Ansible user on managed servers.
#
# Usage:          ./setup_ansible_user.sh <password>
#
# Arguments:
#   <password> - Password for the 'ansible' user.
#
# Notes:
#   - Requires root privileges to execute.
#   - Configures passwordless sudo for the 'ansible' user.
###############################################################################

# Exit on error
set -e

# Ensure the script is run with the correct number of parameters
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <password>"
    exit 1
fi

# Assign parameters to variables
username="ansible"
password=$1

# Create the 'ansible' user (if not already exists)
if id "$username" &>/dev/null; then
    echo "User '$username' already exists. Skipping creation."
else
    echo "Creating user '$username'..."
    sudo useradd -m -s /bin/bash "$username" || { echo "Error: Failed to create user"; exit 1; }
fi

# Set the user's password
echo "Setting password for user '$username'..."
echo "$username:$password" | sudo chpasswd || { echo "Error: Failed to set password"; exit 1; }

# Add the user to the 'wheel' group
echo "Adding user '$username' to the 'wheel' group..."
sudo usermod -aG wheel "$username" || { echo "Error: Failed to add user to wheel group"; exit 1; }

# Configure passwordless sudo for the user
sudoers_file="/etc/sudoers.d/$username"
if [ -f "$sudoers_file" ]; then
    echo "Sudoers file for '$username' already exists. Skipping configuration."
else
    echo "Configuring passwordless sudo for '$username'..."
    echo "$username ALL=(ALL) NOPASSWD:ALL" | sudo tee "$sudoers_file" > /dev/null || {
        echo "Error: Failed to configure passwordless sudo"; exit 1;
    }
    sudo chmod 440 "$sudoers_file" || { echo "Error: Failed to set permissions on $sudoers_file"; exit 1; }
fi

echo "Setup complete: User '$username' created and configured for passwordless sudo."
