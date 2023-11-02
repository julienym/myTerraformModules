output "proxmox_nodes" {
  value = proxmox_vm_qemu.vms.name
}

output "proxmox_vm_id" {
  value = proxmox_vm_qemu.vms.vmid
}

output "default_ipv4_address" {
  value = proxmox_vm_qemu.vms.default_ipv4_address
}
