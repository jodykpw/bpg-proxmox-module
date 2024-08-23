# Proxmox Provider
# Hard-coding credentials into any Terraform configuration is not recommended, 
# and risks secret leakage should this file ever be committed to a public version control system.
variable "virtual_environment_endpoint" {
  type        = string
  description = "This is the URL endpoint for connecting to your Proxmox server. "
}

variable "virtual_environment_username" {
  description = "This is the username used to authenticate to the Proxmox server."
  type        = string
}

variable "virtual_environment_password" {
  description = "This is the password associated with the provided username for authentication."
  type        = string
}

# Cloud-Init
variable "ssh_authorized_keys" {
  type        = list(string)
  description = "The ssh_authorized_keys is a configuration option in cloud-init that allows you to specify a list of SSH public keys. When cloud-init runs during the instance initialization process, it adds these public keys to the ~/.ssh/authorized_keys file of the specified user, granting them SSH access to the instance."
}
