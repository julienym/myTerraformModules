resource "rke_cluster" "this" {
  
  cluster_name = var.name
  
  dynamic "nodes" {
    for_each = var.nodes
    
    content {  
      address = "${nodes.key}"
      node_name = "${nodes.key}"
      user    = "ubuntu"
      role    = nodes.value["roles"]
      labels = {
        vmId = try(nodes.value["vmCode"], "unmanaged")
      }
      ssh_key = file(var.bastion.ssh_private_key)
    }
  }
  kubernetes_version = "v1.23.6-rancher1-1"
  # services {
  #   kube_api {
  #     extra_args = {  
  #       external-hostname = "api.k8s.locacloud.com"
  #     }
  #   }
  # }
  ingress {
    provider = "nginx"
    http_port = 80
    https_port = 443
    network_mode = "hostNetwork"
  }
  authentication {
    sans = [ var.api_domain ]
  }
  bastion_host {
    address = var.bastion.host
    port = var.bastion.port
    user = var.bastion.user
    ssh_key = file(var.bastion.ssh_private_key)
  }
  upgrade_strategy {
      drain = false
  }
}

resource "local_file" "rancher_kubeconfig" {
  content  = replace(rke_cluster.this.kube_config_yaml, "/https:.*:6443/", "https://${var.api_domain}:6443") 
  filename = var.kubeconfig_path
}
