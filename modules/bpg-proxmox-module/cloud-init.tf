resource "proxmox_virtual_environment_file" "cloud_init" {
  for_each = var.vms

  content_type = each.value.cloud_init_content_type
  datastore_id = each.value.cloud_init_datastore_id
  node_name    = each.value.cloud_init_node_name

  source_raw {
    data = <<EOF
#cloud-config
hostname: ${each.value.hostname}
manage_etc_hosts: ${each.value.manage_etc_hosts}
fqdn: ${each.value.fqdn}
timezone: ${each.value.timezone}
chpasswd:
  ## Forcing user to change the default password at first login
  expire: true
  users:
    - name: ${each.value.username}
      password: password
      type: text
write_files:
  - path: /tmp/home_disk_setup.sh
    content: |
      #!/bin/bash
      BLOCK_DEVICE=${each.value.home_disk_block_device}
      echo -e "n\np\n\n\n\nw" | sudo fdisk $BLOCK_DEVICE
      mkfs.xfs $(echo $BLOCK_DEVICE)1
      mkdir /mnt/new_home/
      mount $(echo $BLOCK_DEVICE)1 /mnt/new_home/
      rsync -avh /home/ /mnt/new_home/
      UUID=$(blkid $(echo $BLOCK_DEVICE)1 | awk '{print $2}' | sed 's/"//g')
      echo "$UUID /mnt/new_home xfs defaults 0 0" | sudo tee -a /etc/fstab
users:
  - name: ${each.value.username}
    groups: "${join(", ", each.value.groups)}"
    sudo: "${join(", ", each.value.sudo_config)}"
    shell: /bin/bash
    ssh_authorized_keys:
    ${join("\n", ["  - ${join("\n      - ", each.value.ssh_authorized_keys)}"])}
package_upgrade: ${each.value.package_upgrade}
${length(each.value.packages) > 0 ? "packages:\n${join("\n", [for pkg in each.value.packages : "  - ${pkg}"])}" : ""}
${length(each.value.runcmd) > 0 ? "runcmd:\n${join("\n", [for cmd in each.value.runcmd : "  - ${cmd}"])}" : ""}
power_state:
    delay: now
    mode: reboot
    message: Rebooting after cloud-init completion
    condition: true
EOF

    file_name = "vm-${each.value.name}-cloud-init.yaml"
  }
}