terraform {
  required_providers {
    proxmox = {
      source = "hashicorp/helm"
      version = "= 0.10.6"
    }
  }
  required_version = ">= 0.13"
}
