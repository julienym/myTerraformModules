variable "snippet_path" {
  type        = string
  default     = ""
  description = "Snippet file full path"
}

variable "name" {
  type = string
}
variable "target_node" {
  type = string
}
variable "bridge" {
  type = string
}

variable "vlan" {
  type        = number
  default     = "-1"
  description = "VLAN tag"
}

variable "clone" {
  type        = string
  default     = null
  description = "VM Clone template name"
}

variable "disk_gb" {
  type = number
}
variable "ram_mb" {
  type = number
}
variable "cores" {
  type = number
}
variable "storage" {
  type = string
}
variable "onboot" {
  type        = bool
  default     = false
  description = "Start VM on boot"
}

variable "startup" {
  type        = string
  default     = null
  description = "Startup delay options"
}

variable "macaddr" {
  type    = string
  default = null
}

variable "domain_name" {
  type = string
}

variable "data_disk" {}

variable "agent" {
  type    = string
  default = "1"
}

variable "provision_verification" {
  type    = list(string)
  default = ["cloud-init status --wait > /dev/null"]
}

#SSH
variable "ssh" {
  type = map(string)
  default = {
    user        = "ubuntu"
    port        = 22
    public_key  = "~/.ssh/id_rsa.pub"
    private_key = "~/.ssh/id_rsa"
  }
}

variable "proxmox_ssh" {} #TODO
variable "bastion" {
  type = map(string)
  default = {
    host        = ""
    user        = ""
    port        = ""
    public_key  = "~/.ssh/id_rsa.pub"
    private_key = "~/.ssh/id_rsa"
  }
}

variable "ipconfig" {
  type    = string
  default = "dhcp"
}

variable "gateway" {
  type    = string
  default = null
}

variable "dns" {
  type    = string
  default = null
}

variable "bootdisk" {
  type    = string
  default = "virtio0"
}

variable "ram_balloon" {
  type        = number
  default     = 1
  description = "Should memory ballooing be enable ? 1 = true"
}

variable "cloud_init" {
  type        = string
  default     = ""
  description = "Cloud-init user data yaml"
}

variable "ssh_snippet_path" {
  type = string
}