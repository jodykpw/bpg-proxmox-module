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
