variable "name" {
  type = string
}

variable "repository" {
  type    = string
  default = null
}

variable "chart" {
  type = string
}

variable "chart_version" {
  type    = string
  default = null
}

variable "values" {
  default = {}
}

variable "secrets_list" {
  type      = list(string)
  default   = []
  sensitive = true
}

variable "namespace" {
  type = string
}