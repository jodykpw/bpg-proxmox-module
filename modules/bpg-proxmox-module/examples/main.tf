module "proxmox_vms" {
  source  = "gitlab.domain.com/terraform-modules/bpg-proxmox-module/proxmox"
  version = "1.0.0"
  vms     = local.vm_configurations
}
