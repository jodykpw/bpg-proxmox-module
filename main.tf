module "proxmox_vms" {
  source = "./modules/bpg-proxmox-module"
  vms    = local.vm_configurations
}
