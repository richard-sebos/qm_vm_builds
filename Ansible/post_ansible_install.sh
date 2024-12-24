#!/bin/bash

# Exit on error
set -e

# Define paths and variables
PLAYBOOKS_DIR="/etc/ansible/playbooks"
VAULT_FILE="${PLAYBOOKS_DIR}/secrets.yml"
ANSIBLE_CFG="/etc/ansible/ansible.cfg"
LOG_FILE="/var/log/ansible.log"

# Function to check if a directory exists, and create it if not
create_directory() {
    local dir_path=$1
    if [ ! -d "$dir_path" ]; then
        echo "Creating directory: $dir_path"
        sudo mkdir -p "$dir_path"
    else
        echo "Directory already exists: $dir_path"
    fi
}

# Function to apply permissions
apply_permissions() {
    local path=$1
    local permissions=$2
    echo "Applying permissions $permissions to $path"
    sudo chmod -R "$permissions" "$path"
}

# Function to initialize Ansible Vault
create_vault_file() {
    local file_path=$1
    if [ ! -f "$file_path" ]; then
        echo "Creating Ansible Vault file: $file_path"
        sudo ansible-vault create "$file_path"
    else
        echo "Vault file already exists: $file_path"
    fi
}

# Function to configure logging in ansible.cfg
configure_ansible_logging() {
    local cfg_path=$1
    local log_path=$2
    if [ -f "$cfg_path" ]; then
        echo "Configuring Ansible logging in $cfg_path"
        sudo sed -i "/^#*log_path/d" "$cfg_path"
        echo "[defaults]" | sudo tee -a "$cfg_path" > /dev/null
        echo "log_path=${log_path}" | sudo tee -a "$cfg_path" > /dev/null
    else
        echo "Ansible configuration file not found at $cfg_path. Creating one."
        echo "[defaults]" | sudo tee "$cfg_path" > /dev/null
        echo "log_path=${log_path}" | sudo tee -a "$cfg_path" > /dev/null
    fi
}

# Secure playbooks directory
create_directory "$PLAYBOOKS_DIR"
apply_permissions "$PLAYBOOKS_DIR" "750"

# Enable Ansible Vault for sensitive files
create_vault_file "$VAULT_FILE"

# Configure Ansible logs
configure_ansible_logging "$ANSIBLE_CFG" "$LOG_FILE"

# Create log file with proper permissions
if [ ! -f "$LOG_FILE" ]; then
    echo "Creating Ansible log file: $LOG_FILE"
    sudo touch "$LOG_FILE"
    sudo chmod 640 "$LOG_FILE"
    sudo chown root:root "$LOG_FILE"
fi

echo "Ansible environment secured successfully."
