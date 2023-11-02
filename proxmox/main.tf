resource "proxmox_vm_qemu" "vms" {
  depends_on = [ssh_resource.cloud_init_snippet]

  name = "${var.name}.${var.domain_name}"

  #Provisionning settings
  os_type     = "cloud-init"
  target_node = var.target_node
  clone       = var.clone
  full_clone  = false

  #CPU settings
  cpu     = "kvm64"
  cores   = var.cores
  sockets = 1

  #RAM settings
  memory  = var.ram_mb
  balloon = var.ram_balloon

  #Disk settings
  disk {
    type    = trimsuffix(var.bootdisk, "0")
    size    = "${var.disk_gb}G"
    storage = var.storage
    cache   = "writeback"
    discard = "on" #assume SSD
  }

  dynamic "disk" {
    for_each = var.data_disk

    content {
      type    = "virtio"
      size    = "${disk.value.size * 1024 - 820}M"
      storage = disk.value.storage
      cache   = disk.value.cache
      discard = "on" #assume SSD
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
  # cloudinit_cdrom_storage = var.storage
  ipconfig0 = "${var.gateway != null ? "gw=${var.gateway}," : ""}ip=${var.ipconfig}"

  #User datas
  ciuser  = var.ssh.user
  sshkeys = file(var.ssh.public_key)

  nameserver   = var.dns
  searchdomain = var.domain_name

  provisioner "remote-exec" {
    inline = var.provision_verification
  }

  connection {
    type                = "ssh"
    user                = var.ssh.user
    private_key         = file(var.ssh.private_key)
    host                = self.default_ipv4_address
    port                = var.ssh.port
    bastion_host        = var.bastion.host != "" ? var.bastion.host : null
    bastion_user        = var.bastion.host != "" ? var.bastion.user : null
    bastion_port        = var.bastion.host != "" ? var.bastion.port : null
    bastion_private_key = var.bastion.host != "" ? file(var.bastion.private_key) : ""
  }
}
