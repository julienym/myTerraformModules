resource "random_uuid" "cloud_init_file" {}

resource "local_file" "cloud_init_render" {
  content  = var.cloud_init
  filename = "/tmp/terraform-${random_uuid.cloud_init_file.result}.yaml"

  provisioner "local-exec" {
    command = "cloud-init schema -c /tmp/terraform-${random_uuid.cloud_init_file.result}.yaml --annotate"
    quiet   = true
  }
}

resource "ssh_resource" "cloud_init_snippet" {
  when = "create"

  host        = var.proxmox_ssh.host
  port        = var.proxmox_ssh.port
  user        = var.proxmox_ssh.user
  private_key = file(var.proxmox_ssh.private_key_path)

  timeout     = "15m"
  retry_delay = "5s"

  file {
    content     = local_file.cloud_init_render.content
    destination = var.ssh_snippet_path
    permissions = "0700"
  }
}