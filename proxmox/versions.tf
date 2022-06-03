terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "~> 2.9.9"
    }
  }
  required_version = ">= 0.13"
}
