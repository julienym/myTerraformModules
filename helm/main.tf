resource "helm_release" "this" {
  name       = var.name
  repository = var.repository
  chart      = var.chart
  version    = var.chart_version
  create_namespace = true
  namespace = var.namespace
  
  values = try([file(var.values_file)], null)

  dynamic "set" {
    for_each = { for k, v in var.values: k => v if v != null }

    content {
      name = set.key
      value = set.value
    }
  }

  dynamic "set" {
    for_each = { for k, v in nonsensitive(var.secret_values): k => v if v != null }

    content {
      name = set.key
      value = set.value
    }
  }
}
