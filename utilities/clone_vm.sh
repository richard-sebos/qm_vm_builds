#!/bin/bash
## Simple Clone VM
# Variables for Cloning
TEMPLATE_ID=400
NEW_VMID=401
NEW_NAME="TestServer1"
DISK_STORAGE="vm_storage"    # Replace with your disk storage name

# Clone Template
qm clone $TEMPLATE_ID $NEW_VMID --name $NEW_NAME --full

