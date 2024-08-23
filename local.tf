locals {
  vm_configurations = {
    "vm-1" = {
      # VM
      name             = "vm-1"
      description      = "A Docker containers on a single machine."
      node_name        = "pve"
      vm_id            = null
      cpu_cores        = 4
      dedicated_memory = 24576
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
      operating_system_type = "l26"
      scsi_hardware         = "virtio-scsi-pci"
      vga_memory            = 128
      vga_type              = "std"
      tpm_enable            = false
      tpm_datastore_id      = "local-lvm"
      tpm_version           = "v2.0"
      network_device_bridge = "vmbr0"
      ipv4_address          = "10.1.5.101/24"
      ipv4_gateway          = "10.1.5.1"
      dns_servers           = ["1.1.1.1", "8.8.8.8"]
      # VM: Boot Disk
      boot_disk_datastore_id = "local-lvm"
      boot_disk_interface    = "scsi0"
      boot_disk_size         = 300

      # Note: If a new block device is needed for the home directory, ensure to create and
      # configure an additional disk accordingly, and update this variable with the appropriate
      # block device name for the newly created disk.
      # And include the following in the runcmd:
      # - Ensures that the shell script has executable permissions.
      # "chmod +x /tmp/home_disk_setup.sh",
      # - Executes the fdisk shell script to set up the new disk for the home directory.
      # "/tmp/home_disk_setup.sh",
      # # - Cleans up the temporary folder after disk setup.
      # "rm -r /tmp/*"
      home_disk_block_device = "/dev/sdb"
      # VM: Attach disks, assign from scsi1 and up
      disks = [
        {
          disk_datastore_id = "local-lvm"
          disk_file_format  = "raw"
          disk_size         = 60
          disk_interface    = "scsi1"
        }
      ]
      tags = ["terraform", "ubuntu-22.04"]

      # Cloud Image
      cloud_image_content_type        = "iso"
      cloud_image_datastore_id        = "pve-cluster-fs"
      cloud_image_node_name           = "pve"
      cloud_image_url                 = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
      cloud_image_file_name           = "jammy-server-cloudimg-amd64.img"
      cloud_image_overwrite           = true
      cloud_image_overwrite_unmanaged = true

      # Cloud Init
      cloud_init_content_type = "snippets"
      cloud_init_datastore_id = "pve-cluster-fs"
      cloud_init_node_name    = "pve"
      hostname                = "vm-1"
      manage_etc_hosts        = true
      fqdn                    = "vm-1.doman.com"
      timezone                = "Europe/London"
      username                = "adminjody"
      groups                  = ["adm", "cdrom", "dip", "plugdev", "lxd", "sudo"]
      sudo_config             = ["ALL=(ALL) NOPASSWD:ALL"]
      ssh_authorized_keys     = var.ssh_authorized_keys
      package_upgrade         = true
      packages                = ["qemu-guest-agent", "nfs-common"]
      runcmd = [
        # Enable and Start Qemu Agent
        "systemctl enable qemu-guest-agent",
        "systemctl start qemu-guest-agent",
        # Ensures that the shell script has executable permissions.
        "chmod +x /tmp/home_disk_setup.sh",
        # Executes the fdisk shell script. 
        "/tmp/home_disk_setup.sh",
        # Clean up temp folder.
        "rm -r /tmp/*"
      ]
    }, # end of vm-1
  }
}
