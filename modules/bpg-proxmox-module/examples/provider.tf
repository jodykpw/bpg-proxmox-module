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
