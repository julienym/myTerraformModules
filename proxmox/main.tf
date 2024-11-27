resource "proxmox_vm_qemu" "vms" {
  depends_on = [ssh_resource.cloud_init_snippet]

  name = "${var.name}.${var.domain_name}"

  #Provisionning settings
  os_type                = "cloud-init"
  target_node            = var.target_node
  clone                  = var.clone
  full_clone             = false
  define_connection_info = false
  automatic_reboot = false
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
      ide0 {
        cloudinit {
          storage = "SSD"
        }
      }
      ide2 {
        cdrom {
          passthrough = false
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          # type     = "disk"
          # slot     = var.bootdisk
          size      = "${var.disk_gb}G"
          storage   = var.storage
          cache     = var.cache
          discard   = var.discard
          iothread  = var.iothread
          replicate = var.replicate
        }
      }
      virtio1 {
        disk {
          # type     = "disk"
          # slot     = disk.value.slot
          size      = "${var.data_disk.size * 1024 - 820}M"
          storage   = var.data_disk.storage
          cache     = var.data_disk.cache
          discard   = try(var.data_disk.discard, var.discard)
          iothread  = try(var.data_disk.iothread, var.iothread)
          replicate = try(var.data_disk.replicate, var.replicate)
        }
      }
    }
  }

  bootdisk = var.bootdisk
  agent    = var.agent
  onboot   = var.onboot
  startup  = var.startup
  scsihw   = "virtio-scsi-pci"

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
