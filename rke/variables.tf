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

variable "ram_balloon" {
  type = number
  default = 1
  description = "Should memory ballooing be enable ? 1 = true" 
}