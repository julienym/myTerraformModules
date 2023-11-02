terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "= 2.9.11"
    }
    random = {
      source  = "hashicorp/random"
      version = "= 3.5.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "= 2.4.0"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = "= 2.6.0"
    }
  }
  required_version = ">= 0.13"
}
