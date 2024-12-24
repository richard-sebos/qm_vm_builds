#!/bin/bash

# Exit on error
set -e

echo "Starting Oracle Linux 9 hardening and Ansible setup..."

# 1. Update system packages
echo "Updating system packages..."
sudo dnf update -y
sudo dnf install oracle-epel-release-el9 -y

# 2. Install essential tools
echo "Installing essential tools..."
sudo dnf install wget vim net-tools firewalld -y

# 3. Enable SELinux (enforcing mode)
echo "Enabling SELinux in enforcing mode..."
sudo setenforce 1
sudo sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config

# 4. Configure firewalld
echo "Configuring firewalld..."
sudo systemctl enable --now firewalld
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload

# 5. Install Ansible
echo "Installing Ansible..."
sudo dnf install ansible -y

# 6. Create Ansible user with RBAC
echo "Creating Ansible user..."
sudo adduser ansible
sudo passwd ansible
sudo usermod -aG wheel ansible

# 7. Secure SSH for Ansible user
echo "Configuring SSH for Ansible user..."
sudo -u ansible ssh-keygen -t rsa -b 4096 -f /home/ansible/.ssh/id_rsa -N ""
echo "Please copy the public key to managed servers using the following command:"
echo "  ssh-copy-id ansible@<managed-server-ip>"

# 8. Set strict permissions for SSH keys
echo "Setting permissions for SSH keys..."
sudo chmod 600 /home/ansible/.ssh/id_rsa

echo "Oracle Linux 9 hardening and Ansible setup completed successfully."

