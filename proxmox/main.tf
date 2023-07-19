resource "proxmox_vm_qemu" "vms" {
  name = "${var.name}.${var.domain_name}"

  #Provisionning settings
  os_type = var.snippet_filename != "" ? "cloud-init" : ""
  target_node = var.target_node
  clone = var.clone
  # iso = var.iso
  full_clone = false
  # hastate = ""
  #qemu_os = "other"

  #CPU settings
  cpu = "kvm64"
  cores = var.cores
  sockets = 1

  #RAM settings
  memory = var.ram_mb
  balloon = 0

  # vga {
  #   type = "serial0"
  # }

  #Disk settings
  disk {
    type = trimsuffix(var.bootdisk, "0")
    size = "${var.disk_gb}G"
    storage = var.storage
    cache = "writeback"
    discard = "on"
    # iothread = 1
    # file = ""
    # format = "raw"
    # slot = 0
    # volume = ""
  }

  dynamic "disk" {
    for_each = var.data_disk

    content {
      type = "virtio"
      size = "${disk.value.size * 1024 - 820}M"
      storage = disk.value.storage
      cache = disk.value.cache
      discard = "on" #assume SSD
      # iothread = 1
    }
  }
  bootdisk = var.bootdisk
  # boot        = "order=virtio0" #"order=scsi0;ide2"
  agent = var.agent
  onboot = var.onboot
  startup = var.startup
  # define_connection_info = false
  # tablet = false
  # force_create = false
  scsihw = "virtio-scsi-pci"

  #Network settings
  network {
    model = "virtio"
    bridge = var.bridge
    macaddr = var.macaddr
    tag = var.vlan
  #  queues = 0
  #  rate = 0
  }
  
  #Cloud-init settings by snippet
  cicustom = var.snippet_filename != "" ? "user=local:snippets/${var.snippet_filename}" : null
  # force_recreate_on_change_of = var.snippet_filename != "" ? var.snippet_sha256 : null
  cloudinit_cdrom_storage = var.storage
  
  #needed unless configure in cicustom?
  ipconfig0 = "${var.gateway != null ? "gw=${var.gateway}," : ""}ip=${var.ipconfig}"

  #User datas
  ciuser = var.ssh.user
  sshkeys = file(var.ssh.public_key)
  # cipassword = "ubuntu"

  nameserver = var.dns
  searchdomain = var.domain_name

  lifecycle {
    ignore_changes = [
      force_recreate_on_change_of,
  #     #network[0].macaddr,
  #     #network[0].queues,
  #     #network[0].rate,
  #     #disk[0].file,
  #     #disk[0].format,
  #     #disk[0].slot,
  #     #disk[0].storage_type,
  #     #disk[0].volume
  #     #searchdomain,
    ]
  }

  provisioner "remote-exec" {
    inline = var.provision_verification
  }

  connection {
    type     = "ssh"
    user     = var.ssh.user
    private_key = file(var.ssh.private_key)
    host     = "${var.name}.${var.domain_name}"
    port     = var.ssh.port
    bastion_host = var.bastion.host != "" ? var.bastion.host : null
    bastion_user = var.bastion.host != "" ? var.bastion.user : null
    bastion_port = var.bastion.host != "" ? var.bastion.port : null
    bastion_private_key = var.bastion.host != "" ? file(var.bastion.private_key) : ""
  }
}
