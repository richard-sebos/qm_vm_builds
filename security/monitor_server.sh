#!/bin/bash
## Created for Proxmox
# Variables
VMID=500

NAME="MonitorServer"
ISO_STORAGE="ISOs"           # Replace with your ISO storage name
ISO_FILE="OracleLinux-R9-U4-x86_64-dvd.iso" # Replace with your ISO filename
DISK_STORAGE="vm_storage"    # Replace with your disk storage name

## If existing, remove
qm stop $VMID || true
qm destroy $VMID || true

# Create VM
qm create $VMID --name $NAME --memory 16384 --cores 3 --sockets 1 --numa 0 --cpu x86-64-v2-AES --ostype l26
qm set $VMID --net0 virtio,bridge=vmbr0,tag=20
qm set $VMID --scsihw virtio-scsi-single 
pvesm alloc vm_storage $VMID vm-${VMID}-disk-0 200G
qm set $VMID --scsihw virtio-scsi-single --scsi0 vm_storage:vm-${VMID}-disk-0,iothread=1
qm set $VMID --cdrom $ISO_STORAGE:iso/$ISO_FILE
qm set $VMID --boot order='ide2;scsi0'

# Start VM
qm start $VMID
