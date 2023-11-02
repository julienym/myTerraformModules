variable "nodes" {}

variable "bastion" {}

variable "kubeconfig_path" {
  type = string
}

variable "name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "api_domain" {
  type = string
}

variable "kubernetes_version" {
  type        = string
  description = "RKE Kubernetes version"
}