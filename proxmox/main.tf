resource "proxmox_vm_qemu" "vms" {
  depends_on = [ssh_resource.cloud_init_snippet]

  name = "${var.name}.${var.domain_name}"

  #Provisionning settings
  os_type                = "cloud-init"
  target_node            = var.target_node
  clone                  = var.clone
  full_clone             = false
  define_connection_info = false
  automatic_reboot       = false
  # ciupgrade = false

  #CPU settings
  cpu_type = var.cpu
  cores    = var.cores
  sockets  = var.sockets

  #RAM settings
  memory  = var.ram_mb
  balloon = var.ram_balloon

  #Disk settings
  disks {
    ide {
      dynamic "ide0" {
        for_each = var.ide_drive != null ? toset([var.ide_drive]) : toset([])

        content {
          dynamic "cloudinit" {
            for_each = ide0.key == "cloud-init" ? toset([ide0.key]) : toset([])

            content {
              storage = var.storage
            }
          }

          dynamic "cdrom" {
            for_each = ide0.key != "cloud-init" ? toset([ide0.key]) : toset([])

            content {
              iso = ide0.key
            }
          }
        }
      }
    }

    virtio {
      virtio0 {
        disk {
          size      = "${var.disk_gb}G"
          storage   = var.storage
          cache     = var.cache
          discard   = true #assume SSD
          iothread  = try(var.iothread, true)
          replicate = try(var.replicate, true)
        }
      }

      dynamic "virtio1" {
        for_each = { for k, v in var.data_disks : k => v if k == try(keys(var.data_disks)[0], null) }

        content {
          disk {
            size      = "${virtio1.value.size * 1024 - 820}M"
            storage   = virtio1.value.storage
            cache     = virtio1.value.cache
            discard   = try(virtio1.value.discard, true) #assume SSD
            iothread  = try(virtio1.value.iothread, true)
            replicate = try(virtio1.value.replicate, true)
          }
        }
      }
      dynamic "virtio2" {
        for_each = { for k, v in var.data_disks : k => v if k == try(keys(var.data_disks)[1], null) }

        content {
          disk {
            size      = "${virtio2.value.size * 1024 - 820}M"
            storage   = virtio2.value.storage
            cache     = virtio2.value.cache
            discard   = try(virtio2.value.discard, true) #assume SSD
            iothread  = try(virtio2.value.iothread, true)
            replicate = try(virtio2.value.replicate, true)
          }
        }
      }
    }
  }

  # bootdisk = var.bootdisk
  agent  = var.agent
  onboot = var.onboot
  # startup  = var.startup
  scsihw = "virtio-scsi-pci"

  #Network settings
  network {
    id      = 0
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
