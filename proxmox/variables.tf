# variable "cloudInitFilePath" {
#   type = string
# }

variable "snippet_filename" {
  type = string
  default = ""
  description = "Snippet filename"
}

variable "snippet_sha256" {
  type = string
  default = ""
  description = "SHA256 of snippet for force recreation"
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
  type = number
  default = "-1"
  description = "VLAN tag"
}

variable "clone" {
  type = string
  default = null
  description = "VM Clone template name"
}
variable "iso" {
  type = string
  default = null
  description = "ISO file path on the hypervisor"
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
  type = bool
  default = false
  description = "Start VM on boot"
}

variable "startup" {
  type = string
  default = null
  description = "Startup delay options"
}

variable "macaddr" {
  type = string
  default = ""
  # validation {
  #   condition     = length(regexall("^([a-f0-9][26ae])(:[a-f0-9]{2}){5}$", var.macaddr)) == 2
  #   error_message = "The MAC address should match a Locally Administered Address Ranges (x[26ae]x:xx:xx:xx:xx:xx)!"
  # }
}

variable "domain_name" {
  type = string
}


variable "data_disk" {}

variable "agent" {
  type = string
  default = "1"
}

variable "provision_verification" {
  type = list(string)
  default = ["cloud-init status --wait > /dev/null"]
}

#SSH
variable "ssh" {
  type = map(string)
  default = {
    user = "ubuntu"
    port = 22
    public_key = "~/.ssh/id_rsa.pub"
    private_key = "~/.ssh/id_rsa"
  }
}

variable "bastion" {
  type = map(string)
  default = {
    host = ""
    user = ""
    port = ""
    public_key = "~/.ssh/id_rsa.pub"
    private_key = "~/.ssh/id_rsa"
  }
}

variable "ipconfig" {
  type = string
  default = "dhcp"
}

variable "gateway" {
  type = string
  default = null
}

variable "dns" {
  type = string
  default = null
}

variable "bootdisk" {
  type = string
  default = "scsi0"
}
