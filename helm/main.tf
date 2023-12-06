resource "helm_release" "this" {
  name             = var.name
  repository       = var.repository
  chart            = var.chart
  version          = var.chart_version
  create_namespace = true
  namespace        = var.namespace

  values = var.values

  dynamic "set_sensitive" {
    for_each = var.secret_values

    content {
      name  = set_sensitive.key
      value = set_sensitive.value
    }
  }
}
