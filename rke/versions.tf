terraform {
  required_providers {
    rke = {
      source = "rancher/rke"
      version = "~> 1.3.3"
    }
  }
  required_version = ">= 0.13"
}
