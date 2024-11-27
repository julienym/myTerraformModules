resource "proxmox_vm_qemu" "vms" {
  depends_on = [ssh_resource.cloud_init_snippet]

  name = "${var.name}.${var.domain_name}"

  #Provisionning settings
  os_type     = "cloud-init"
  target_node = var.target_node
  clone       = var.clone
  full_clone  = false

  #CPU settings
  cpu     = var.cpu
  cores   = var.cores
  sockets = var.sockets

  #RAM settings
  memory  = var.ram_mb
  balloon = var.ram_balloon

  #Disk settings
  disk {
    type     = "disk"
    slot     = var.bootdisk
    size     = "${var.disk_gb}G"
    storage  = var.storage
    cache    = var.cache
    discard  = true #assume SSD
    iothread = true
  }

  dynamic "disk" {
    for_each = var.data_disks

    content {
      type     = "disk"
      slot     = disk.value.slot
      size     = "${disk.value.size * 1024 - 820}M"
      storage  = disk.value.storage
      cache    = disk.value.cache
      discard  = true #assume SSD
      iothread = true
    }
  }
  
  bootdisk = var.bootdisk
  agent    = var.agent
  onboot   = var.onboot
  startup  = var.startup
  scsihw   = "virtio-scsi-pci"

  #Network settings
  network {
    model   = "virtio"
    bridge  = var.bridge
    macaddr = var.macaddr
    tag     = var.vlan
  }

  #Cloud-init settings by snippet
  cicustom = var.snippet_path

  #User data
  ciuser       = var.ssh.user
  sshkeys      = file(var.ssh.public_key)
  nameserver   = var.dns
  searchdomain = var.domain_name
  ipconfig0    = "${var.gateway != null ? "gw=${var.gateway}," : ""}ip=${var.ipconfig}"

  # provisioner "local-exec" {
  #   command = "while ! ping -q -c 1 ${var.agent == "1" ? self.default_ipv4_address : "${var.name}.${var.domain_name}"} >/dev/null ; do sleep 1; done ; echo 'Server online'"
  # }

  provisioner "remote-exec" {
    inline = var.provision_verification
  }

  connection {
    type        = "ssh"
    user        = var.ssh.user
    private_key = file(var.ssh.private_key)
    host        = var.agent == "1" ? self.default_ipv4_address : "${var.name}.${var.domain_name}"
    port        = var.ssh.port
  }

  lifecycle {
    ignore_changes = [cicustom]
  }

  # timeouts {
  #   create = "10m"
  #   # delete = "2h"
  # }
}
