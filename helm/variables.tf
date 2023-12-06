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
  type    = list(string)
  default = []
}

variable "secret_values" {
  description = "Secret values map"
  default     = {}
}

variable "namespace" {
  type = string
}