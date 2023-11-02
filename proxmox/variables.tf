variable "snippet_path" {
  type        = string
  description = "Snippet file full path. Ex. user=local:snippets/test.yaml"
}

variable "name" {
  type        = string
  description = "Proxmox VM name"
}

variable "target_node" {
  type        = string
  description = "Proxmox target node name"
}

variable "bridge" {
  type        = string
  description = "Network bridge interface name"
  default     = "vmbr0"
}

variable "vlan" {
  type        = number
  default     = "-1"
  description = "VLAN tag"
}

variable "clone" {
  type        = string
  description = "VM Clone template name"
}

variable "disk_gb" {
  type        = number
  description = "Main OS disk size in GB"
  default     = 80
}

variable "ram_mb" {
  type        = number
  default     = 2048
  description = "Memory RAM size in MB"
}

variable "cores" {
  type        = number
  default     = 2
  description = "CPU cores count"
}

variable "storage" {
  type        = string
  default     = "local"
  description = "Disk storage pool name"
}

variable "onboot" {
  type        = bool
  default     = false
  description = "Start VM on boot flag"
}

variable "startup" {
  type        = string
  default     = null
  description = "Startup delay options"
}

variable "macaddr" {
  type        = string
  default     = null
  description = "MAC address for VM"
}

variable "domain_name" {
  type        = string
  description = "Domain name for cloud-init user-data and VM name composition"
}

variable "data_disk" {
  default     = {}
  description = "Extra data disk"
}

variable "agent" {
  type        = string
  default     = "1"
  description = "QEMU Guest agent enable (1=true, 0=false)"
}

variable "provision_verification" {
  type        = list(string)
  description = "Post creation script to verify completion"
  default     = ["cloud-init status --wait > /dev/null"]
}

variable "ssh" {
  type = object({
    user        = string
    port        = number
    public_key  = string
    private_key = string
  })
  default = {
    user        = "ubuntu"
    port        = 22
    public_key  = "~/.ssh/id_rsa.pub"
    private_key = "~/.ssh/id_rsa"
  }
  description = "SSH user-data and post creation checkup map"
}

variable "proxmox_ssh" {
  type = object({
    host             = string
    user             = string
    port             = number
    private_key_path = string
    pub_key_path     = string
  })
  description = "Proxmox SSH map"
  default = {
    host             = "pmx"
    user             = "root"
    port             = 22
    private_key_path = "~/.ssh/id_rsa"
    pub_key_path     = "~/.ssh/id_rsa.pub"
  }
}

variable "ipconfig" {
  type        = string
  default     = "dhcp"
  description = "Cloud-init user data ip config"
}

variable "gateway" {
  type        = string
  default     = null
  description = "Cloud-init user data gateway"
}

variable "dns" {
  type        = string
  default     = null
  description = "DNS name server address"
}

variable "bootdisk" {
  type        = string
  default     = "virtio0"
  description = "Boot disk device"
}

variable "ram_balloon" {
  type        = number
  default     = 1
  description = "Should memory ballooing be enable ? 1 = true"
}

variable "cloud_init" {
  type        = string
  description = "Cloud-init user data yaml"
}

variable "ssh_snippet_path" {
  type        = string
  description = "Proxmox host path to the snippet file"
}