resource "proxmox_virtual_environment_vm" "vms" {
  for_each = var.vms

  name        = each.value.name
  description = each.value.description
  node_name   = each.value.node_name
  vm_id       = each.value.vm_id

  cpu {
    cores   = each.value.cpu_cores
    sockets = each.value.cpu_sockets
    numa    = each.value.cpu_numa
    limit   = each.value.cpu_limit
    type    = each.value.cpu_type
  }

  memory {
    dedicated = each.value.dedicated_memory
  }

  bios    = each.value.bios
  machine = each.value.machine

  serial_device {}

  agent {
    enabled = each.value.agent_enabled
    timeout = each.value.agent_timeout
  }

  startup {
    order      = var.vms[each.key].startup.order != null ? var.vms[each.key].startup.order : null
    up_delay   = var.vms[each.key].startup.up_delay != null ? var.vms[each.key].startup.up_delay : null
    down_delay = var.vms[each.key].startup.up_delay != null ? var.vms[each.key].startup.down_delay : null
  }

  operating_system {
    type = each.value.operating_system_type
  }

  scsi_hardware = each.value.scsi_hardware

  vga {
    memory  = each.value.vga_memory
    type    = each.value.vga_type
  }

  dynamic "tpm_state" {
    for_each = var.vms[each.key].tpm_enable ? [1] : []
    content {
      datastore_id = var.vms[each.key].tpm_datastore_id
      version      = var.vms[each.key].tpm_version
    }
  }

  network_device {
    bridge = each.value.network_device_bridge
  }

  initialization {
    ip_config {
      ipv4 {
        address = each.value.ipv4_address
        gateway = each.value.ipv4_gateway
      }
      ipv6 {
        address = "dhcp"
        # Omitting gateway for DHCP, but you can include it if needed
      }
    }

    dns {
      servers = each.value.dns_servers
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_init[each.key].id
  }

  # boot disk
  disk {
    datastore_id = each.value.boot_disk_datastore_id
    file_id      = proxmox_virtual_environment_download_file.cloud_image[each.key].id # Use the specific key
    interface    = each.value.boot_disk_interface
    size         = each.value.boot_disk_size
  }

  # attached disks from data_vm
  dynamic "disk" {
    for_each = each.value.disks
    content {
      datastore_id = disk.value.disk_datastore_id
      file_format  = disk.value.disk_file_format
      size         = disk.value.disk_size
      # assign from scsi1 and up
      interface = disk.value.disk_interface
    }
  }

  tags = each.value.tags
}