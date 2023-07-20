terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "= 0.10.6"
    }
  }
  required_version = ">= 0.13"
}
