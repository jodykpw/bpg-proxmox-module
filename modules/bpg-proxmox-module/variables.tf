# VMS
variable "vms" {
  # VM
  description = "Map of VM configurations"
  type = map(object({
    name             = string
    description      = string
    node_name        = string
    vm_id            = number
    cpu_cores        = number
    dedicated_memory = number
    cpu_sockets      = number
    cpu_numa         = bool
    cpu_limit        = number
    cpu_type         = string
    bios             = string
    machine          = string
    agent_enabled    = bool
    agent_timeout    = string
    startup = optional(object({
      order      = number
      up_delay   = number
      down_delay = number
    }))
    operating_system_type  = string
    scsi_hardware          = string
    vga_memory             = number
    vga_type               = string
    tpm_enable             = bool
    tpm_datastore_id       = string
    tpm_version            = string
    network_device_bridge  = string
    ipv4_address           = string
    ipv4_gateway           = string
    dns_servers            = list(string)
    boot_disk_datastore_id = string
    boot_disk_interface    = string
    boot_disk_size         = number
    home_disk_block_device = string
    disks = list(object({
      disk_datastore_id = string
      disk_file_format  = string
      disk_size         = number
      # assign from scsi1 and up
      disk_interface = string
    }))
    tags = list(string)
    # Cloud Image
    cloud_image_node_name           = string
    cloud_image_content_type        = string
    cloud_image_datastore_id        = string
    cloud_image_url                 = string
    cloud_image_file_name           = string
    cloud_image_overwrite           = bool
    cloud_image_overwrite_unmanaged = bool
    # Cloud Init
    cloud_init_content_type = string
    cloud_init_datastore_id = string
    cloud_init_node_name    = string
    hostname                = string
    manage_etc_hosts        = bool
    fqdn                    = string
    timezone                = string
    username                = string
    ssh_authorized_keys     = list(string)
    groups                  = list(string)
    sudo_config             = list(string)
    package_upgrade         = bool
    packages                = list(string)
    runcmd                  = list(string)
  }))

  default = {
    example_vm = {
      name             = "ubuntu-vm"
      description      = "default_description"
      node_name        = "pve1"
      vm_id            = 1001
      cpu_cores        = 2
      dedicated_memory = 2048
      cpu_sockets      = 1
      cpu_numa         = false
      cpu_limit        = 0
      cpu_type         = "x86-64-v2-AES"
      bios             = "seabios"
      machine          = "q35"
      agent_enabled    = true
      agent_timeout    = "15m"
      startup = {
        order      = 1
        up_delay   = 10
        down_delay = 5
      }
      operating_system_type  = "l26"
      scsi_hardware          = "virtio-scsi-pci"
      vga_memory             = 256
      vga_type               = "std"
      tpm_enable             = false
      tpm_datastore_id       = "local-lvm"
      tpm_version            = "v2.0"
      network_device_bridge  = "vmbr0"
      ipv4_address           = "10.1.5.100/24"
      ipv4_gateway           = "10.1.5.1"
      dns_servers            = ["8.8.8.8", "1.1.1.1"]
      boot_disk_datastore_id = "local-lvm"
      boot_disk_interface    = "scsi0"
      boot_disk_size         = 200
      home_disk_block_device = "/dev/sdb"
      disks = [
        {
          disk_datastore_id = "local-lvm"
          disk_file_format  = "raw"
          disk_size         = 40
          disk_interface    = "scsi1"
        }
      ]
      tags                            = ["terraform", "ubuntu"]
      cloud_image_node_name           = "iso"
      cloud_image_content_type        = "pve-cluster-fs"
      cloud_image_datastore_id        = "pve1"
      cloud_image_url                 = "https://cloud-images.ubuntu.com/jammy/20231215/jammy-server-cloudimg-amd64.img"
      cloud_image_file_name           = "jammy-server-cloudimg-amd64.img"
      cloud_image_overwrite           = true
      cloud_image_overwrite_unmanaged = true
      cloud_init_content_type         = "snippets"
      cloud_init_datastore_id         = "pve-cluster-fs"
      cloud_init_node_name            = "pve1"
      hostname                        = "default_hostname"
      manage_etc_hosts                = true
      fqdn                            = "default_fqdn"
      timezone                        = "default_timezone"
      username                        = "ubuntu"
      ssh_authorized_keys             = []
      groups                          = ["adm, cdrom, dip, plugdev, lxd, sudo"]
      sudo_config                     = ["ALL=(ALL) NOPASSWD:ALL"]
      package_upgrade                 = true
      packages                        = ["qemu-guest-agent"]
      runcmd = [
        # Enable and Start Qemu Agent
        "systemctl enable qemu-guest-agent",
        "systemctl start qemu-guest-agent",
        # Ensures that the shell script has executable permissions.
        "chmod +x /tmp/home_disk_setup.sh",
        # Executes the fdiskshell script. 
        "/tmp/home_disk_setup.sh",
        # Clean up temp folder.
        "rm -r /tmp/*"
      ]
    }
  }
}
