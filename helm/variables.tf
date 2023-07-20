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

variable "secret_values" {
  default   = {}
  sensitive = true
}

variable "values_file" {
  type    = string
  default = ""
}

variable "namespace" {
  type = string
}