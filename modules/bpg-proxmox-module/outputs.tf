output "id" {
  value = {
    for vm_name, vm_config in var.vms :
    vm_name => proxmox_virtual_environment_vm.vms[vm_name].id
  }
  description = "The virtual machine identifier."
}

output "ipv4_addresses" {
  value = {
    for vm_name, vm_config in var.vms :
    vm_name => proxmox_virtual_environment_vm.vms[vm_name].ipv4_addresses
  }
  description = "The IPv4 addresses per network interface published by the QEMU agent (empty list when agent.enabled is false)"
}

output "ipv6_addresses" {
  value = {
    for vm_name, vm_config in var.vms :
    vm_name => proxmox_virtual_environment_vm.vms[vm_name].ipv6_addresses
  }
  description = "The IPv6 addresses per network interface published by the QEMU agent (empty list when agent.enabled is false)"
}

output "mac_addresses" {
  value = {
    for vm_name, vm_config in var.vms :
    vm_name => proxmox_virtual_environment_vm.vms[vm_name].mac_addresses
  }
  description = "The MAC addresses published by the QEMU agent with fallback to the network device configuration, if the agent is disabled"
}

output "network_interface_names" {
  value = {
    for vm_name, vm_config in var.vms :
    vm_name => proxmox_virtual_environment_vm.vms[vm_name].network_interface_names
  }
  description = "The network interface names published by the QEMU agent (empty list when agent.enabled is false)"
}
