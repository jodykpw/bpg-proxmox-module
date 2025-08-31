<!-- BEGIN_TF_DOCS -->
# bpg-proxmox-module

This repository contains Terraform modules, based on [bpg/proxmox](https://registry.terraform.io/providers/bpg/proxmox/latest/docs), for provisioning virtual machines on Proxmox using Cloud-Init for configuration management. The modules provide reusable and configurable components that can be used to define and deploy virtual machines in a Proxmox environment.

#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 0.82.0 |

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 0.82.0 |

#### Modules

No modules.

#### Resources

| Name | Type |
|------|------|
| [proxmox_virtual_environment_download_file.cloud_image](https://registry.terraform.io/providers/bpg/proxmox/0.82.0/docs/resources/virtual_environment_download_file) | resource |
| [proxmox_virtual_environment_file.cloud_init](https://registry.terraform.io/providers/bpg/proxmox/0.82.0/docs/resources/virtual_environment_file) | resource |
| [proxmox_virtual_environment_vm.vms](https://registry.terraform.io/providers/bpg/proxmox/0.82.0/docs/resources/virtual_environment_vm) | resource |

#### Inputs

| Name | Description | Type |
|------|-------------|------|
| <a name="input_vms"></a> [vms](#input\_vms) | Map of VM configurations | <pre>map(object({<br>    name             = string<br>    description      = string<br>    node_name        = string<br>    vm_id            = number<br>    cpu_cores        = number<br>    dedicated_memory = number<br>    cpu_sockets      = number<br>    cpu_numa         = bool<br>    cpu_limit        = number<br>    cpu_type         = string<br>    bios             = string<br>    machine          = string<br>    agent_enabled    = bool<br>    agent_timeout    = string<br>    startup = optional(object({<br>      order      = number<br>      up_delay   = number<br>      down_delay = number<br>    }))<br>    operating_system_type  = string<br>    scsi_hardware          = string<br>    vga_memory             = number<br>    vga_type               = string<br>    tpm_enable             = bool<br>    tpm_datastore_id       = string<br>    tpm_version            = string<br>    network_device_bridge  = string<br>    ipv4_address           = string<br>    ipv4_gateway           = string<br>    dns_servers            = list(string)<br>    boot_disk_datastore_id = string<br>    boot_disk_interface    = string<br>    boot_disk_size         = number<br>    home_disk_block_device = string<br>    disks = list(object({<br>      disk_datastore_id = string<br>      disk_file_format  = string<br>      disk_size         = number<br>      # assign from scsi1 and up<br>      disk_interface = string<br>    }))<br>    tags = list(string)<br>    # Cloud Image<br>    cloud_image_node_name           = string<br>    cloud_image_content_type        = string<br>    cloud_image_datastore_id        = string<br>    cloud_image_url                 = string<br>    cloud_image_file_name           = string<br>    cloud_image_overwrite           = bool<br>    cloud_image_overwrite_unmanaged = bool<br>    # Cloud Init<br>    cloud_init_content_type = string<br>    cloud_init_datastore_id = string<br>    cloud_init_node_name    = string<br>    hostname                = string<br>    manage_etc_hosts        = bool<br>    fqdn                    = string<br>    timezone                = string<br>    admin_username          = string<br>    admin_password          = optional(string)<br>    users = list(object({<br>      username            = string<br>      uid                 = optional(number)<br>      gid                 = optional(number)<br>      groups              = list(string)<br>      sudo                = string<br>      shell               = string<br>      ssh_authorized_keys = list(string)<br>    }))<br>    package_upgrade         = bool<br>    packages                = list(string)<br>    runcmd                  = list(string)<br>  }))</pre> |
For a complete list of inputs and their descriptions for the Proxmox provider, refer to the [Proxmox Provider Documentation](https://registry.terraform.io/providers/bpg/proxmox/latest/docs).

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The virtual machine identifier. |
| <a name="output_ipv4_addresses"></a> [ipv4\_addresses](#output\_ipv4\_addresses) | The IPv4 addresses per network interface published by the QEMU agent (empty list when agent.enabled is false) |
| <a name="output_ipv6_addresses"></a> [ipv6\_addresses](#output\_ipv6\_addresses) | The IPv6 addresses per network interface published by the QEMU agent (empty list when agent.enabled is false) |
| <a name="output_mac_addresses"></a> [mac\_addresses](#output\_mac\_addresses) | The MAC addresses published by the QEMU agent with fallback to the network device configuration, if the agent is disabled |
| <a name="output_network_interface_names"></a> [network\_interface\_names](#output\_network\_interface\_names) | The network interface names published by the QEMU agent (empty list when agent.enabled is false) |

#### Usage
##### provider.tf
```hcl
terraform {
  required_version = ">= 0.14"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.63.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.virtual_environment_endpoint
  username = var.virtual_environment_username
  password = var.virtual_environment_password
  # because self-signed TLS certificate is in use
  insecure = true
  # uncoment (unless on Windows...)
  # tmp_dir  = "/var/tmp"
}
``` 
##### main.tf
```hcl
module "proxmox_vms" {
  source  = "gitlab.domain.com/terraform-modules/bpg-proxmox-module/proxmox"
  version = "1.0.0"
  vms     = local.vm_configurations
}
``` 
##### local.tf
```hcl
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
```   
##### variables.tf
```hcl
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
    admin_username          = string
    admin_password          = optional(string)
    users = list(object({
      username            = string
      uid                 = optional(number)
      gid                 = optional(number)
      groups              = list(string)
      sudo                = string
      shell               = string
      ssh_authorized_keys = list(string)
    }))
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
      admin_username                  = "ubuntu"
      # admin_password can be provided optionally per VM
      users = [
        {
          username            = "ubuntu"
          uid                 = null
          gid                 = null
          groups              = ["adm", "cdrom", "dip", "plugdev", "lxd", "sudo"]
          sudo                = "ALL=(ALL) NOPASSWD:ALL"
          shell               = "/bin/bash"
          ssh_authorized_keys = []
        },
        {
          username            = "ansible"
          uid                 = 10001
          gid                 = 10001
          groups              = ["wheel"]
          sudo                = "ALL=(ALL) NOPASSWD:ALL"
          shell               = "/bin/bash"
          ssh_authorized_keys = []
        }
      ]
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
output "vm_info" {
  value = {
    for vm_name, vm_config in local.vm_configurations :
    vm_name => {
      id                      = module.proxmox_vms.id[vm_name]
      ipv4_addresses          = module.proxmox_vms.ipv4_addresses[vm_name]
      ipv6_addresses          = module.proxmox_vms.ipv6_addresses[vm_name]
      mac_addresses           = module.proxmox_vms.mac_addresses[vm_name]
      network_interface_names = module.proxmox_vms.network_interface_names[vm_name]
    }
  }
  description = "Information about virtual machines including ID, IP addresses, MAC addresses, and network interface names."
}
```  
##### outputs.tf
```hcl
output "vm_info" {
  value = {
    for vm_name, vm_config in local.vm_configurations :
    vm_name => {
      id                      = module.proxmox_vms.id[vm_name]
      ipv4_addresses          = module.proxmox_vms.ipv4_addresses[vm_name]
      ipv6_addresses          = module.proxmox_vms.ipv6_addresses[vm_name]
      mac_addresses           = module.proxmox_vms.mac_addresses[vm_name]
      network_interface_names = module.proxmox_vms.network_interface_names[vm_name]
    }
  }
  description = "Information about virtual machines including ID, IP addresses, MAC addresses, and network interface names."
}
```  

## 📜 License

MIT

## 🇬🇧 Modifier

* Modified by: Jody WAN
* Linkedin: https://www.linkedin.com/in/jodywan/
* Website: https://www.jodywan.com
<!-- END_TF_DOCS -->