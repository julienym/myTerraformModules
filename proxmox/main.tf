resource "proxmox_vm_qemu" "vms" {
  name = "${var.name}.vm"

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

  #Disk settings
  disk {
    type = "scsi"
    size = "${var.disk_gb}G"
    storage = var.storage
    cache = "writeback"
    discard = "on"
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
    }
  }
  # bootdisk = "virtio0"
  # boot = "cd"
  # boot        = "c"
  agent = var.agent
  # onboot = var.onboot
  # define_connection_info = false
  # tablet = false
  # force_create = false
 # scsihw = "lsi"

  #Network settings
  network {
    model = "virtio"
    bridge = var.bridge
    macaddr = var.macaddr
    # tag = var.vlan
  #  queues = 0
  #  rate = 0
  }
  
  #Cloud-init settings by snippet
  cicustom = var.snippet_filename != "" ? "user=local:snippets/${var.snippet_filename}" : null
  force_recreate_on_change_of = var.snippet_filename != "" ? var.snippet_sha256 : null
  # cloudinit_cdrom_storage = var.storage
  
  #This seams needed to activate the cloud-init drive
  ipconfig0 = var.snippet_filename != "" ? "ip=dhcp" : null

  # ciuser = var.snippet_filename == "" ? "ubuntu" : null
  # sshkeys = var.snippet_filename == "" ? file(var.bastion.ssh_public_key) : null #Temp
  # nameserver = var.snippet_filename == "" ? "172.16.0.1" : null #Temp
  # searchdomain = var.snippet_filename == "" ? "vm" : null #Temp

  # lifecycle {
  #   ignore_changes = [
  #     #network[0].macaddr,
  #     #network[0].queues,
  #     #network[0].rate,
  #     #disk[0].file,
  #     #disk[0].format,
  #     #disk[0].slot,
  #     #disk[0].storage_type,
  #     #disk[0].volume
  #     #searchdomain,
  #   ]
  # }


  provisioner "remote-exec" {
    inline = [ 
      "${var.provision_verification}"
    ]
  }

  connection {
    type     = "ssh"
    user     = var.ssh_user
    private_key = file(var.bastion.ssh_private_key) #Temp
    host     = "${var.name}.${var.domain_name}"
    port     = 22
    bastion_host = var.bastion.host != "" ? var.bastion.host : null
    bastion_user = var.bastion.host != "" ? var.bastion.user : null
    bastion_port = var.bastion.host != "" ? var.bastion.port : null
    bastion_private_key = var.bastion.host != "" ? file(var.bastion.ssh_private_key) : ""
  }
}
