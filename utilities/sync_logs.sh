#!/bin/bash

# Exit on error
set -e

# Variables
MONITORING_SERVER_IP="192.168.178.75"  # Replace with the IP of your monitoring server

# Install rsyslog
echo "Installing rsyslog..."
sudo dnf install -y rsyslog

# Enable and start rsyslog service
echo "Enabling and starting rsyslog service..."
sudo systemctl enable --now rsyslog

# Configure rsyslog to forward logs to the monitoring server
echo "Configuring rsyslog to forward logs to $MONITORING_SERVER_IP..."
cat <<EOF | sudo tee -a /etc/rsyslog.conf
*.* @$MONITORING_SERVER_IP:514
EOF

# Restart rsyslog service to apply changes
echo "Restarting rsyslog service to apply changes..."
sudo systemctl restart rsyslog

# Final message
echo "Centralized logging setup completed. Logs are being forwarded to $MONITORING_SERVER_IP on port 514."
