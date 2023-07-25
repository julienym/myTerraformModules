resource "helm_release" "this" {
  name             = var.name
  repository       = var.repository
  chart            = var.chart
  version          = var.chart_version
  create_namespace = true
  namespace        = var.namespace

  values = var.secrets_list

  dynamic "set" {
    for_each = { for k, v in var.values : k => v if v != null }

    content {
      name  = set.key
      value = set.value
    }
  }
}
