locals {
  vm_configurations = {
    "control-plane-1" = {
      # VM
      name             = "control-plane-1"
      description      = "The control plane manages the worker nodes and the Pods in the cluster."
      node_name        = "pve1"
      vm_id            = 151
      cpu_cores        = 2
      dedicated_memory = 8192
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
      ipv4_address          = "10.1.10.151/24"
      ipv4_gateway          = "10.1.10.1"
      dns_servers           = ["1.1.1.1", "8.8.8.8"]
      # VM: Boot Disk
      boot_disk_datastore_id = "local-lvm"
      boot_disk_interface    = "scsi0"
      boot_disk_size         = 60

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
      home_disk_block_device = "/dev/sdc"
      # VM: Attach disks, assign from scsi1 and up
      disks = [
        {
          disk_datastore_id = "local-lvm"
          disk_file_format  = "raw"
          disk_size         = 20
          disk_interface    = "scsi1"
        },
        {
          disk_datastore_id = "local-lvm"
          disk_file_format  = "raw"
          disk_size         = 100
          disk_interface    = "scsi2"
        }
      ]
      tags = ["terraform", "ubuntu-22.04"]

      # Cloud Image
      cloud_image_content_type        = "iso"
      cloud_image_datastore_id        = "local"
      cloud_image_node_name           = "pve1"
      cloud_image_url                 = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
      cloud_image_file_name           = "jammy-server-cloudimg-amd64.img"
      cloud_image_overwrite           = false
      cloud_image_overwrite_unmanaged = false

      # Cloud Init
      cloud_init_content_type = "snippets"
      cloud_init_datastore_id = "pve-fs"
      cloud_init_node_name    = "pve1"
      hostname                = "control-plane-1"
      manage_etc_hosts        = true
      fqdn                    = "control-plane-1.domain.com"
      timezone                = "Europe/London"
      admin_username          = "admin"
      admin_password          = var.admin_password
      users = [
        {
          username            = "admin"
          uid                 = null
          gid                 = null
          groups              = ["adm", "cdrom", "dip", "plugdev", "lxd", "sudo"]
          sudo                = "ALL=(ALL) NOPASSWD:ALL"
          shell               = "/bin/bash"
          ssh_authorized_keys = var.ssh_authorized_keys
        },
        {
          username            = "ansible"
          uid                 = 10001
          gid                 = 10001
          groups              = ["wheel"]
          sudo                = "ALL=(ALL) NOPASSWD:ALL"
          shell               = "/bin/bash"
          ssh_authorized_keys = var.ssh_authorized_keys
        }
      ]
      package_upgrade = true
      packages        = ["qemu-guest-agent", "nfs-common"]
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
    }, # end of control-plane-1

    "control-plane-2" = {
      # VM
      name             = "control-plane-2"
      description      = "The control plane manages the worker nodes and the Pods in the cluster."
      node_name        = "pve2"
      vm_id            = 152
      cpu_cores        = 2
      dedicated_memory = 8192
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
      ipv4_address          = "10.1.10.152/24"
      ipv4_gateway          = "10.1.10.1"
      dns_servers           = ["1.1.1.1", "8.8.8.8"]
      # VM: Boot Disk
      boot_disk_datastore_id = "local-lvm"
      boot_disk_interface    = "scsi0"
      boot_disk_size         = 60

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
      home_disk_block_device = "/dev/sdc"
      # VM: Attach disks, assign from scsi1 and up
      disks = [
        {
          disk_datastore_id = "local-lvm"
          disk_file_format  = "raw"
          disk_size         = 20
          disk_interface    = "scsi1"
        },
        {
          disk_datastore_id = "local-lvm"
          disk_file_format  = "raw"
          disk_size         = 100
          disk_interface    = "scsi2"
        }
      ]
      tags = ["terraform", "ubuntu-22.04"]

      # Cloud Image
      cloud_image_content_type        = "iso"
      cloud_image_datastore_id        = "local"
      cloud_image_node_name           = "pve2"
      cloud_image_url                 = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
      cloud_image_file_name           = "jammy-server-cloudimg-amd64.img"
      cloud_image_overwrite           = false
      cloud_image_overwrite_unmanaged = false

      # Cloud Init
      cloud_init_content_type = "snippets"
      cloud_init_datastore_id = "pve-fs"
      cloud_init_node_name    = "pve2"
      hostname                = "control-plane-2"
      manage_etc_hosts        = true
      fqdn                    = "control-plane-2.domain.com"
      timezone                = "Europe/London"
      admin_username          = "admin"
      admin_password          = var.admin_password
      users = [
        {
          username            = "admin"
          uid                 = null
          gid                 = null
          groups              = ["adm", "cdrom", "dip", "plugdev", "lxd", "sudo"]
          sudo                = "ALL=(ALL) NOPASSWD:ALL"
          shell               = "/bin/bash"
          ssh_authorized_keys = var.ssh_authorized_keys
        },
        {
          username            = "ansible"
          uid                 = 10001
          gid                 = 10001
          groups              = ["wheel"]
          sudo                = "ALL=(ALL) NOPASSWD:ALL"
          shell               = "/bin/bash"
          ssh_authorized_keys = var.ssh_authorized_keys
        }
      ]
      package_upgrade = true
      packages        = ["qemu-guest-agent", "nfs-common"]
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
    }, # end of control-plane-2

    "control-plane-3" = {
      # VM
      name             = "control-plane-3"
      description      = "The control plane manages the worker nodes and the Pods in the cluster."
      node_name        = "pve3"
      vm_id            = 153
      cpu_cores        = 2
      dedicated_memory = 8192
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
      ipv4_address          = "10.1.10.153/24"
      ipv4_gateway          = "10.1.10.1"
      dns_servers           = ["1.1.1.1", "8.8.8.8"]
      # VM: Boot Disk
      boot_disk_datastore_id = "local-lvm"
      boot_disk_interface    = "scsi0"
      boot_disk_size         = 60

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
      home_disk_block_device = "/dev/sdc"
      # VM: Attach disks, assign from scsi1 and up
      disks = [
        {
          disk_datastore_id = "local-lvm"
          disk_file_format  = "raw"
          disk_size         = 20
          disk_interface    = "scsi1"
        },
        {
          disk_datastore_id = "local-lvm"
          disk_file_format  = "raw"
          disk_size         = 100
          disk_interface    = "scsi2"
        }
      ]
      tags = ["terraform", "ubuntu-22.04"]

      # Cloud Image
      cloud_image_content_type        = "iso"
      cloud_image_datastore_id        = "local"
      cloud_image_node_name           = "pve3"
      cloud_image_url                 = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
      cloud_image_file_name           = "jammy-server-cloudimg-amd64.img"
      cloud_image_overwrite           = false
      cloud_image_overwrite_unmanaged = false

      # Cloud Init
      cloud_init_content_type = "snippets"
      cloud_init_datastore_id = "pve-fs"
      cloud_init_node_name    = "pve3"
      hostname                = "control-plane-3"
      manage_etc_hosts        = true
      fqdn                    = "control-plane-3.domain.com"
      timezone                = "Europe/London"
      admin_username          = "admin"
      admin_password          = var.admin_password
      users = [
        {
          username            = "admin"
          uid                 = null
          gid                 = null
          groups              = ["adm", "cdrom", "dip", "plugdev", "lxd", "sudo"]
          sudo                = "ALL=(ALL) NOPASSWD:ALL"
          shell               = "/bin/bash"
          ssh_authorized_keys = var.ssh_authorized_keys
        },
        {
          username            = "ansible"
          uid                 = 10001
          gid                 = 10001
          groups              = ["wheel"]
          sudo                = "ALL=(ALL) NOPASSWD:ALL"
          shell               = "/bin/bash"
          ssh_authorized_keys = var.ssh_authorized_keys
        }
      ]
      package_upgrade = true
      packages        = ["qemu-guest-agent", "nfs-common"]
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
    }, # end of control-plane-3


    "worker-node-1" = {
      # VM
      name             = "worker-node-1"
      description      = "The work node responsible for running containerized applications."
      node_name        = "pve1"
      vm_id            = 161
      cpu_cores        = 2
      dedicated_memory = 8192
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
      ipv4_address          = "10.1.10.161/24"
      ipv4_gateway          = "10.1.10.1"
      dns_servers           = ["1.1.1.1", "8.8.8.8"]
      # VM: Boot Disk
      boot_disk_datastore_id = "local-lvm"
      boot_disk_interface    = "scsi0"
      boot_disk_size         = 60

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
      home_disk_block_device = "/dev/sdc"
      # VM: Attach disks, assign from scsi1 and up
      disks = [
        {
          disk_datastore_id = "local-lvm"
          disk_file_format  = "raw"
          disk_size         = 20
          disk_interface    = "scsi1"
        },
        {
          disk_datastore_id = "local-lvm"
          disk_file_format  = "raw"
          disk_size         = 100
          disk_interface    = "scsi2"
        }
      ]
      tags = ["terraform", "ubuntu-22.04"]

      # Cloud Image
      cloud_image_content_type        = "iso"
      cloud_image_datastore_id        = "local"
      cloud_image_node_name           = "pve1"
      cloud_image_url                 = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
      cloud_image_file_name           = "jammy-server-cloudimg-amd64.img"
      cloud_image_overwrite           = false
      cloud_image_overwrite_unmanaged = false

      # Cloud Init
      cloud_init_content_type = "snippets"
      cloud_init_datastore_id = "pve-fs"
      cloud_init_node_name    = "pve1"
      hostname                = "worker-node-1"
      manage_etc_hosts        = true
      fqdn                    = "worker-node-1.domain.com"
      timezone                = "Europe/London"
      admin_username          = "admin"
      admin_password          = var.admin_password
      users = [
        {
          username            = "admin"
          uid                 = null
          gid                 = null
          groups              = ["adm", "cdrom", "dip", "plugdev", "lxd", "sudo"]
          sudo                = "ALL=(ALL) NOPASSWD:ALL"
          shell               = "/bin/bash"
          ssh_authorized_keys = var.ssh_authorized_keys
        },
        {
          username            = "ansible"
          uid                 = 10001
          gid                 = 10001
          groups              = ["wheel"]
          sudo                = "ALL=(ALL) NOPASSWD:ALL"
          shell               = "/bin/bash"
          ssh_authorized_keys = var.ssh_authorized_keys
        }
      ]
      package_upgrade = true
      packages        = ["qemu-guest-agent", "nfs-common"]
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
    }, # end of worker-node-1

    "worker-node-2" = {
      # VM
      name             = "worker-node-2"
      description      = "The work node responsible for running containerized applications."
      node_name        = "pve2"
      vm_id            = 162
      cpu_cores        = 2
      dedicated_memory = 8192
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
      ipv4_address          = "10.1.10.162/24"
      ipv4_gateway          = "10.1.10.1"
      dns_servers           = ["1.1.1.1", "8.8.8.8"]
      # VM: Boot Disk
      boot_disk_datastore_id = "local-lvm"
      boot_disk_interface    = "scsi0"
      boot_disk_size         = 60

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
      home_disk_block_device = "/dev/sdc"
      # VM: Attach disks, assign from scsi1 and up
      disks = [
        {
          disk_datastore_id = "local-lvm"
          disk_file_format  = "raw"
          disk_size         = 20
          disk_interface    = "scsi1"
        },
        {
          disk_datastore_id = "local-lvm"
          disk_file_format  = "raw"
          disk_size         = 100
          disk_interface    = "scsi2"
        }
      ]
      tags = ["terraform", "ubuntu-22.04"]

      # Cloud Image
      cloud_image_content_type        = "iso"
      cloud_image_datastore_id        = "local"
      cloud_image_node_name           = "pve2"
      cloud_image_url                 = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
      cloud_image_file_name           = "jammy-server-cloudimg-amd64.img"
      cloud_image_overwrite           = false
      cloud_image_overwrite_unmanaged = false

      # Cloud Init
      cloud_init_content_type = "snippets"
      cloud_init_datastore_id = "pve-fs"
      cloud_init_node_name    = "pve2"
      hostname                = "worker-node-2"
      manage_etc_hosts        = true
      fqdn                    = "worker-node-2.domain.com"
      timezone                = "Europe/London"
      admin_username          = "admin"
      admin_password          = var.admin_password
      users = [
        {
          username            = "admin"
          uid                 = null
          gid                 = null
          groups              = ["adm", "cdrom", "dip", "plugdev", "lxd", "sudo"]
          sudo                = "ALL=(ALL) NOPASSWD:ALL"
          shell               = "/bin/bash"
          ssh_authorized_keys = var.ssh_authorized_keys
        },
        {
          username            = "ansible"
          uid                 = 10001
          gid                 = 10001
          groups              = ["wheel"]
          sudo                = "ALL=(ALL) NOPASSWD:ALL"
          shell               = "/bin/bash"
          ssh_authorized_keys = var.ssh_authorized_keys
        }
      ]
      package_upgrade = true
      packages        = ["qemu-guest-agent", "nfs-common"]
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
    }, # end of worker-node-2

    "worker-node-3" = {
      # VM
      name             = "worker-node-3"
      description      = "The work node responsible for running containerized applications."
      node_name        = "pve3"
      vm_id            = 163
      cpu_cores        = 2
      dedicated_memory = 8192
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
      ipv4_address          = "10.1.10.163/24"
      ipv4_gateway          = "10.1.10.1"
      dns_servers           = ["1.1.1.1", "8.8.8.8"]
      # VM: Boot Disk
      boot_disk_datastore_id = "local-lvm"
      boot_disk_interface    = "scsi0"
      boot_disk_size         = 60

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
      home_disk_block_device = "/dev/sdc"
      # VM: Attach disks, assign from scsi1 and up
      disks = [
        {
          disk_datastore_id = "local-lvm"
          disk_file_format  = "raw"
          disk_size         = 20
          disk_interface    = "scsi1"
        },
        {
          disk_datastore_id = "local-lvm"
          disk_file_format  = "raw"
          disk_size         = 100
          disk_interface    = "scsi2"
        }
      ]
      tags = ["terraform", "ubuntu-22.04"]

      # Cloud Image
      cloud_image_content_type        = "iso"
      cloud_image_datastore_id        = "local"
      cloud_image_node_name           = "pve3"
      cloud_image_url                 = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
      cloud_image_file_name           = "jammy-server-cloudimg-amd64.img"
      cloud_image_overwrite           = false
      cloud_image_overwrite_unmanaged = false

      # Cloud Init
      cloud_init_content_type = "snippets"
      cloud_init_datastore_id = "pve-fs"
      cloud_init_node_name    = "pve3"
      hostname                = "worker-node-3"
      manage_etc_hosts        = true
      fqdn                    = "worker-node-3.domain.com"
      timezone                = "Europe/London"
      admin_username          = "admin"
      admin_password          = var.admin_password
      users = [
        {
          username            = "admin"
          uid                 = null
          gid                 = null
          groups              = ["adm", "cdrom", "dip", "plugdev", "lxd", "sudo"]
          sudo                = "ALL=(ALL) NOPASSWD:ALL"
          shell               = "/bin/bash"
          ssh_authorized_keys = var.ssh_authorized_keys
        },
        {
          username            = "ansible"
          uid                 = 10001
          gid                 = 10001
          groups              = ["wheel"]
          sudo                = "ALL=(ALL) NOPASSWD:ALL"
          shell               = "/bin/bash"
          ssh_authorized_keys = var.ssh_authorized_keys
        }
      ]
      package_upgrade = true
      packages        = ["qemu-guest-agent", "nfs-common"]
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
    }, # end of worker-node-3
  }
}
